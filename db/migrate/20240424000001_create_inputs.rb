class CreateInputs < ActiveRecord::Migration[8.0]
  def change
    create_table :inputs do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.string :type, null: false

      t.timestamps
    end
    
    add_index :inputs, :name, unique: true
  end
end