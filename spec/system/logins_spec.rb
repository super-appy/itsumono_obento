require 'rails_helper'

RSpec.describe "ユーザー認証機能", type: :system do
  let(:user) { create(:user) }

  describe "ログイン" do
    context "認証情報が正しい場合" do
      it "ログインできること" do
        visit '/login'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq '/'
        expect(page).to have_content('ログインしました')
      end
    end

    context "PWに誤りがある場合" do
      it "ログインできないこと" do
        visit '/login'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'wordpass'
        click_button 'ログイン'
        Capybara.assert_current_path("/login", ignore_query: true)
        expect(current_path).to eq '/login'
        expect(page).to have_content('ログインに失敗しました')
      end
    end
  end

  describe "ログアウト" do
    before do
      login_as(user)
    end
    it 'ログアウトできること', js: true do
      find('.mypage_pulldown').hover
      find('.logout_button').click
      Capybara.assert_current_path("/", ignore_query: true)
      expect(current_path).to eq root_path
      expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
    end
  end
end
