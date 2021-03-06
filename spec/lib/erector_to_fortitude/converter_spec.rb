require 'spec_helper'

RSpec.describe ErectorToFortitude::Converter do
  it 'converts a basic class send' do
    input = <<END
  div.foo {
    text 'hi'
  }
END

    output = code = <<END
  div(class: 'foo') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'converts multiple classes' do
    input = <<END
  div.foo.bar.baz {
    text 'hi'
  }
END

    output = code = <<END
  div(class: 'foo bar baz') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'converts on non-div tags' do
    input = <<END
  span.foo {
    text 'hi'
  }
END

    output = code = <<END
  span(class: 'foo') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'ignores non-erector stuffs' do
    input = <<END
  span {
    foos = Foo.with_deleted.all
    text foos.count
    bar.baz!
  }
END

    output = code = <<END
  span {
    foos = Foo.with_deleted.all
    text foos.count
    bar.baz!
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'converts a basic id send' do
    input = <<END
  div.foo! {
    text 'hi'
  }
END

    output = code = <<END
  div(id: 'foo') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles existing hash options' do
    input = <<END
  div.foo('data-bar' => 'baz') {
    text 'hi'
  }
END

    output = code = <<END
  div(class: 'foo', 'data-bar' => 'baz') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles complex existing hash options' do
    input = <<END
  div.foo.bar.baz.booz!('data-bar' => 'baz') {
    text 'hi'
  }
END

    output = code = <<END
  div(class: 'foo bar baz', id: 'booz', 'data-bar' => 'baz') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles a text argument' do
    input = <<END
  span.foo 'Bar'
END

    output = code = <<END
  span 'Bar', class: 'foo'
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles a text argument with existing hash' do
    input = <<END
  span.foo 'bar', 'data-baz' => 'booz'
END

    output = code = <<END
  span 'bar', class: 'foo', 'data-baz' => 'booz'
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles a dynamic text argument' do
    input = <<END
  span.foo x, 'data-baz' => 'booz'
END

    output = code = <<END
  span x, class: 'foo', 'data-baz' => 'booz'
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles a complex dynamic text argument' do
    input = <<END
  span.foo x.z.y(yeah: 'man'), 'data-baz' => 'booz'
END

    output = code = <<END
  span x.z.y(yeah: 'man'), class: 'foo', 'data-baz' => 'booz'
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles a text argument inside another node' do
    input = <<END
  div.bar {
    span.foo x
  }
END

    output = code = <<END
  div(class: 'bar') {
    span x, class: 'foo'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles empty tags' do
    input = <<END
  div.bar
END

    output = code = <<END
  div(class: 'bar')
END

    expect(described_class.convert(input)).to eq output
  end

  it 'handles code within an inline widget' do
    input = <<END
  Erector.inline {
    div.foo 'bar'
  }
END

    output = code = <<END
  Erector.inline {
    div 'bar', class: 'foo'
  }
END

    expect(described_class.convert(input)).to eq output
  end

  # known issue
  xit 'handles code inside proc values' do
    input = <<END
bar({
  proc: -> {
    a.button.primary 'hi'
  }
})
END

  output = code = <<END
bar({
  proc: -> {
    a 'hi', class: 'button primary'
  }
})
END

    expect(described_class.convert(input)).to eq output
  end
end
