# == Schema Information
#
# Table name: llms
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  parameters :jsonb
#  provider   :string           not null
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
    OpenAI::Client.new(
      access_token: ENV.fetch("OPENAI_TOKEN"),
      log_errors: true
    )

    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: model_id, # Required.
        messages: [{role: "user", content: "Hello!"}], # Required.
        temperature: 0.7
      }
    )
    puts response.dig("choices", 0, "message", "content")
  end
end
