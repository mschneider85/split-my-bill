class Entry < ActiveRecord::Base
  has_many :transactions, dependent: :destroy
  belongs_to :group

  accepts_nested_attributes_for :transactions

  monetize :amount_cents
  attr_accessor :user_ids
end
