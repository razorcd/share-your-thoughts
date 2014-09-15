class Image < ActiveRecord::Base

  validates :image_link, :presence => true,
                         :length => {:within =>1..128}

end
