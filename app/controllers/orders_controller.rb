class OrdersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_cart_contents, only: [:new, :create]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = session[:user_id]
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        @cart.destroy
        session.delete(:cart_id)
        OrderNotifier.received(@order).deliver_now
        format.html { redirect_to store_url, notice: I18n.t('.thanks') }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @order.destroy
      respond_to do |format|
        format.html { redirect_to orders_url }
      end
    else
      flash[:notice] = "Can't delete order"
      redirect_to store_url
    end
  end

  private

  def set_order
    if Order.find(params[:id]).present?
      @order = Order.find(params[:id])
    else
      flash[:notice] = "Can't find order"
      redirect_to store_url
    end
  end

  def order_params
    params.require(:order).permit(:name, :address, :email, :pay_type)
  end

  def check_cart_contents
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty. Add new products"
      return
    end
  end

end
