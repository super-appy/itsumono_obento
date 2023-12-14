require 'csv'

# CSVファイルのパスを設定
csv_file_path = 'tags.csv'

# CSVファイルを読み込み、各行に対して処理を行う
CSV.foreach(csv_file_path, headers: true) do |row|
  Tag.create(
    category: row['category'],
    name: row['name'],
    image_url: row['image_url']
  )
end
