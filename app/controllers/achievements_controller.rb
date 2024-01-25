class AchievementsController < ApplicationController
  def new
    @achievement = Achievement.new
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def update; end

  def create
    @achievement = Achievement.new(achievement_params)
    if @achievement.save
      redirect_to root_path, notice: 'Achievement has been created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :featured)
  end
end
