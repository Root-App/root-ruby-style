RSpec.shared_examples_for "registers an offense" do |offending_form, error_message|
  it "when using '#{offending_form}'" do
    offenses = inspect_source(<<-RUBY)
      #{offending_form}
    RUBY

    expect(offenses.size).to eq(1)
    expect(offenses.first.message).to eq(error_message)
  end
end

RSpec.shared_examples_for "does not register an offense" do |valid_form|
  it "when using #{valid_form}" do
    expect_no_offenses(<<~RUBY)
      #{valid_form}
    RUBY
  end
end
