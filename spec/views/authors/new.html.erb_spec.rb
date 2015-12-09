RSpec.describe "authors/new" do
  before do
    assign(:author, author)
  end

  describe "a blank form" do
    let(:author) { Author.new }

    before(:each) { render }

    it "does not render an error list" do
      assert_select "#error_explanation", false
    end

    it "does not render error fields" do
      assert_select ".field_with_errors", 0
    end
  end

  context "invalid submissions" do
    let(:invalid_attributes) do
      { email: "bro@sbahj.info", phone_number: "555035995" }
    end
    let(:author) do
      Author.new(invalid_attributes).tap do |a|
        a.errors.add(:name, "cannot be blank")
        a.errors.add(:email, "is already taken")
        a.errors.add(:phone_number, "must be 10 characters long.")
      end
    end

    before(:each) { render }

    it "renders an error list" do
      assert_select "#error_explanation li", 3
    end

    it "prefills fields" do
      assert_select "input[name=name]" do |element|
        expect(element.attr("value")).to be_nil
      end
      assert_select "input[name=email][value=?]", invalid_attributes[:email]
      assert_select "input[name=phone_number][value=?]", invalid_attributes[:phone_number]
    end

    it "has error class on bad fields" do
      assert_select ".field_with_errors input[name=name]"
      assert_select ".field_with_errors input[name=email]"
      assert_select ".field_with_errors input[name=phone_number]"
    end
  end
end
