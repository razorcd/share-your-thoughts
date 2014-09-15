class Thought < ActiveRecord::Base
  belongs_to :user
  has_many :images, :dependent => :destroy
  before_validation :thought_strip

  validates :title, :presence => true,
                    :length => {:within => 1..64}

  validates :body, :presence => true
                   # :length{:within => 1..512}

  private

  def thought_strip
    self.title = self.title.strip if self.title
    self.body = self.body.strip if self.body
  end
end
