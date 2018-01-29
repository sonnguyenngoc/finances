module Erp
  module Finances
    module Backend
      class ServiceRegistersController < Erp::Backend::BackendController
        before_action :set_service_register, only: [:edit, :update, :destroy]
        before_action :set_service_registers, only: [:delete_all]

        # GET /service_registers
        def index
        end

        # POST /service_registers/list
        def list
          @service_registers = ServiceRegister.search(params).paginate(:page => params[:page], :per_page => 10)
          
          if current_user.get_permission(:user_management, :service, :service_registers, :index) != "all"
            @service_registers = @service_registers.where(user_id: current_user)
          end
          
          render layout: nil
        end

        # GET /service_registers/new
        def new
          @service_register = ServiceRegister.new
          authorize! :create, @service_register
        end

        # GET /service_registers/1/edit
        def edit
          authorize! :edit, @service_register
        end

        # POST /service_registers
        def create
          @service_register = ServiceRegister.new(service_register_params)
          authorize! :create, @service_register
          
          if @service_register.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @service_register.name,
                value: @service_register.id
              }
            else
              redirect_to erp_finances.edit_backend_service_register_path(@service_register), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /service_registers/1
        def update
          authorize! :edit, @service_register
          
          if @service_register.update(service_register_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @service_register.name,
                value: @service_register.id
              }
            else
              redirect_to erp_finances.edit_backend_service_register_path(@service_register), notice: t('.success')
            end
          else
            render :edit
            puts @service_register.errors.to_json
          end
        end

        # DELETE /service_registers/1
        def destroy
          authorize! :delete, @service_register
          
          @service_register.destroy

          respond_to do |format|
            format.html { redirect_to erp_finances.backend_service_registers_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end        

        # DELETE ALL /service_registers/delete_all?ids=1,2,3
        def delete_all
          authorize! :delete, @service_register
          
          @service_registers.destroy_all

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
              render json: ServiceRegister.dataselect(params[:keyword])
            }
          end
        end            

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_service_register
            @service_register = ServiceRegister.find(params[:id])
          end

          def set_service_registers
            @service_registers = ServiceRegister.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def service_register_params
            params.fetch(:service_register, {}).permit(:name, :service_id, :user_id, :price, :start_date, :end_date, :note)
          end
      end
    end
  end
end