RSpec.describe "posts/edit" do
  let(:valid_content) { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, nulla vel condimentum ornare, arcu lorem hendrerit purus, ac sagittis ipsum nisl nec erat. Morbi porta sollicitudin leo, eu cursus libero posuere ac. Sed ac ultricies ante. Donec nec nulla ipsum. Nunc eleifend, ligula ut volutpat." }
  let(:article) do
    Post.create!(title: "Something", category: "Fiction", content: valid_content)
  end

  before do
    assign(:post, article)
  end

  describe "a blank form" do
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
      { title: nil, category: "Speculative Fiction", content: "too short" }
    end

    before(:each) do
      article.update(invalid_attributes)
      render
    end

    it "renders an error list" do
      assert_select "#error_explanation li", 3
    end

    it "prefills fields" do
      assert_select "input[name=title]" do |element|
        expect(element.attr("value")).to be_nil
      end
      assert_select "input[name=category][value=?]", invalid_attributes[:category]
      assert_select "textarea[name=content]", invalid_attributes[:content]
    end

    it "has error class on bad fields" do
      assert_select ".field_with_errors input[name=title]"
      assert_select ".field_with_errors input[name=category]"
      assert_select ".field_with_errors textarea[name=content]"
    end
  end
end

