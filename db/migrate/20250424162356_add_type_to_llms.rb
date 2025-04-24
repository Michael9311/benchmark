class AddTypeToLlms < ActiveRecord::Migration[8.0]
  def change
    add_column :llms, :type, :string
  end
end
