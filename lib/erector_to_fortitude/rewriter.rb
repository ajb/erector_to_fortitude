require 'pry'

module ErectorToFortitude
  class Rewriter < Parser::Rewriter
    def on_send(node)
      if node.children.length > 1 &&
         node.children[0] &&
         node.children[0].type == :send &&
         node.children[0].children[0] == nil &&
         node.children[0].children[1] == :div

        is_id = node.children[1].to_s[-1] == '!'
        id_or_class_name = node.children[1].to_s.sub(/\!$/, '')
        new_pair = if is_id
                     %{id: "#{id_or_class_name}"}
                   else
                     %{class: "#{id_or_class_name}"}
                   end

        # Add class to existing hash
        if node.children[2] && node.children[2].type == :hash
          replace node.loc.dot, ''
          replace node.loc.selector, ''

          insert_before node.children[2].children[0].loc.expression, new_pair + ', '
        # Add a new options hash
        else
          # Remove the dot
          replace node.loc.dot, ''
          replace node.loc.selector, "(#{new_pair})"
        end
      end
    end
  end
end
