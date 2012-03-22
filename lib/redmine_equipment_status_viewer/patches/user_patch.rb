module RedmineEquipmentStatusViewer
  module Patches
    module UserPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)o

        base.class_eval do
          alias_method_chain :to_s, :foobar
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def to_s_with_foobar
          str = to_s_without_foobar
          str << " FooBar!"
          return str
        end
      end
    end
  end
end
