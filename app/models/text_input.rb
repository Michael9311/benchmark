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
class TextInput < Input
  # This class represents simple text inputs for benchmarking
  # Could include questions, statements, code snippets, etc.
  
  # Future input types might include:
  # - FileInput (for code files, documents, etc.)
  # - ImageInput (for image analysis tasks)
end
