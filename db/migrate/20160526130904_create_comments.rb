class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.references :commentable, polymorphic: true
      t.text :body

      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id
  end
end
