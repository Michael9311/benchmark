class LlmsController < ApplicationController
  def index
    @llms = Llm.all
  end

  def new
    @llm = Llm.new
  end

  def create
    @llm = create_llm_instance(llm_params)

    if @llm.save
      redirect_to llm_path(@llm), notice: "LLM was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @llm = Llm.find(params[:id])
  end

  def edit
    @llm = Llm.find(params[:id])
  end

  def update
    @llm = Llm.find(params[:id])
    
    if @llm.update(llm_params)
      redirect_to llm_path(@llm), notice: "LLM was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @llm = Llm.find(params[:id])
    @llm.destroy
    
    redirect_to llms_path, notice: "LLM was successfully deleted."
  end

  private

  def llm_params
    params.require(:llm).permit(:name, :provider, :model_id, parameters: [:temperature, :max_tokens])
  end
  
  def create_llm_instance(params)
    case params[:provider]
    when "anthropic"
      AnthropicLlm.new(params)
    when "openai"
      OpenaiLlm.new(params)
    else
      Llm.new(params)
    end
  end
end