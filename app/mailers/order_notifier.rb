class OrderNotifier < ApplicationMailer
  default from: 'Ashish <ashish@vinsol.com>'


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def received(order)
    @order = order
    if @order.images.size == 1
      attachments.inline[@order.images.first.name] = File.read(Rails.root.join('assets/images/'+ @order.images.first.name))
    end
    if @order.images.size > 1
      @order.images.each do |image|
        mail.attachments['filename.jpg'] = File.read(Rails.root.join('assets/images/'+ image.name))
        mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
      end
    end
  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.shipped.subject
  #
  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

end
