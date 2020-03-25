RSpec.describe RuboCop::Cop::RootCops::MustInherit, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      "Mapping" => [
        {
          "Dir" => "app/jobs",
          "ParentClass" => "MyJob"
        }
      ]
    }
  end

  around do |example|
    before = RuboCop::ConfigLoader.default_configuration[described_class.cop_name]
    RuboCop::ConfigLoader.default_configuration[described_class.cop_name] = {}
    example.run
    RuboCop::ConfigLoader.default_configuration[described_class.cop_name] = before
  end

  context "when the class is inside a configured directory" do
    before do
      allow(described_class).to receive(:expand_path).and_return("/home/me/app/jobs/greetings_job.rb")
    end

    it "reports an offense when the class doesn't inherit from configured class" do
      expect_offense(<<~RUBY.strip_indent)
        class GreetingsJob < ApplicationJob
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Classes in this directory must inherit from MyJob
        end
      RUBY
    end

    it "reports an offense when the class doesn't inherit from anything" do
      expect_offense(<<~RUBY.strip_indent)
        class GreetingsJob
        ^^^^^^^^^^^^^^^^^^ Classes in this directory must inherit from MyJob
        end
      RUBY
    end

    it "reports no offenses when the class is the parent class definition" do
      expect_no_offenses(<<~RUBY.strip_indent)
        class MyJob < ApplicationJob
        end
      RUBY
    end

    it "reports no offense when specifies the proper class" do
      expect_no_offenses(<<~RUBY.strip_indent)
        class GreetingsJob < MyJob
        end
      RUBY
    end

    it "doesn't get messed up by class contents" do
      expect_offense(<<~RUBY.strip_indent)
        class GreetingsJob < ApplicationJob
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Classes in this directory must inherit from MyJob
          queue_as :super_high_priority

          def perform(*args)
          end
        end
      RUBY
    end
  end

  context "when the class is not inside a configured directory" do
    before do
      allow(described_class).to receive(:expand_path).and_return("/home/me/app/controllers/greetings_controller.rb")
    end

    it "reports no offense" do
      expect_no_offenses(<<~RUBY.strip_indent)
        class GreetingsController < ApplicationController
        end
      RUBY
    end
  end
end
