# == Schema Information
#
# Table name: inputs
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  name       :string           not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_inputs_on_name  (name) UNIQUE
#
class Input < ApplicationRecord
  has_many :runs
  
  validates :content, presence: true
  validates :name, presence: true, uniqueness: true
  validates :type, presence: true
  
  # An input can be any text that you want to test with different prompts and LLMs
  # Examples: questions, statements, code snippets, etc.
  # 
  # Uses STI to support different types of inputs (questions, code samples, etc.)
end
