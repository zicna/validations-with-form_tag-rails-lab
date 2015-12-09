require "rails_helper"

RSpec.describe PostsController do
  let(:valid_content) { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, nulla vel condimentum ornare, arcu lorem hendrerit purus, ac sagittis ipsum nisl nec erat. Morbi porta sollicitudin leo, eu cursus libero posuere ac. Sed ac ultricies ante. Donec nec nulla ipsum. Nunc eleifend, ligula ut volutpat." }
  let(:article) { Post.create!(title: "The Danger of Stairs", content: valid_content, category: "Non-Fiction") }

  describe "showing a post" do
    it "shows an post" do
      get :show, id: article.id
      expect(assigns(:post)).to eq(article)
    end
  end

  describe "making valid updates" do
    before do
      patch :update, {
        id: article.id,
        title: "Fifteen Ways to Transcend Corporeal Form",
        category: "Fiction"
      }
    end

    it "updates successfully" do
      expect(Post.find_by(title: assigns(:post).title)).to_not be_nil
    end

    it "redirects to show page" do
      expect(response).to redirect_to(post_path(assigns(:post)))
    end
  end

  describe "making invalid updates" do
    before do
      patch :update, {
        id: article.id,
        title: nil,
        content: "too short",
        category: "Speculative Fiction"
      }
    end

    it "does not update" do
      expect(assigns(:post)).to be_changed
    end

    it "has an error for missing title" do
      expect(assigns(:post).errors[:title]).to_not be_empty
    end

    it "has an error for too short content" do
      expect(assigns(:post).errors[:content]).to_not be_empty
    end

    it "has an error for invalid category" do
      expect(assigns(:post).errors[:category]).to_not be_empty
    end

    it "renders the form again" do
      expect(response).to render_template(:edit)
    end
  end
end

