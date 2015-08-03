module ErectorToFortitude
  class Rewriter < Parser::Rewriter
    def on_send(node)
      if node.children.length > 1 &&
         node.children[0] &&
         node.children[0].type == :send &&
         node.children[0].children[0] == nil &&
         node.children[0].children[1] == :div

        # Remove the dot
        replace node.loc.dot, ''

        if node.children[1].to_s[-1] == '!'
          new_code = '(id: "' + node.children[1].to_s[0..-2] + '")'
        else
          new_code = '(class: "' + node.children[1].to_s + '")'
        end

        replace node.loc.selector, new_code
      end
    end
  end
end
