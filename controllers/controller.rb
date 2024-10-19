# rules_agreement/controller.rb
# frozen_string_literal: true

class RulesAgreementController < ApplicationController
    before_action :require_logged_in
  
    def check_rules
      user = current_user
  
      if user
        rules = SiteSetting.rules_agreement_rules.split("\n").reject(&:empty?)
        trust_level = user.trust_level
  
        # Only show modal for trust level 0 (new users)
        if trust_level == 0
          render json: { first_login: true, rules: rules }
        else
          render json: { first_login: false }
        end
      else
        render json: { error: 'Not authenticated' }, status: :unauthorized
      end
    end
  
    def agree_rules
      user = current_user
  
      if user && user.trust_level == 0
        user.trust_level = 1 # Upgrade to Trust Level 1
        user.save!
        render json: { success: true }
      else
        render json: { error: 'Not authenticated or already agreed' }, status: :unauthorized
      end
    end
  end