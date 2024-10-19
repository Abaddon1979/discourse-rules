# admin/rules_agreement_settings.rb
# frozen_string_literal: true

class RulesAgreementSettingsController < Admin::AdminController
  def index
    @rules = SiteSetting.rules_agreement_rules
  end

  def update
    SiteSetting.rules_agreement_rules = params[:rules]
    flash[:notice] = "Rules updated successfully."
    redirect_to admin_rules_agreement_settings_path
  end
end
  