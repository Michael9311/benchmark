class CreateBenchmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :benchmarks do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.jsonb :configuration, default: {}
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
    
    add_index :benchmarks, :name, unique: true
  end
end