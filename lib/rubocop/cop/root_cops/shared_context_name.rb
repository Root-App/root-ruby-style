module RuboCop
  module Cop
    module RootCops
      class SharedContextName < RuboCop::Cop::Base
        PREFIX_OR_MATCH = "Shared context name should match file name or be prefixed with (filename)__".freeze

        def on_new_investigation
          file_path = processed_source.buffer.name
          return unless /shared_contexts/.match?(file_path)

          file_paths = File.expand_path(file_path).chomp(".rb").split("/")
          relevant_paths = file_paths[(file_paths.index("shared_contexts") + 1)..-1]
          @base_name = File.basename(file_path, ".rb")
          @expected_context_prefix = relevant_paths.join("__") + "__"
        end

        def on_send(node)
          return unless @expected_context_prefix

          _receiver, method_name, *args = *node
          return unless method_name == :shared_context

          method_args = *args[0]
          context_name = method_args[0].to_s
          unless context_name == @base_name || context_name.start_with?(@expected_context_prefix)
            add_offense(node.loc.expression, message: PREFIX_OR_MATCH)
          end
        end
      end
    end
  end
end
