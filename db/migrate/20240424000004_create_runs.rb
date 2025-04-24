class CreateRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :runs do |t|
      t.references :input, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true
      t.references :llm, null: false, foreign_key: true

      t.text :response
      t.float :latency
      t.integer :tokens_in
      t.integer :tokens_out
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :runs, [:input_id, :prompt_id, :llm_id], name: "index_runs_on_input_prompt_llm"
  end
end

