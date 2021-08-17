RSpec.describe RuboCop::Cop::RootCops::MustInclude, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      "Mapping" => [
        {
          "Dir" => "app/jobs",
          "Module" => "MyJobConcern"
        },
        {
          "Dir" => "systems/**/app/models",
          "Module" => "MyModelConcern"
        }
      ]
    }
  end

  around do |example|
    config_before = RuboCop::ConfigLoader.default_configuration[described_class.cop_name]
    RuboCop::ConfigLoader.default_configuration[described_class.cop_name] = {}
    example.run
    RuboCop::ConfigLoader.default_configuration[described_class.cop_name] = config_before
  end

  context "when the class is inside a configured directory" do
    before do
      allow(described_class).to receive(:expand_path).and_return("/home/me/app/jobs/greetings_job.rb")
    end

    it "reports an offense when the class doesn't include configured module" do
      expect_offense(<<~RUBY)
        class GreetingsJob < ApplicationJob
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Classes in this directory must include MyJobConcern module
        end
      RUBY
    end

    it "reports no offenses when the file is the module definition" do
      expect_no_offenses(<<~RUBY)
        module MyJobConcern
        end
      RUBY
    end

    it "reports no offense when including the proper module" do
      expect_no_offenses(<<~RUBY)
        class GreetingsJob < MyJob
          include MyJobConcern
        end
      RUBY
    end
  end

  context "when the class is inside a globbed directory" do
    before do
      allow(described_class).to receive(:expand_path).and_return("/home/me/systems/cops/app/models/greeting.rb")
    end

    it "reports an offense when the class doesn't include configured module" do
      expect_offense(<<~RUBY)
        class Greeting < ActiveRecord::Base
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Classes in this directory must include MyModelConcern module
        end
      RUBY
    end

    it "reports no offenses on the module definition" do
      expect_no_offenses(<<~RUBY)
        module MyModelConcern
          def includeme
            puts "I like turtles"
          end
        end
      RUBY
    end

    it "reports no offense when including the proper module" do
      expect_no_offenses(<<~RUBY)
        class Greeting < MyRecord
          include MyModelConcern
        end
      RUBY
    end
  end

  context "when the class is not inside a configured directory" do
    before do
      allow(described_class).to receive(:expand_path).and_return("/home/me/app/controllers/greetings_controller.rb")
    end

    it "reports no offense" do
      expect_no_offenses(<<~RUBY)
        class GreetingsController < ApplicationController
        end
      RUBY
    end
  end

  context "when the module to be included is module nested" do
    let(:cop_config) do
      {
        "Mapping" => [
          {
            "Dir" => "app/jobs",
            "Module" => "FancyJobs::IncludeMe"
          }
        ]
      }
    end

    before do
      allow(described_class).to receive(:expand_path).and_return("/home/me/app/jobs/hello_job.rb")
    end

    it "reports an offence when no modules are included" do
      expect_offense(<<~RUBY)
        class HelloJob
        ^^^^^^^^^^^^^^ Classes in this directory must include FancyJobs::IncludeMe module
        end
      RUBY
    end

    it "reports an offence when the wrong module is included" do
      expect_offense(<<~RUBY)
        class HelloJob
        ^^^^^^^^^^^^^^ Classes in this directory must include FancyJobs::IncludeMe module
          include IncludeMe
        end
      RUBY
    end

    it "reports an offence when another wrong module is included" do
      expect_offense(<<~RUBY)
        class HelloJob
        ^^^^^^^^^^^^^^ Classes in this directory must include FancyJobs::IncludeMe module
          include FancyJobs
        end
      RUBY
    end

    it "reports an offence when proper module is included" do
      expect_no_offenses(<<~RUBY)
        class HelloJob
          include FancyJobs::IncludeMe
        end
      RUBY
    end

    it "reports an offence when proper module is included along with other modules" do
      expect_no_offenses(<<~RUBY)
        class HelloJob
          include FancyJobs
          include FancyJobs::IncludeMe
          include OtherStuff
        end
      RUBY
    end
  end
end
