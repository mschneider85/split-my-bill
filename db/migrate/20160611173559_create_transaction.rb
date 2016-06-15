class CreateTransaction < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.monetize :amount
      t.belongs_to :creditor, index: true
      t.belongs_to :debtor, index: true
      t.belongs_to :entry, index: true
      t.timestamps null: false
    end
  end
end
