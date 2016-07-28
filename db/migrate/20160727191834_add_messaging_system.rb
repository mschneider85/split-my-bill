class AddMessagingSystem < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :sender_id
      t.integer :recipient_id
      
      t.timestamps
    end

    create_table :messages do |t|
      t.text :body
      t.belongs_to :conversation, index: true
      t.belongs_to :user, index: true
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
