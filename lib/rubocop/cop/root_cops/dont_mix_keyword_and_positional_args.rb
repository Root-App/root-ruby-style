module RuboCop
  module Cop
    module RootCops
      class DontMixKeywordAndPositionalArgs < Cop
        POSITIONAL_ARG_TYPES = %i[arg optarg restarg].freeze
        KEYWORD_ARG_TYPES = %i[kwarg kwoptarg kwsplat kwrestarg].freeze
        ERROR = "Do not mix keyword args and positional args".freeze

        def on_def(node)
          arguments = node.arguments&.children
          
          return unless arguments.any? {|a| POSITIONAL_ARG_TYPES.include?(a.type) } && arguments.any? {|a| KEYWORD_ARG_TYPES.include?(a.type) }
    
          add_offense(node, :location => :expression, :message => ERROR)
        end
      end
    end
  end
end