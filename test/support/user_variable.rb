module Support
  module UserVariable

    def self.included(base)
      base.extend(ClassMethods)
    end

    def stub_user_variable(variables, &blk)
      Rails.logger.debug variables
      get_result = ->(name) do
        var = variables[name.to_sym]
        raise ArgumentError if var.nil?
        var
      end

      ::UserVariable.stub(:get, get_result) do
        ::UserVariable.stub(:[], get_result, &blk)
      end
    end

    module ClassMethods
      def stub_user_variable(variables)
        obj = Object.new.tap { |obj| obj.extend(::Support::UserVariable) }

        define_method(:around) do |&blk|
          obj.stub_user_variable(variables, &blk)
        end
      end
    end
  end
end
