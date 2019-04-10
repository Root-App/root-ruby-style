require "active_support/inflector"

module Helpers
  module Factories
    def self.file_name_has_error?(file_name)
      !_word_pluralized?(file_name.split("_").last)
    end

    private

    def self._word_pluralized?(word)
      word == word.pluralize
    end
  end
end
