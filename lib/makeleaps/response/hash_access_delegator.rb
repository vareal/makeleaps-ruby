module Makeleaps
  module Response
    module HashAccessDelegator
      def delegate_hash_access(hash_name, *method_names)
        method_names.each do |method|
          define_method(method.to_sym) do
            base_hash = instance_eval(hash_name)
            base_hash[method.to_s]
          end
        end
      end
    end
  end
end
