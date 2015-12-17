class Admin::ReportsController < ApplicationController
  def index
    User.where(id: session[:user_id]).each do |user|
      if user.role != 'admin'
        redirect_to store_url
        flash[:notice] = "You don't have privilege to access this section"
      end
    end
    @orders = Order.all
  end
end
