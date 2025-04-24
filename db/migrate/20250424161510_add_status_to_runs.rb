class AddStatusToRuns < ActiveRecord::Migration[8.0]
  def change
    add_column :runs, :status, :integer, default: 0, null: false
    add_index :runs, :status
  end
end
