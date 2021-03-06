class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    render_without_password(@users)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, except: :password_digest,
      status: :created
    else
      render json: { errors: @user.errors.full_messages },
      status: :unprocessable_entity
    end
  end

  def show
    render_without_password(@user)
  end

  def update
    unless @user.save(user_params)
      render json: { errors: @user.errors.full_messages },
      status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def render_without_password(user)
    render json: user, except: :password_digest, status: :ok
  end

  def set_user
    @user = @currentUser
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
