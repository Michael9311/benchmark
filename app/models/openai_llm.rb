# == Schema Information
#
# Table name: llms
#
#  id                     :bigint           not null, primary key
#  input_price_per_token  :decimal(, )
#  name                   :string           not null
#  output_price_per_token :decimal(, )
#  parameters             :jsonb
#  provider               :string           not null
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  model_id               :string           not null
#
# Indexes
#
#  index_llms_on_name  (name) UNIQUE
#
class OpenaiLlm < Llm
  # Example implementation for OpenAI models (GPT)

  def initialize(attributes = nil)
    super
    self.provider = "openai" if attributes
  end

  def call(prompt_text, input_text, options = {})
    client = OpenAI::Client.new(
      access_token: ENV.fetch("OPENAI_TOKEN"),
      log_errors: true
    )

    params = model_parameters.merge(options)

    response = client.chat(
      parameters: {
        model: model_id,
        messages: [{role: "system", content: prompt_text}, {role: "user", content: input_text}],
        temperature: params[:temperature],
        max_tokens: params[:max_tokens]
      }
    )

    tokens_in = response.dig("usage", "prompt_tokens")
    tokens_out = response.dig("usage", "completion_tokens")
    
    return {
      response: response.dig("choices", 0, "message", "content"),
      tokens_in: tokens_in,
      tokens_out: tokens_out
    }
  end
end
