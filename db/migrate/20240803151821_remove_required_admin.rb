# frozen_string_literal: true

class RemoveRequiredAdmin < ActiveRecord::Migration[7.1]
  def up
    change_column_null :conversations, :admin_id, true
  end

  def down
    change_column_null :conversations, :admin_id, false
  end
end
