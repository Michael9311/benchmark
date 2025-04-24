class RunsController < ApplicationController
  before_action :set_run, only: [:show, :execute]

  def index
    @runs = Run.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @run = Run.new
    @inputs = Input.all
    @prompts = Prompt.all
    @llms = Llm.all
  end

  def create
    @run = Run.new(run_params)

    if @run.save
      redirect_to @run, notice: "Run was successfully created."
    else
      @inputs = Input.all
      @prompts = Prompt.all
      @llms = Llm.all
      render :new, status: :unprocessable_entity
    end
  end

  def execute
    if @run.execute
      redirect_to @run, notice: "Run was successfully executed."
    else
      redirect_to @run, alert: "Failed to execute run. Check logs for details."
    end
  end

  private

  def set_run
    @run = Run.find(params[:id])
  end

  def run_params
    params.require(:run).permit(:input_id, :prompt_id, :llm_id)
  end
end
