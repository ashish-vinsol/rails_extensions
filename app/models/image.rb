class Image < ActiveRecord::Base
  belongs_to :product

  def self.upload(params, p_id)
    uploaded_io = params
    uploaded_io.each do |io|
      File.open(Rails.root.join('app', 'assets', 'images', io.original_filename), 'wb') do |file|
        file.write(io.read)
      end
      Image.create(name: io.original_filename, product_id: p_id )
    end
  end

end
