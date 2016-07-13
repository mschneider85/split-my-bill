class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :commentable, polymorphic: true
      t.belongs_to :author

      t.timestamps null: false
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
