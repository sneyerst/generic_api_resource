class BaseController < ActionController::Base

  protect_from_forgery with: :null_session

  RESOURCE_CLASS = nil # Class
  RESOURCE_NAME_SINGULAR = nil # Symbol
  RESOURCE_NAME_PLURAL = nil # Symbol
  RESOURCE_VIEW = nil # Symbol

  def index
    if can? :read, self.class::RESOURCE_CLASS
      if params[:filters_only].present?
        @generic_resources = []
        render "api/v1/#{self.class::RESOURCE_VIEW}/index"
      else
        @generic_resources = self.class::RESOURCE_CLASS.all
        @filters = params
        filter_params.keys.each do |key|
          value = filter_params[key]
          if value.present?
            value = true if value == 'true'
            value = false if value == 'false'
            @generic_resources = @generic_resources.send("filter_#{key}", value)
          end
        end
        render "api/v1/#{self.class::RESOURCE_VIEW}/index"
      end
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def show
    if can? :read, self.class::RESOURCE_CLASS
      @generic_resource = self.class::RESOURCE_CLASS.find(params[:id])
      render "api/v1/#{self.class::RESOURCE_VIEW}/show"
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def new
    if can? :create, self.class::RESOURCE_CLASS
      @generic_resource = self.class::RESOURCE_CLASS.new
      render "api/v1/#{self.class::RESOURCE_VIEW}/show"
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def create
    if can? :create, self.class::RESOURCE_CLASS
      @generic_resource = self.class::RESOURCE_CLASS.new(resource_params)
      if @generic_resource.save
        render "api/v1/#{self.class::RESOURCE_VIEW}/show"
      else
        render json: @generic_resource.errors.as_json, status: :unprocessable_entity
      end
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end


  def edit
    if can? :create, self.class::RESOURCE_CLASS
      redirect_to action: :show
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end


  def update
    if can? :create, self.class::RESOURCE_CLASS
      @generic_resource = self.class::RESOURCE_CLASS.find(params[:id])
      if @generic_resource.update_attributes(resource_params)
        render "api/v1/#{self.class::RESOURCE_VIEW}/show"
      else
        render json: @generic_resource.errors.as_json, status: :unprocessable_entity
      end
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def destroy
    if can? :destroy, self.class::RESOURCE_CLASS
      @generic_resource = self.class::RESOURCE_CLASS.find(params[:id])
      @generic_resource.destroy
      render json: {status: :ok}
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  private

  def resource_params
    params.require(self.class::RESOURCE_NAME_SINGULAR).permit(:id)
  end

  def filter_params
    params.permit(:id)
  end

end
