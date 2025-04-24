# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_prompts_on_name  (name) UNIQUE
#
class Prompt < ApplicationRecord
  has_many :runs
  
  validates :content, presence: true
  validates :name, presence: true, uniqueness: true
  
  # A prompt is a template that will be combined with an input to create the full prompt
  # sent to an LLM. It can include placeholders for the input content.
  
  def render_with_input(input)
    content.gsub("{input}", input.content)
  end
end
