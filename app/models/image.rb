class Image < ActiveRecord::Base
  belongs_to :thought
  validates :image_link, :presence => true,
                         :length => {:within =>1..128}

end
