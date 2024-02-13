require 'rails_helper'

RSpec.describe "お弁当のログ", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:lunchbox_log){ create(:lunchbox_log, user: user)}

  describe "CRUDの各機能" do
    describe "一覧画面" do
      context "ログインしている場合" do
        it "お弁当の一覧が見れる" do
          lunchbox_log
          login_as(user)
          visit '/lunchbox_logs'
          Capybara.assert_current_path("/lunchbox_logs", ignore_query: true)
          expect(current_path).to eq('/lunchbox_logs')
          expect(page).to have_content(lunchbox_log.original_menu)
          # お気に入りボタンが表示されるかを入れる
        end
      end

      context "ログインしていない場合" do
        it "お弁当の一覧が見れる" do
          lunchbox_log
          visit '/lunchbox_logs'
          Capybara.assert_current_path("/lunchbox_logs", ignore_query: true)
          expect(current_path).to eq('/lunchbox_logs')
          expect(page).to have_content(lunchbox_log.original_menu)
        end
      end
    end

    describe "詳細画面" do
      context "ログインしている場合" do
        it "自分の詳細が見れる" do
          lunchbox_log
          login_as(user)
          visit mypage_path
          find(".lunchbox_image_#{lunchbox_log.id}").click
          Capybara.assert_current_path("/lunchbox_logs/#{lunchbox_log.id}", ignore_query: true)
          expect(current_path).to eq("/lunchbox_logs/#{lunchbox_log.id}")
          expect(page).to have_content(lunchbox_log.original_menu)
          expect(page).to have_content(lunchbox_log.published_status)
        end

        xit "他人の詳細は見れない" do
          a
        end
      end

      context "ログインしていない場合" do
        it "詳細にアクセスするとトップページにリダイレクトされる" do
          visit lunchbox_log_path(lunchbox_log)
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq("/login")
          expect(page).to have_content('ログインしてください')
        end
      end
    end

    describe "新規作成" do
      context "ログインしている場合" do
        it "投稿の新規作成ができる" do
          login_as(user)
          visit new_lunchbox_log_path
          fill_in '作った日', with: Date.today
          fill_in 'その他のメニュー', with: 'TEST'
          fill_in 'コメント', with: 'TEST'
          select '全体公開', from: '公開範囲'
          click_button '登録する'
          Capybara.assert_current_path("/mypage", ignore_query: true)
          expect(current_path).to eq(mypage_path)
        end
      end

      context "ログインしていない場合" do
        it "投稿にアクセスするとトップページにリダイレクトされる" do
          visit new_lunchbox_log_path
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq(login_path)
        end
      end
    end

    describe "編集画面" do
      before { lunchbox_log }
      context "ログインしている場合" do
        context "自分の投稿" do
          it "編集できる" do
            login_as(user)
            visit lunchbox_log_path(lunchbox_log)
            click_on '編集'
            fill_in 'その他のメニュー', with: '変更'
            click_on '更新する'
            Capybara.assert_current_path("/lunchbox_logs", ignore_query: true)
            expect(current_path).to eq(lunchbox_logs_path)
            expect(page).to have_content('変更')
          end
        end

        context "他人の投稿" do
          xit "編集できない" do
            login_as(another_user)
            visit lunchbox_log_path(lunchbox_log)
          end
        end
      end
    end

    describe "投稿の削除" do
      context "自分の投稿" do
        it "削除できる" do
          login_as(user)
          visit lunchbox_log_path(lunchbox_log)
          page.accept_confirm do
            find(".button-delete-#{lunchbox_log.id}").click
          end
        end
      end

      context "他人の投稿" do
        xit "削除ボタンが存在しない" do
          a
        end
      end
    end
  end
end
