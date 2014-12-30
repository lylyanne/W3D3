class ShortenedURL < ActiveRecord::Base
  validates :short_url, uniqueness: true, presence: true
  validates :submitter_id, presence: true
  validates :long_url, presence: true
  validates :num_recent_creations_by_submitter, numericality: { less_than_or_equal_to: 5 }

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor
  )

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :tag_topics,
    through: :taggings,
    source: :tag_topic
  )

  def self.random_code
    code = SecureRandom::urlsafe_base64[0...16]
    while ShortenedURL.exists?(code)
      code = SecureRandom::urlsafe_base64[0...16]
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedURL.random_code
    ShortenedURL.create!(:long_url => long_url,
                         :submitter_id => user.id,
                         :short_url => short_url
                        )
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
    #visits.select("distinct visitor_id").count
  end

  def num_recent_uniques
    visitors.where('visits.updated_at > ?', 10.minutes.ago).count
    #visits.select("distinct visitor_id").where('updated_at > ?', 10.minutes.ago).count
  end

  private
  def num_recent_creations_by_submitter
    # user = User.find(submitter_id)
    submitter.num_recent_creations
  end

end
