module RuboCop
  module Cop
    module RootCops
      class EnvvarAssignment < Cop
        MSG = "Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method".freeze

        def_node_search :envvar_assignment?, "(send (const _ :ENVVARS) :[] (:str _))"

        def investigate(processed_source)
          file_path = processed_source.file_path
          @is_initializer_file = file_path.include?("/initializers/")
        end

        def on_casgn(node)
          _scope, _const_name, value = *node

          return if value.nil?
          return if @is_initializer_file

          add_offense(node, location: :expression, message: MSG) if envvar_assignment?(value)
        end

        def on_or_asgn(node)
          lhs, value = *node

          return unless lhs&.casgn_type?
          return if @is_initializer_file

          add_offense(node, location: :expression, message: MSG) if envvar_assignment?(value)
        end
      end
    end
  end
end
