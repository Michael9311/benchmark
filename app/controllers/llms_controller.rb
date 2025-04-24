class LlmsController < ApplicationController
  def index
    @llms = Llm.all
  end

  def new
    @llm = Llm.new
  end

  def create
    @llm = create_llm_instance(llm_params)
    
    # Ensure the type is set based on provider
    set_type_from_provider(@llm)

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
    
    # Handle type change if provider changes
    if @llm.provider != llm_params[:provider]
      # Create a new instance of the appropriate type
      new_llm = create_llm_instance(llm_params)
      
      # Copy ID to ensure we update the same record
      new_llm.id = @llm.id
      
      # Ensure the type is set based on provider
      set_type_from_provider(new_llm)
      
      # Update with the rest of the params
      if new_llm.update(llm_params)
        redirect_to llm_path(new_llm), notice: "LLM was successfully updated."
      else
        @llm = new_llm # Use the new instance with errors for the form
        render :edit, status: :unprocessable_entity
      end
    else
      # No provider change, use regular update
      if @llm.update(llm_params)
        redirect_to llm_path(@llm), notice: "LLM was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
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
  
  def set_type_from_provider(llm)
    case llm.provider
    when "anthropic"
      llm.type = "AnthropicLlm"
    when "openai"
      llm.type = "OpenaiLlm"
    end
  end
end

