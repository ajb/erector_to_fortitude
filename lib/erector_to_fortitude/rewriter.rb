require 'pry'

module ErectorToFortitude
  class Rewriter < Parser::Rewriter
    def on_send(node)
      # Why is this necessary?
      return unless node.children.length > 1

      # How do I explain this? lol
      return unless node.children[0]

      tag_node = get_first_node(node.children[0])

      # The tag method is an instance method
      return unless tag_node.children[0] == nil

      # Validate tag name
      return unless ErectorToFortitude::HTML_TAGS.include?(tag_node.children[1].to_s)

      ids = []
      classes = []

      get_classes_and_ids_sent(node).each do |class_or_id|
        if class_or_id[-1] == '!'
          ids << class_or_id[0..-2]
        else
          classes << class_or_id
        end
      end

      new_opts = []

      if classes.length > 0
        new_opts << %{class: '#{classes.join(' ')}'}
      end

      if ids.length > 0
        new_opts << %{id: '#{ids.join(' ')}'}
      end

      new_opt_str = new_opts.join(', ')

      # Replace the existing dots
      get_sends(node).each do |child|
        replace child.loc.dot, ''
        replace child.loc.selector, ''
      end

      if (text_node = get_node_after_classes_and_ids(node)) && text_node.is_a?(Parser::AST::Node) && text_node.type != :hash

        insert_after text_node.loc.expression, ', ' + new_opt_str

      # Add class to existing hash
      elsif node.children[2] && node.children[2].type == :hash
        insert_before node.children[2].children[0].loc.expression, new_opt_str + ', '

      # Add a new options hash
      else
        # Remove the dot
        insert_after node.loc.selector, "(#{new_opt_str})"
      end
    end

    def get_first_node(node)
      while node.children[0].is_a?(Parser::AST::Node) && node.children[0].type == :send
        node = node.children[0]
      end

      node
    end

    def get_sends(node)
      arr = []

      while node.children[0] && node.children[0].type == :send
        arr << node
        node = node.children[0]
      end

      arr
    end

    def get_classes_and_ids_sent(node)
      arr = []

      while node.children[0] && node.children[0].type == :send
        arr << node.children[1]
        node = node.children[0]
      end

      arr.reverse
    end

    def get_node_after_classes_and_ids(node)
      found_classes_and_ids = false

      node.children.each do |child|
        if child.is_a?(Symbol)
          found_classes_and_ids = true
        end

        if found_classes_and_ids && !child.is_a?(Symbol)
          return child
        end
      end
    end
  end
end
