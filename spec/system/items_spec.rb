require 'rails_helper'

RSpec.describe "Items", type: :system do
  let!(:admin) { create(:user, name: "管理ユーザー", email: "admin@example.com", admin: true) }

  describe "tire item create page" do
    before do
      sign_in admin
      visit new_item_path
    end

    context "page layout" do
      # タイヤ作成のボタンがあること
      it "is displayed create button" do
        expect(page).to have_button 'タイヤ作成'
      end
      # タイトル表示
      it "title is correctly" do
        expect(page).to have_title full_title('タイヤ登録')
      end
      # 適切なラベル
      it "label is correctly displayed " do
        expect(page).to have_content 'タイヤ名'
        expect(page).to have_content 'タイヤ詳細説明'
        expect(page).to have_content '画像'
        expect(page).to have_content 'カテゴリ'
      end
    end

    context "tire item create process" do
      it "item valid create" do
        fill_in "タイヤ名", with: "テストアイテム"
        fill_in "タイヤ詳細説明", with: "テスト説明"
        click_button "タイヤ作成"
        expect(page).to have_content "作成しました"
      end

      it "item invalid create" do
        fill_in "タイヤ名", with: ""
        fill_in "タイヤ詳細説明", with: ""
        click_button "タイヤ作成"
        expect(page).to have_content "作成に失敗しました"
      end
    end
  end

  describe "tire item detail page" do
    let!(:user) { create(:user)}
    let!(:item) { create(:item)}
    let(:review) { create(:review, item: item, user: user)}

    context "show page layout" do
      before do
        sign_in user
        visit item_path(item.id)
      end

      # 適切なタイトルか
      it "title is correctly" do
        expect(page).to have_title full_title(item.name)
      end
      # タイヤネームはあるか
      it "is displayed item name" do
        expect(page).to have_content item.name
      end
      # タイヤ詳細はあるか
      it "is displayed item content" do
        expect(page).to have_content item.content
      end
      # レビューリンク
      it "redirect to review page when click review button" do
        expect(page).to have_link 'レビューする'
        click_link 'レビューする'
        expect(page).to have_current_path(new_item_review_path(item.id))
      end
      # レビュー件数
      it "is displayed item review count" do
        expect(page).to have_content item.reviews.count
      end

      # レビュー件数が0の時は表示されない
      it "review count is not displayed when review count is 0" do
        expect(page).to_not have_content '0件のレビュー'
      end
    end
    context "In case of admin" do
      before do
        sign_in admin
        visit item_path(item.id)
      end
      # アイテム削除ボタンはあるか(adminのみ)
      it "is displayed item delete button" do
        expect(page).to have_link 'タイヤ削除'
        click_link 'タイヤ削除'
        expect(page).to have_current_path(new_item_path)
      end
    end
  end

  describe "tire item index page" do
    let!(:user) { create(:user)}
    let!(:item1) { create(:item, name: "テストタイヤ1")}
    let!(:item2) { create(:item, name: "テストタイヤ2")}

    before do
      sign_in user
      visit items_path
    end

    context "search function" do
      it "is displayed search form" do

        expect(page).to have_css '.form-group'
        expect(page).to have_button '検索'
      end

      it "is displayed items including seach content" do
        expect(page).to have_content item1.name
        expect(page).to have_content item2.name
        fill_in 'q[name_cont]', with: '1'
        click_button '検索'
        expect(page).to have_content item1.name
        expect(page).not_to have_content item2.name
      end
    end
  end
end
