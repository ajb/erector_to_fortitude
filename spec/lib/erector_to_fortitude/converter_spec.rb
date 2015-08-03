require 'spec_helper'

RSpec.describe ErectorToFortitude::Converter do
  it 'converts' do
    input = <<END
class Views::Home::Index < Views::Layouts::Application
  def render_layout
    div.foo {
      text 'hi'
    }
  end
end
END

    output = code = <<END
class Views::Home::Index < Views::Layouts::Application
  def render_layout
    div(class: "foo") {
      text 'hi'
    }
  end
end
END

    expect(described_class.convert(input)).to eq output
  end
end
