class StoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :check_ownership, only: [:edit, :update]

  def index
    @stories = params[:q] ? Story.search_for(params[:q]) : Story.all
  end

  def show
    @story = Story.find params[:id]
    @comment = Comment.new(:story => @story)
  end

  def new
    @story = Story.new
  end

  def create
    safe_story_params = params.require(:story).permit(:title, :link, :category)
    @story = current_user.stories.build safe_story_params.merge(:upvotes => 1)

    if @story.save
      redirect_to @story
    else
      render :new
    end
  end

  def edit
  end

  def update
    safe_story_params = params.require(:story).permit(:title, :link, :category)
    @story.update safe_story_params

    if @story.save
      redirect_to @story
    else
      render :edit
    end
  end

  private

    def check_ownership
      @story = Story.find params[:id]
      if @story.user.try(:id) != current_user.id
        flash[:alert] = "You do not have permission to edit this story"
        redirect_to @story
      end
    end

end
