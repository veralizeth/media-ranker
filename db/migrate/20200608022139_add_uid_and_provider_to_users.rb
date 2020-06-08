class AddUidAndProviderToUsers < ActiveRecord::Migration[6.0]
  # let's evolve our User model so that it can save the name and email attributes.
  def change
    add_column :users, :uid, :integer
    add_column :users, :provider, :string
    add_column :users, :email, :string
  end
end
