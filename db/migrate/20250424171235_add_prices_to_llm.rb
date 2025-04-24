class AddPricesToLlm < ActiveRecord::Migration[8.0]
  def change
    add_column :llms, :input_price_per_token, :decimal
    add_column :llms, :output_price_per_token, :decimal
  end
end
