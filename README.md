# サービス名：いつものお弁当
[![Image from Gyazo](https://i.gyazo.com/14055a8490e40c304b10e3341c3e1496.png)](https://gyazo.com/14055a8490e40c304b10e3341c3e1496)

## サービス概要
お弁当づくりを毎日続けられるようにをサポートするアプリです。
シンプルなレシピの検索機能に加え、お弁当の内容をカレンダー形式で記録することで、お弁当作りのモチベーションを維持します。
タイムライン機能で記録したお弁当を投稿したり、他の人のお弁当の投稿を見ることもできます。

## このサービスへの思い・作りたい理由
ここ3年ほど毎日お弁当を作っているのですが、おかずのレパートリーが少ないことが悩みでした。レシピサイトで検索してもたくさん出てきてどれを作ろうか迷ってその段階で疲れてしまい、また同じレシピで作る日々...
今ある材料で作れるレシピを提案してくれるアプリがあったらいいな、と思ったことがきっかけです。
さらに、お弁当作りのモチベーション維持と振り返りのためにカレンダー形式でお弁当の記録ができるようにしました。

## 機能紹介
「👤」がついているものは、ログイン限定機能となっています。

|トップ画面| レシピ一覧 |
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/3b4d71eb80ad99c6e3d0803af0ebaddb.gif)](https://gyazo.com/3b4d71eb80ad99c6e3d0803af0ebaddb)|[![Image from Gyazo](https://i.gyazo.com/abef5cc7ec1943cc7dea99ad8f267ba4.gif)](https://gyazo.com/abef5cc7ec1943cc7dea99ad8f267ba4)|
|コンセプト、メイン機能の説明からユーザー登録、ログインへと誘導しています。機能説明に画面録画を使うことで分かりやすくしました。|すべてのレシピから、調理時間・テイスト・食材で検索ができます。現在は追加でユーザー投稿のレシピとAIレシピが絞り込めるようになっています。|

|レシピ生成| 👤 レシピ投稿 |
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/f3bc51d72c75e49871c743bc975453f7.gif)](https://gyazo.com/f3bc51d72c75e49871c743bc975453f7)|[![Image from Gyazo](https://i.gyazo.com/3b2cebc7a99ac21a7734b3cf8c0320e5.gif)](https://gyazo.com/3b2cebc7a99ac21a7734b3cf8c0320e5)|
|調理時間・テイスト・食材をもとにOpenAIでレシピを生成します。レシピは1日1回しか生成できないよう制限をかけています。|レシピの投稿画面は必要最低限に、シンプルにしました。|

|レシピ詳細|お弁当投稿一覧|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/d93f5b0b74981ff787f193d7a3cd562c.png)](https://gyazo.com/d93f5b0b74981ff787f193d7a3cd562c)|[![Image from Gyazo](https://i.gyazo.com/285d6183f1c4865ade45da12d2663858.jpg)](https://gyazo.com/285d6183f1c4865ade45da12d2663858)|
|Iで生成したレシピを見やすく表示しました。未ログインであればユーザー登録、ログインしていればお気に入りへの導線をつくっています。|ユーザーが投稿したお弁当を見ることができます。公開範囲の設定ができるので、プライベートなものは個人の自分限定で記録できます。|

|👤 レシピお気に入り|👤 お弁当カレンダー|
|:-:|:-:|
|[![Image from Gyazo](https://i.gyazo.com/a03df413d8732d17dcf52529ebcf833d.gif)](https://gyazo.com/a03df413d8732d17dcf52529ebcf833d)|[![Image from Gyazo](https://i.gyazo.com/ab2fe2a45cef3a25f9c888acfae13106.gif)](https://gyazo.com/ab2fe2a45cef3a25f9c888acfae13106)|
|気に入ったレシピは作りたい→作ったのステータスでお気に入りに登録できます。作ったの登録の際には、自分専用のメモを残すことができます。|マイページの週カレンダーで自分のお弁当を振り返ることができます。スタンプラリーのように楽しんで記録できるようにしました。|

## 技術構成
### 使用技術
| カテゴリ | 技術 |
| --- | --- |
| フロントエンド | Rails 7.0.8 (Hotwire/Turbo), TailwindCSS |
| バックエンド | Rails 7.0.8 (Ruby 3.2.2 ) |
| データベース | PostgreSQL |
| 環境構築 | Docker |
| インフラ | Heroku |


### ER図
![いつものおべんとう.drawio.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2724148/fcdc5f83-61ca-2cb7-4212-e234ffe53b4f.png)


## 画面遷移図(README作成時のままです)
https://www.figma.com/file/8DJFuFQ2o850Wa5bPoFn44/%E3%81%84%E3%81%A4%E3%82%82%E3%81%AE%E3%81%8A%E3%81%B9%E3%82%93%E3%81%A8%E3%81%86?type=design&node-id=0%3A1&mode=design&t=WQQIArD2UmwP7Ia5-1
