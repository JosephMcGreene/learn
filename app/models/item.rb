class Item < ApplicationRecord
  belongs_to :idea_set
  belongs_to :item_type
  has_many :links
  has_many :reviews
  belongs_to :user # submitter
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { in: 8..120 }
  validates :item_type, presence: true
  validates :idea_set, presence: true
  validates :user, presence: true
  
  accepts_nested_attributes_for :links, allow_destroy: true

  scope :recent, -> { order("created_at DESC").limit(3) }
  scope :popular, -> { order("(inspirational_score + educational_score + challenging_score + entertaining_score + visual_score + interactive_score) DESC").limit(3) }

  def self.searchable_language
    'english'
  end

  def self.search(q, max)
  	if q.start_with?('http')
      #TODO: Fetch the canonical URL and use that instead
  		Link.where(url: q).limit(max).map(&:item)
  	else
      Item.fuzzy_search(name: q).limit(max)
  	end
  end

  def self.advanced_search(topic_name, item_type, length, quality)
    results = Item.all

    if topic_name.present?
      topic = Topic.where(name: topic_name).first
      results = results.where(id: topic.items.map(&:id)) if topic
    end

    if item_type.present?
      results = results.where(item_type_id: item_type)
    end
    
    if length.present?
      range_start = length.split("-").first
      range_finish = length.split("-").last
      results = results.where(estimated_time: range_start..range_finish)
    end

    if quality.present?
      results = results.where("#{quality}_score >= 4.0")
    end
    return results.limit(20)
  end

  def self.discover
    Item.order('RANDOM()').first
  end

  def topics
    self.idea_set.topics
  end
end
