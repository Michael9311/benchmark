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
#  index_llms_on_name  (name) UNIQUE
#
class Llm < ApplicationRecord
  has_many :runs
  
  validates :name, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :model_id, presence: true
  
  # The LLM model represents a specific language model from a provider
  # Examples: GPT-4, Claude 3 Opus, Llama-3-70b, etc.
  
  # Common providers might include OpenAI, Anthropic, Mistral, etc.
  
  def full_name
    "#{provider}/#{model_id}"
  end
  
  # Get model parameters with defaults
  def model_parameters
    {
      temperature: 0.7,
      max_tokens: 1000
    }.merge(parameters || {})
  end
  
  # This must be implemented by child classes
  def call(prompt_text, options = {})
    # Implementation for calling the LLM API should:
    # 1. Merge default parameters with provided options
    # 2. Call the appropriate API based on provider
    # 3. Process and return the response
    
    raise NotImplementedError, "#{self.class.name} must implement the 'call' method"
  end
end
