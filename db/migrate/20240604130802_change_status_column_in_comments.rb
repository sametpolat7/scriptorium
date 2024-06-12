class ChangeStatusColumnInComments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :comments, :status, from: nil, to: "pending"
  end
end
