require 'restful_model'

module Nylas
  class Account < RestfulModel
    parameter :account_id
    parameter :trial
    parameter :trial_expires
    parameter :sync_state
    parameter :billing_state

    def _perform_account_action!(action)
      raise UnexpectedAccountAction.new unless action == "upgrade" || action == "downgrade" || action == "revoke-all"

      collection = ManagementModelCollection.new(Account, @_api, {:account_id=>@account_id})

      ::RestClient.post("#{collection.url}/#{@account_id}/#{action}",{}) do |response, request, result|
        Nylas.interpret_response(result, response, :expected_class => Object)
      end
    end

    def upgrade!
      _perform_account_action!('upgrade')
    end

    def downgrade!
      _perform_account_action!('downgrade')
    end

    def revoke_all!
      _perform_account_action!('revoke-all')
    end
  end
end
