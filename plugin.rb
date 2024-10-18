# plugin.rb
plugin_name = "rules_agreement"

class RulesAgreement < ::Plugin::Instance
  def initialize
    super
    register_javascript("rules_agreement.js")
    register_stylesheet("rules_agreement.css")

    # Add admin settings
    add_admin_route 'Rules Agreement', 'rules-agreement', 'admin/rules_agreement_settings'

    # Hook into the user login event
    ::Discourse::Application.routes.append do
      get '/check_rules', to: 'rules_agreement#check_rules'
      post '/check_rules', to: 'rules_agreement#update_rules_agreement'
    end
  end

  def rules
    SiteSetting.rules_agreement_rules || "No rules set."
  end
end
