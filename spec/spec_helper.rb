require 'factory_bot'
require 'active_model'

I18n.enforce_available_locales = false

FactoryBot.find_definitions

PROJECT_ROOT = File.expand_path("../..", __FILE__)

Dir.glob(File.join(PROJECT_ROOT, "lib", "*.rb")).each do |file|
  require file
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
