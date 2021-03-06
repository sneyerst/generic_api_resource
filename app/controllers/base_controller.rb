class BaseController < ActionController::Base

  protect_from_forgery with: :null_session

  RESOURCE_CLASS = nil # Class
  RESOURCE_NAME_SINGULAR = nil # Symbol
  RESOURCE_NAME_PLURAL = nil # Symbol
  RESOURCE_VIEW = nil # Symbol
  ORDER_FIELD = nil # Symbol

  def index
    if can? :read, self.class::RESOURCE_CLASS
      @filters = params
      if params[:filters_only].present?
        @generic_resources = []
        render "api/v1/#{self.class::RESOURCE_VIEW}/index"
      else
        @generic_resources = self.class::RESOURCE_CLASS.accessible_by(current_ability)
        filter_params.keys.each do |key|
          value = filter_params[key]
          if value.present?
            value = true if value == 'true'
            value = false if value == 'false'
            @generic_resources = @generic_resources.send("filter_#{key}", value)
          end
        end
        if self.class::ORDER_FIELD
          @generic_resources = @generic_resources.order(self.class::ORDER_FIELD)
        end
        render "api/v1/#{self.class::RESOURCE_VIEW}/index"
      end
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def show
    @generic_resource = self.class::RESOURCE_CLASS.find(params[:id])
    if can? :read, @generic_resource
      render "api/v1/#{self.class::RESOURCE_VIEW}/show"
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def new
    if can? :create, self.class::RESOURCE_CLASS
      @generic_resource = self.class::RESOURCE_CLASS.new(filter_params)
      render "api/v1/#{self.class::RESOURCE_VIEW}/show"
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def create
    @generic_resource = self.class::RESOURCE_CLASS.new(resource_params)
    if can? :create, @generic_resource
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
    if can? :update, self.class::RESOURCE_CLASS
      redirect_to action: :show
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end


  def update
    @generic_resource = self.class::RESOURCE_CLASS.find(params[:id])
    if can? :update, @generic_resource
      if @generic_resource.update(resource_params)
        render "api/v1/#{self.class::RESOURCE_VIEW}/show"
      else
        render json: @generic_resource.errors.as_json, status: :unprocessable_entity
      end
    else
      render json: {error: :forbidden}, status: :forbidden
    end
  end

  def destroy
    @generic_resource = self.class::RESOURCE_CLASS.find(params[:id])
    if can? :destroy, @generic_resource
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
