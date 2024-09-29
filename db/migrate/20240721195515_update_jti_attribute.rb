# frozen_string_literal: true

class UpdateJtiAttribute < ActiveRecord::Migration[7.1]
  remove_index :users, :jti
  change_column :users, :jti, :string, null: false
  add_index :users, :jti, unique: true
end
