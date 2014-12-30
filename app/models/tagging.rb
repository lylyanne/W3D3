class Tagging < ActiveRecord::Base
  validates :tag_topic, presence: true
  validates :shortened_url, presence: true
  validates :tag_topic, uniqueness: { scope: :shortened_url }

  belongs_to(
    :tag_topic,
    class_name: 'TagTopic',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )

  belongs_to(
    :shortened_url,
    class_name: 'ShortenedURL',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )
end
