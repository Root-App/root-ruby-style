require "active_support/inflector"
require_relative "../../../helpers/factories"

module RuboCop
  module Cop
    module RootCops
      module Factories
        class FactoryName < Cop
          SYSTEM_IN_PATH = %r{systems/([^/]+)/}.freeze

          def investigate(processed_source)
            file_path = processed_source.buffer.name
            system_name_match = file_path.match(SYSTEM_IN_PATH)

            @system_name = system_name_match && system_name_match[1]
            @base_file_name = File.basename(file_path, ".rb")
            @base_file_name_body = _generate_body(@base_file_name)
            @base_file_name_last_word = @base_file_name.split("_").last
          end

          def on_send(node)
            return if _file_name_has_error?

            _, method_name = *node

            return unless _factory_method?(method_name)

            factory_symbol_name = *node.arguments[0]
            factory_name_array = factory_symbol_name[0].id2name.split("__")
            factory_name_array.shift if factory_name_array.size > 1 && factory_name_array[0] == @system_name

            factory_name = factory_name_array.first
            factory_name_body = _generate_body(factory_name)
            factory_name_last_word = factory_name.split("_").last

            if factory_name_array.size > 1
              if factory_name_array[0] != @base_file_name
                add_offense(
                  node,
                  :location => :expression,
                  :message => "Factory name uses incorrect prefix, should be '#{@base_file_name}__#{factory_name_array[1]}'."
                )
              end

            elsif (factory_name_body != @base_file_name_body) || (factory_name_last_word.pluralize != @base_file_name_last_word)
              add_offense(
                node,
                :location => :expression,
                :message => "Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with '#{@base_file_name}__'."
              )
            end
          end

          private

          def _factory_method?(method)
            method == :factory
          end

          def _file_name_has_error?
            Helpers::Factories.file_name_has_error?(@base_file_name)
          end

          def _generate_body(word)
            words = word.split("_")
            words.slice(0, words.size - 1).join("_")
          end
        end
      end
    end
  end
end
