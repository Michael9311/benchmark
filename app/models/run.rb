# == Schema Information
#
# Table name: runs
#
#  id         :bigint           not null, primary key
#  latency    :float
#  metadata   :jsonb
#  response   :text
#  status     :integer          default("draft"), not null
#  tokens_in  :integer
#  tokens_out :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  input_id   :bigint           not null
#  llm_id     :bigint           not null
#  prompt_id  :bigint           not null
#
# Indexes
#
#  index_runs_on_input_id          (input_id)
#  index_runs_on_input_prompt_llm  (input_id,prompt_id,llm_id)
#  index_runs_on_llm_id            (llm_id)
#  index_runs_on_prompt_id         (prompt_id)
#  index_runs_on_status            (status)
#
# Foreign Keys
#
#  fk_rails_...  (input_id => inputs.id)
#  fk_rails_...  (llm_id => llms.id)
#  fk_rails_...  (prompt_id => prompts.id)
#
class Run < ApplicationRecord
  belongs_to :input
  belongs_to :prompt
  belongs_to :llm
  belongs_to :benchmark, optional: true

  validates :response, presence: true, allow_nil: true
  validates :latency, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :tokens_in, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :tokens_out, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

  # State machine for run status
  enum :status, {draft: 0, in_progress: 1, complete: 2, failed: 3}

  # A run represents a single execution of an LLM with a specific input and prompt
  # It stores the response and performance metrics

  def cost
    return nil if tokens_in.nil? || tokens_out.nil?
    # This would depend on the specific LLM pricing
    # Just a placeholder implementation
    (tokens_in * llm.input_price_per_token) + (tokens_out * llm.output_price_per_token)
  end

  def tokens_per_second
    return nil if tokens_out.nil? || latency.nil? || latency.zero?
    tokens_out / latency
  end

  def execute(rerun: true)
    return false unless draft? || (failed? || rerun)

    begin
      update!(status: :in_progress)

      start_time = Time.now
      result = llm.call(prompt.content, input.content)
      end_time = Time.now

      self.response = result[:response]
      self.tokens_in = result[:tokens_in]
      self.tokens_out = result[:tokens_out]
      self.latency = (end_time - start_time).to_f

      update!(status: :complete)
      true
    rescue => e
      update!(
        status: :failed,
        metadata: {error: e.message, backtrace: e.backtrace.first(5)}
      )
      false
    end
  end
end
