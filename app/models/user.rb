class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many(
    :submitted_urls,
    class_name: 'ShortenedURL',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :visitor_id,
    primary_key: :id
  )

  has_many(
    :visited_urls,
    Proc.new { distinct },
    through: :visits,
    source: :shortened_url
  )

  def num_recent_creations
    submitted_urls.where("shortened_urls.created_at > ?", 1.minute.ago).count
  end
end
