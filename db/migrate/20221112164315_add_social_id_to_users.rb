# frozen_string_literal: true

class AddSocialIdToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :social_id, :string, after: :uid
  end

  def down
    remove_column :users, :social_id
  end
end
