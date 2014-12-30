class AddIndexToTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, [:tag_topic_id, :shortened_url_id], unique: true
  end
end
