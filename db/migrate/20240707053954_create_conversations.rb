class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.boolean :is_private
      t.string :title
      t.references :admin, foreign_key: { to_table: :users }, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
