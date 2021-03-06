class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_save :user_is_host
  after_destroy :back_to_regular_user

  def average_review_rating
    reviews = []

    self.reviews.each do |review|
      reviews << review.rating
    end
    reviews.inject {|sum, element| sum + element}.to_f/reviews.size
  end

  # http://stackoverflow.com/questions/1341271/how-do-i-create-an-average-from-a-ruby-array
  # https://blog.udemy.com/ruby-inject/

  private

  def user_is_host
    self.host.update(host: true)
  end

  def back_to_regular_user
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end

end
