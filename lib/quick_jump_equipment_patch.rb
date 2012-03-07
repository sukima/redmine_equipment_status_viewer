require_dependency 'search_controller'

module QuickJumpEquipmentPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :index, :quick_jump_equipment
    end
  end

  module InstanceMethods
    # Adds an easy way to jump to an equipment view based on id
    def index_with_quick_jump_equipment
      if User.current.allowed_to?(:view_equipment_assets)
        tmp_question = params[:q] || ""
        tmp_question.strip!
        if tmp_question.match(/^e(quipment)?\s*(\d+)$/i) && EquipmentAsset.find_by_id($2.to_i)
          redirect_to :controller => "equipment_assets", :action => "show", :id => $2
          return
        elsif tmp_question.match(/^c(heck[_\s]in)?\s*(\d+)$/i) && EquipmentAsset.find_by_id($2.to_i)
          redirect_to :controller => "asset_check_ins", :action => "new", :id => $2
          return
        end
      end

      # Continue on unscathed
      index_without_quick_jump_equipment
    end

  end
end

SearchController.send(:include, QuickJumpEquipmentPatch)
