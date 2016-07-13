class Comment < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

  delegate :name, to: :author, prefix: true

  validates :content, presence: true
end
