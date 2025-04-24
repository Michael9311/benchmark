# == Schema Information
#
# Table name: llms
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  parameters :jsonb
#  provider   :string           not null
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  model_id   :string           not null
#
# Indexes
#
#  index_llms_on_name                   (name) UNIQUE
#  index_llms_on_provider_and_model_id  (provider,model_id) UNIQUE
#
class OpenaiLlm < Llm
  # Example implementation for OpenAI models (GPT)

  def initialize(attributes = nil)
    super
    self.provider = "openai" if attributes
  end

  def call(prompt_text, options = {})
    client = OpenAI::Client.new(
      access_token: ENV.fetch("OPENAI_TOKEN"),
      log_errors: true
    )

    params = model_parameters.merge(options)

    response = client.chat(
      parameters: {
        model: model_id,
        messages: [{role: "user", content: prompt_text}],
        temperature: params[:temperature],
        max_tokens: params[:max_tokens]
      }
    )

    response.dig("choices", 0, "message", "content")
  end
end
