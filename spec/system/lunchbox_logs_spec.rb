require 'rails_helper'

RSpec.describe "お弁当のログ", type: :system do
  before do
    # デモデータつくる？
  end

  describe "CRUDの各機能" do
    describe "一覧画面" do
      context "ログインしている場合" do
        xit "お弁当の一覧が見れる" do
          
          # お気に入りボタンが表示されるかを入れる
        end
      end

      context "ログインしていない場合" do
        xit "お弁当の一覧が見れる" do
          test2
        end
      end
    end

    describe "詳細画面" do
      context "ログインしている場合" do
        xit "自分の詳細が見れる" do
          aa
        end

        xit "他人の詳細は見れない" do
          a
        end
      end

      context "ログインしていない場合" do
        xit "詳細にアクセスするとトップページにリダイレクトされる" do
          a
        end
      end
    end

    describe "新規作成" do
      context "ログインしている場合" do
        xit "投稿の新規作成ができる" do
          a
        end
      end

      context "ログインしていない場合" do
        xit "投稿にアクセスするとトップページにリダイレクトされる" do
          a
        end
      end
    end

    describe "編集画面" do
      context "ログインしている場合" do
        context "自分の投稿" do
          xit "編集できる" do
            a
          end
        end

        context "他人の投稿" do
          xit "編集できない" do
            a
          end
        end
      end

      context "ログインしていない場合" do
        xit "トップページにリダイレクトされる" do
          s
        end
      end
    end

    describe "投稿の削除" do
      context "自分の投稿" do
        xit "削除できる" do
          a
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
