module Erp
  module Finances
    module Backend
      class ServicesController < Erp::Backend::BackendController
        before_action :set_service, only: [:move_up, :move_down, :edit, :update, :destroy]
        before_action :set_services, only: [:delete_all]

        # GET /services
        def index
          authorize! :view, Erp::Finances::Service
        end

        # POST /services/list
        def list
          authorize! :view, Erp::Finances::Service
          
          @services = Service.search(params).paginate(:page => params[:page], :per_page => 10)
          render layout: nil
        end

        # GET /services/new
        def new
          @service = Service.new
          authorize! :create, @service
        end

        # GET /services/1/edit
        def edit
          authorize! :edit, @service
        end

        # POST /services
        def create
          @service = Service.new(service_params)
          authorize! :create, @service
          
          @service.creator = current_user
          if @service.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @service.name,
                value: @service.id
              }
            else
              redirect_to erp_finances.edit_backend_service_path(@service), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /services/1
        def update
          authorize! :edit, @service
          
          if @service.update(service_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @service.name,
                value: @service.id
              }
            else
              redirect_to erp_finances.edit_backend_service_path(@service), notice: t('.success')
            end
          else
            render :edit
            puts @service.errors.to_json
          end
        end

        # DELETE /services/1
        def destroy
          authorize! :delete, @service
          
          @service.destroy

          respond_to do |format|
            format.html { redirect_to erp_finances.backend_services_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end        

        # DELETE ALL /services/delete_all?ids=1,2,3
        def delete_all
          authorize! :delete, @service
          @services.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end        

        # DATASELECT
        def dataselect
          respond_to do |format|
            format.json {
              render json: Service.dataselect(params[:keyword])
            }
          end
        end
        
        # Move up /services/up?id=1
        def move_up
          @service.move_up

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        # Move down /services/up?id=1
        def move_down
          @service.move_down

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_service
            @service = Service.find(params[:id])
          end

          def set_services
            @services = Service.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def service_params
            params.fetch(:service, {}).permit(:image_url, :name, :brochures, :link_docs, :description, :content,
                                              :meta_keywords, :meta_description, :icon, :is_home, :is_main)
          end
      end
    end
  end
end