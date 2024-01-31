class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit create update destroy]
  before_action :owners_only, only: %i[edit update destroy]
  def new
    @achievement = Achievement.new
  end

  def index
    @achievements = Achievement.public_access
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def edit; end

  def update
    if @achievement.update(achievement_params)
      redirect_to(achievement_path(params[:id]))
    else
      render :edit
    end
  end

  def create
    @achievement = current_user.achievements.new(achievement_params)
    if @achievement.save
      redirect_to achievement_path(@achievement), notice: 'Achievement has been created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @achievement.destroy
    redirect_to achievements_path
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :featured, :user_id)
  end

  def owners_only
    @achievement = Achievement.find(params[:id])
    return unless current_user != @achievement.user

    redirect_to achievements_path
  end
end
