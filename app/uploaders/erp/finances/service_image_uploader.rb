module Erp
  module Finances
    class ServiceImageUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick
    
      storage :file
    
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
      
      version :system do
        process resize_to_fill: [150, 150]
      end
      
      version :home do
        process resize_to_fill: [360, 210]
      end
      
      version :detail do
				process :resize_to_fill => [750, 500]
			end
      
    end
  end
end