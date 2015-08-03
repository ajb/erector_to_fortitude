require 'spec_helper'

RSpec.describe ErectorToFortitude::Converter do
  it 'converts a basic class send' do
    input = <<END
def content
  div.foo {
    text 'hi'
  }
end
END

    output = code = <<END
def content
  div(class: "foo") {
    text 'hi'
  }
end
END

    expect(described_class.convert(input)).to eq output
  end

  it 'converts a basic id send' do
    input = <<END
def content
  div.foo! {
    text 'hi'
  }
end
END

    output = code = <<END
def content
  div(id: "foo") {
    text 'hi'
  }
end
END

    expect(described_class.convert(input)).to eq output
  end
end
