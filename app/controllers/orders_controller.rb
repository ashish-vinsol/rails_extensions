class OrdersController < ApplicationController
  # FIXME_SG: repeat?
  skip_before_action :authorize, only: [:new, :create]
  # FIXME_SG: move include statement from between before_actions
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_cart_contents, only: [:new, :create]

  # FIXME_SG: remove useless comments. you should add more meaningfull comments!

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    # FIXME_SG: This should be handled in a before_action.
    @order = Order.new
  end

  def edit
  end

  def create
    # FIXME_SG: do not set it from session[user_id] directly first fetch the user.
    # => then use it like @user.orders.new(...)
    @order = Order.new(order_params)
    @order.user_id = session[:user_id]
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        # FIXME_SG: do not destroy using session[:cart_id]
        # => use @cart.destroy
        # FIXME_SG: use session.delete
        # FIXME_SG: why are we not sending mail from model?
        # FIXME_SG: can do in single line.
        # FIXME_SG: is location actually used anywhere?
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
        # FIXME_SG: do not return empty body
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # FIXME_SG: what if not destroyed?
    # FIXME_SG: do not return empty body
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
      # Use callbacks to share common setup or constraints between actions.
      # FIXME_SG: what if not found?
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
