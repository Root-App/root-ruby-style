# frozen_string_literal: true

module RuboCop
  module Cop
    module RootCops
      class AvoidRubyProf < RuboCop::Cop::Base
        ERROR = ":ruby_prof is for local use only and should not be committed."
        FILE_NAME_MATCHER = /_spec\.rb\z/

        def_node_matcher :spec_block?, <<~PATTERN
          (send nil? {:describe :context :it} ...)
        PATTERN

        def on_new_investigation
          @in_spec_file = processed_source.file_path =~ FILE_NAME_MATCHER
        end

        def on_sym(node)
          return unless @in_spec_file && node.value == :ruby_prof && spec_block?(node.parent)

          add_offense(node.loc.expression, message: ERROR)
        end
      end
    end
  end
end
