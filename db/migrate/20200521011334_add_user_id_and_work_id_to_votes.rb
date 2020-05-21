class AddUserIdAndWorkIdToVotes < ActiveRecord::Migration[6.0]
  def change
    # Basically indexes are used to quickly locate data instead of having to search through every row in the database.
    add_index :votes, [:user_id, :work_id], unique: true
  end
end
