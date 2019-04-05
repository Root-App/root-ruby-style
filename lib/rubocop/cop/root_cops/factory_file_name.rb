require "pry"

module RuboCop
  module Cop
    module RootCops
      class FactoryFileName < Cop
        FILE_NAME_ERROR = "Factory name should match file name".freeze

        def investigate(processed_source)
          file_path = processed_source.buffer.name
          @base_file_name = File.basename(file_path, ".rb")
        end

        def on_send(node)
          method_name = node.method_name
          return unless _factory_method?(method_name)

          factory_symbol_name = *node.arguments[0]
          factory_name = factory_symbol_name[0].id2name.split("__").first

          if factory_name != @base_file_name
            add_offense(node, :location => :expression, :message => FILE_NAME_ERROR)
          end
        end

        private

        def _factory_method?(method)
          method == :factory
        end
      end
    end
  end
end
