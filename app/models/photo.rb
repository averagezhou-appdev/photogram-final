# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer          default("0")
#  image          :string
#  likes_count    :integer          default("0")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord

  validates(:poster, { :presence => true })
  validates(:image, { :presence => true })

  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  belongs_to :poster, :class_name => "User", :foreign_key => "owner_id"
end
