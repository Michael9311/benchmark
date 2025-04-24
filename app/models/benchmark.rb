class Benchmark < ApplicationRecord
  has_many :runs, dependent: :nullify
  has_many :inputs, through: :runs
  has_many :prompts, through: :runs
  has_many :llms, through: :runs
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  
  # A benchmark represents a collection of runs used to evaluate LLM performance
  
  def average_latency
    runs.average(:latency)
  end
  
  def total_cost
    runs.sum(&:cost)
  end
  
  def average_tokens_per_second
    runs.map(&:tokens_per_second).compact.sum / runs.count
  end
  
  def execute(inputs: [], prompts: [], llms: [])
    inputs.each do |input|
      prompts.each do |prompt|
        llms.each do |llm|
          run = Run.create(
            input: input,
            prompt: prompt,
            llm: llm,
            benchmark: self
          )
          run.execute
        end
      end
    end
  end
  
  def compare_llms
    # Group runs by LLM and calculate average metrics
    llms.map do |llm|
      llm_runs = runs.where(llm: llm)
      {
        llm: llm.name,
        avg_latency: llm_runs.average(:latency),
        avg_tokens_per_second: llm_runs.map(&:tokens_per_second).compact.sum / llm_runs.count,
        total_cost: llm_runs.sum(&:cost)
      }
    end
  end
end