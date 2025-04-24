class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts do |t|
      t.string :name, null: false
      t.text :content, null: false

      t.timestamps
    end
    
    add_index :prompts, :name, unique: true
  end
end