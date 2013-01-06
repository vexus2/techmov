class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_omniuser
  before_filter :set_variables

  private
  def current_omniuser
    @current_omniuser ||= Omniuser.find(session[:user_id]) if session[:user_id]
  end

  private
  def set_variables
    # TODO タグメニューをmemcachedに格納させる(紐付くタグの多い順)
    @tags  = Tag.order(Settings.default_order)
    @current_omniuser ||= Omniuser.find(session[:user_id]) if session[:user_id]
  end
end
