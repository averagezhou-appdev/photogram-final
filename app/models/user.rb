# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer          default("0")
#  email           :string
#  is_private      :boolean
#  likes_count     :integer          default("0")
#  password_digest :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
  has_many :own_photos, :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy
  has_many :received_follow_requests, :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy
  has_many :sent_follow_requests, :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy
  has_many :comments, :foreign_key => "author_id", :dependent => :destroy
  has_many :likes, :foreign_key => "fan_id", :dependent => :destroy

  def pending_received_follow_requests
    return self.received_follow_requests.where({ :status => "pending" })
  end

  def accepted_sent_follow_requests
    return self.sent_follow_requests.where({ :status => "accepted" })
  end

  def feed
    array_of_leader_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)

    return Photo.where({ :owner_id => array_of_leader_ids })
  end

  def liked_photos
    array_of_photo_ids = self.likes.pluck(:photo_id)

    return Photo.where({ :id => array_of_photo_ids })
  end

  def discover
    array_of_leader_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)

    all_leader_likes = Like.where({ :fan_id => array_of_leader_ids })

    array_of_discover_photo_ids = all_leader_likes.pluck(:photo_id)

    return Photo.where({ :id => array_of_discover_photo_ids })
  end

end



