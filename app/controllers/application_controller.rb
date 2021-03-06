class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user
  before_action :assign_user, :feedback_checker, :select_cart

 private
   def current_user_session
     return @current_user_session if defined?(@current_user_session) && !@current_user_session.nil?
     @current_user_session = UserSession.find
   end

   def current_user
     return @current_user if defined?(@current_user)
     @current_user = current_user_session && current_user_session.user
   end

   def require_user
      unless current_user
        flash[:alert]="You have to be logged in"
        redirect_to root_url
      end
    end

    def require_no_user
      if current_user
        flash[:alert]="You are already logged in"
        redirect_to root_url
      end
    end

    def assign_user
      if current_user_session
        @user = current_user
        @user_session = current_user_session
      else
        @user = User.new
        @user_session = UserSession.new
      end

      def feedback_checker
        if @feedback == nil
          @feedback = Feedback.new
        end
      end
    end

    def sock_setter
      @sock = Sock.new
    end

    def select_cart
      if current_user_session
        @cart = current_user.cart
      elsif session['cart_id']
        @cart = Cart.find(session['cart_id'])
      else
        @cart = Cart.new
        session['cart_id'] = @cart.id
      end
    end
end
