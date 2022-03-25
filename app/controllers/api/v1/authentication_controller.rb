# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApiController
      skip_before_action :authenticate, only: :create

      def create
        user = User.find_by_user_name(params.require(:user_name))

        raise ActiveRecord::RecordNotFound, :user_not_found unless user

        raise Errors::AuthenticateError unless user.authenticate(params.require(:password))

        respond_with_json(UserSerializer.render_as_json(user, root: :user, view: :with_auth_token), :created)
      end
    end
  end
end
