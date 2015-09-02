module V1
  class SessionsController < ApplicationController
    def show
      session = Session.find_by(token: request.headers[:Authorization])
      if session
        render json: session
      else
        render status: :unprocessable_entity, json: {
          code: 'validation_error',
          message: 'An authorization header with a JWT is required',
          fields: 'headers[Authorization]'
        }
      end
    end

    def create
      if params[:session][:token] # do one time token login
        single_use_session = Session.find_by(token: params[:session][:token])
        if !single_use_session.present?
          return render status: :unprocessable_entity, json: {
            code: 'not_found',
            message: 'A session could not be found with the provided token',
            fields: 'body[session[token]]'
          }
        else
          user = single_use_session.user
          single_use_session.destroy
        end
      elsif !params[:session][:email]
        return render status: :unprocessable_entity, json: {
          code: 'validation',
          message: 'An email address is required',
          fields: 'body[session[email]]'
        }
      elsif !(user ||= User.find_by(email: params[:session][:email]))
        return render status: :unprocessable_entity, json: {
          code: 'not_found',
          message: 'A user was not found with the provided email address',
          fields: 'headers[Authorization]'
        }
      elsif params[:session][:password] && !user.authenticate(params[:session][:password])
        return render status: :unprocessable_entity, json: {
          code: 'invalid_password',
          message: 'The provided password was invalid',
          fields: 'body[session[password]]'
        }
      elsif params[:session][:password]
      else
        UserMailer.single_use_session(user).deliver_now
        return head :no_content
      end
      session = user.sessions.build

      if session.save
        render json: session, status: :created
      else
        render json: session.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @session.destroy

      head :no_content
    end
  end
end
