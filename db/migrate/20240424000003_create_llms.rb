class CreateLlms < ActiveRecord::Migration[8.0]
  def change
    create_table :llms do |t|
      t.string :name, null: false
      t.string :provider, null: false
      t.string :model_id, null: false
      t.jsonb :parameters, default: {}

      t.timestamps
    end

    add_index :llms, :name, unique: true
  end
end

