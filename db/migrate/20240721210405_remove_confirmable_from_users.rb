class RemoveConfirmableFromUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      # t.remove :unconfirmed_email # Uncomment if you used reconfirmable
    end
  end
end
