module ErectorToFortitude
  class Converter
    def self.convert(code)
      buffer = Parser::Source::Buffer.new('(example)')
      buffer.source = code
      parser = Parser::CurrentRuby.new
      ast = parser.parse(buffer)
      rewriter = Rewriter.new

      rewriter.rewrite(buffer, ast)
    end
  end
end
