class WelcomeController < ApplicationController
  def index
    @topics = Topic.all
    render json: @topics
  end

  def show
    @topic = Topic.find(params[:id])
    render json: @topic
  end

  def create
    if topic = Topic.create(topic_params)
      render json: { success: topic.id }
    else
      render json: topic.errors
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:string_field1, :int_field1)
  end
end
