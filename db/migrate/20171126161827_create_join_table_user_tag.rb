class CreateJoinTableUserTag < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :tags do |t|
      t.index [:user_id, :tag_id]
      t.index [:tag_id, :user_id]
    end
  end
end
