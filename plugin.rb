# plugin.rb

# name: discourse-rules
# about: "A plugin to require users to agree to rules on first login."
# version: "0.1.0"
# authors: "Abaddon"
# url: "https://github.com/Abaddon1979/discourse-rules"

enabled_site_setting :rules_agreement_enabled

register_asset "javascripts/rules_agreement.js"
register_asset "stylesheets/rules_agreement.scss"

after_initialize do
  module ::RulesAgreement
    class Engine < ::Rails::Engine
      engine_name 'rules_agreement'
      isolate_namespace RulesAgreement
    end
  end

  Discourse::Application.routes.append do
    get '/check_rules' => 'rules_agreement#check_rules'
    post '/check_rules' => 'rules_agreement#agree_rules'
    get '/admin/plugins/rules_agreement' => 'rules_agreement_settings#index', as: 'admin_rules_agreement_settings'
    post '/admin/plugins/rules_agreement/update' => 'rules_agreement_settings#update', as: 'admin_rules_agreement_update'
    mount ::RulesAgreement::Engine, at: '/admin/plugins/rules_agreement'
  end

  require_dependency 'rules_agreement/controller'
  require_dependency 'rules_agreement/settings_controller'

  Discourse::Event.on(:user_created) do |user|
    user.trust_level = 0
    user.save!
  end
end
