require 'dispatcher'

class ::Dispatcher

  class << self

    alias reset_application_no_active_model! reset_application!
    def reset_application!
      reset_application_no_active_model!
      Dependencies.remove_subclasses_for(ActiveModel)
    end
    
  end
end
