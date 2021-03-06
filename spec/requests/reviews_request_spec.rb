require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { create(:user) }
  let(:item) { create(:item, id: 1, name: 'テストアイテム') }
  let(:review) { create(:review,item: item, user_id: user.id, item_id: item.id) }
  let(:review_params) { attributes_for(:review, user_id: user.id, item_id: item.id) }

  describe "In case of login user" do
    before do
      sign_in user
    end
    # newpage正常レスポンス
    it "is new_page responds succesfully" do
      get new_item_review_path(item.id)
      expect(response).to have_http_status(200)
    end
    # レビュー作成できる
    it "can create review" do
      expect { post item_reviews_path(item.id), params: { review: review_params }}.to change(Review, :count).by(1)
    end

    context "review index page" do
      it "is index_page responds succesfully" do
        get reviews_path
        expect(response).to have_http_status(200)
        expect(response).to render_template('reviews/index')
      end
    end
  end

  context "In case of not login user" do
    # ログインページに戻される
    it "redirect to login page" do
      get new_item_review_path(item.id)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to user_session_path
    end

    it "is index_page responds failure" do
      get reviews_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to user_session_path
    end
  end
end
