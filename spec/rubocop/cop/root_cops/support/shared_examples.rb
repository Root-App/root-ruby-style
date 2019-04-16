RSpec.shared_examples_for "registers an offense" do |offending_form, error_message|
  it "when using '#{offending_form}'" do
    inspect_source(<<-RUBY.strip_indent)
      #{offending_form}
    RUBY
    expect(cop.offenses.size).to eq(1)

    offense = cop.offenses.first
    expect(offense.message).to eq(error_message)
  end
end

RSpec.shared_examples_for "does not register an offense" do |valid_form|
  it "when using #{valid_form}" do
    expect_no_offenses(<<~RUBY.strip_indent)
      #{valid_form}
    RUBY
  end
end
