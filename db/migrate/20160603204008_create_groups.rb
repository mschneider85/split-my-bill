class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.timestamps null: false
    end

    create_table :memberships do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end

    create_table :invites do |t|
      t.string :email
      t.belongs_to :group
      t.belongs_to :sender
      t.belongs_to :recipient
      t.string :token
      t.timestamps null: false
    end
  end
end
