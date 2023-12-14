class AddImageUrlToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :image_url, :string
  end
end
