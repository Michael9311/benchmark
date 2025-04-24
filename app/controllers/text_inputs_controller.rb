class TextInputsController < ApplicationController
  def index
    @text_inputs = TextInput.all
  end

  def new
    @text_input = TextInput.new
  end

  def create
    @text_input = TextInput.new(text_input_params)

    if @text_input.save
      redirect_to @text_input, notice: "Text input was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @text_input = TextInput.find(params[:id])
  end

  private

  def text_input_params
    params.require(:text_input).permit(:name, :content)
  end
end