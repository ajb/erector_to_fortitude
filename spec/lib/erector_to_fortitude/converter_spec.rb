require 'spec_helper'

RSpec.describe ErectorToFortitude::Converter do
  it 'converts a basic class send' do
    input = <<END
  div.foo {
    text 'hi'
  }
END

    output = code = <<END
  div(class: "foo") {
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
  span(class: "foo") {
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
  div(id: "foo") {
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
  div(class: "foo", 'data-bar' => 'baz') {
    text 'hi'
  }
END

    expect(described_class.convert(input)).to eq output
  end
end
