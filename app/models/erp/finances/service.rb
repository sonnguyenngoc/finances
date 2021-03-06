module Erp::Finances
  class Service < ApplicationRecord
    include Erp::CustomOrder
    
    mount_uploader :image_url, Erp::Finances::ServiceImageUploader
    mount_uploader :brochures, Erp::Finances::ServiceBrochuresUploader
    
    belongs_to :creator, class_name: "Erp::User"
    validates :name, :presence => true
    after_create :create_alias
    
    def create_alias
			name = self.get_name.present? ? self.get_name : self.name
			self.update_column(:alias, name.to_ascii.downcase.to_s.gsub(/[^0-9a-z ]/i, '').gsub(/ +/i, '-').strip)
		end
    
    def self.get_services
			self.order("custom_order ASC")
		end
    
    def self.get_service_is_home
			self.where(is_home: true).get_services
		end
    
    def self.get_service_is_main
			self.where(is_main: true).get_services
		end
    
    def get_name
      self.name
    end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
							or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      # join with users table for search creator
      query = query.joins(:creator)

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      end

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|service| {value: service.id, text: service.name} }
    end

  end
end
