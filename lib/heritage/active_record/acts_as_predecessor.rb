module Heritage
  module ActiveRecord
    module ActsAsPredecessor
      
      def parent_model(options = {})
        acts_as_predecessor(options)
      end

      def acts_as_predecessor(options = {})
        extend ClassMethods
        include InstanceMethods

        options[:exposes] ||= []
        class_attribute :_acts_as_predecessor_settings
        self._acts_as_predecessor_settings = options

        belongs_to :heir, :polymorphic => true

        # Using #try because we're not sure if a particular predecessor
        # has heir. It may as well not have one.
        before_update :touch_heir, :unless => lambda { heir.try(:changed?) }
      end

      module ClassMethods

        def get_heritage_exposed_methods
          result = self._acts_as_predecessor_settings[:exposes]
          result.is_a?(Array) ? result : [result]
        end

      end

      module InstanceMethods
        def touch_heir
          if self.changed?
            # Using #try because we're not sure if a particular predecessor
            # has heir. It may as well not have one.
            heir.try(:touch)
          end
        end
      end

    end
  end
end
