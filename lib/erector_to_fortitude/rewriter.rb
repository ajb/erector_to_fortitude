module ErectorToFortitude
  class Rewriter < Parser::Rewriter
    def on_send(node)
      if node.children.length > 1 &&
         node.children[0] &&
         node.children[0].type == :send &&
         node.children[0].children[0] == nil &&
         node.children[0].children[1] == :div

        replace node.loc.dot, ''
        replace node.loc.selector, '(class: "' + node.children[1].to_s + '")'
      end
    end
  end
end
