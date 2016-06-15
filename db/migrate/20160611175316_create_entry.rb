class CreateEntry < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.string :type
      t.monetize :amount
      t.belongs_to :group
      t.timestamps null: false
    end
  end
end
