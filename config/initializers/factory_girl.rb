if defined? FactoryBot
  require Rails.root.join('test', 'factory_helper.rb')
  FactoryBot::SyntaxRunner.send(:include, FactoryHelper)
end
