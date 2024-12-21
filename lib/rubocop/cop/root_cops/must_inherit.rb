module RuboCop
  module Cop
    module RootCops
      # Classes in this directory must inherit from a specific class
      #
      # @example
      #
      # Given the following config:
      # RootCops/MustInherit:
      #   Mapping:
      #     - Dir: engines/claims/app/jobs/
      #       ParentClass: ClaimsJob
      #
      #   # bad
      #   class BackfillClaimJob < ApplicationJob # ...
      #
      #   # good
      #   class BackfillClaimJob < ClaimsJob # ...
      #
      # It's also possible to configure multiple options
      # RootCops/MustInherit:
      #   Mapping:
      #     - Dir: engines/claims/app/jobs/
      #       ParentClass:
      #         - ResqueJob
      #         - ShoryukenJob

      class MustInherit < Cop
        # entirely so i can stub this in the tests
        def self.expand_path(filename)
          File.expand_path(filename)
        end

        def investigate(processed_source)
          @source_file_path = self.class.expand_path(processed_source.buffer.name)
        end

        def on_class(node)
          return unless (class_options = class_options_for_current_file)

          class_name = node.identifier.const_name
          superclass_name = node.parent_class&.const_name
          unless class_name_match?(class_name, superclass_name, class_options)
            add_offense(node, location: :expression, message: "Classes in this directory must inherit from #{class_options_to_s(class_options)}")
          end
        end

        def mapping
          @mapping ||= (cop_config["Mapping"] || []).map do |config|
            {
              glob: File.join("**", config["Dir"], "*.rb"),
              parent_class_options: [config["ParentClass"]].flatten
            }
          end
        end

        def class_options_for_current_file
          mapping.detect { |m| File.fnmatch?(m[:glob], @source_file_path) }&.fetch(:parent_class_options)
        end

        # return true if current class is one of the options or inherits from one of the options
        def class_name_match?(class_name, superclass_name, class_options)
          class_options.include?(class_name.to_s) || class_options.include?(superclass_name.to_s)
        end

        def class_options_to_s(class_options)
          class_options.join(" or ")
        end
      end
    end
  end
end
