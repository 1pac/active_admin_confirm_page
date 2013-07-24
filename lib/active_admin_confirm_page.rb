require "active_admin_confirm_page/engine"
require "active_admin_confirm_page/show"

module ActiveAdminConfirmPage
  def self.included(dsl)
    dsl.config.collection_actions <<
      ::ActiveAdmin::ControllerAction.new(:validate, :method => :post)
    dsl.config.member_actions <<
      ::ActiveAdmin::ControllerAction.new(:validate, :method => :put)

    dsl.controller do
      def validate
        is_edit = params[:_method] == 'put'
        object = is_edit ? resource : build_resource
        object.assign_attributes(*resource_params)
        if object.valid?
          render active_admin_template('show'), :layout => false, :status => :ok
        else
          action = is_edit ? 'edit' : 'new'
          render active_admin_template(action), :layout => false, :status => :ok
        end
      end
    end
  end
end
