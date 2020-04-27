class UsersController < ApplicationController
  include Response
  include ExceptionHandler

  before_action :authorize_request, only: [:current]

  attr_reader :current_user

  # POST /signup
  # return authenticated token upon signup
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def current
    @user = User.find(current_user.id)
    json_response(@user)
  end

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
