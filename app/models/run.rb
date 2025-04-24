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
    (tokens_in * 0.0001) + (tokens_out * 0.0002)
  end

  def tokens_per_second
    return nil if tokens_out.nil? || latency.nil? || latency.zero?
    tokens_out / latency
  end

  def execute
    return false unless draft? || failed?

    begin
      update!(status: :in_progress)
      rendered_prompt = prompt.render_with_input(input)

      start_time = Time.now
      self.response = llm.call(rendered_prompt)
      end_time = Time.now

      self.latency = (end_time - start_time).to_f
      # Here you would also calculate tokens_in and tokens_out
      # This is a placeholder and would be replaced with actual token counting
      self.tokens_in = rendered_prompt.length / 4 # rough estimate
      self.tokens_out = response.length / 4 # rough estimate

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
