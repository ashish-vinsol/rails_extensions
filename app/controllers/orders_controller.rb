class OrdersController < ApplicationController
  # FIXME_SG: repeat?
  skip_before_action :authorize, only: [:new, :create]
  # FIXME_SG: move include statement from between before_actions
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # FIXME_SG: remove useless comments. you should add more meaningfull comments!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    # FIXME_SG: This should be handled in a before_action.
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end

    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
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
        Cart.destroy(session[:cart_id])
        # FIXME_SG: use session.delete
        session[:cart_id] = nil
        # FIXME_SG: why are we not sending mail from model?
        OrderNotifier.received(@order).deliver
        # FIXME_SG: can do in single line.
        format.html { redirect_to store_url, notice:
          I18n.t('.thanks') }
        # FIXME_SG: is location actually used anywhere?
        format.json { render action: 'show', status: :created,
          location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors,
          status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        # FIXME_SG: do not return empty body
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    # FIXME_SG: what if not destroyed?
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      # FIXME_SG: do not return empty body
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # FIXME_SG: what if not found?
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
  #...
end
