# frozen_string_literal: true

require 'base64'
require_dependency 'notary'

module VeteranVerification
  module V0
    # KeysController returns a set of public keys as Base64URL encoded PEMs
    # that can be matched based on the kid (key id) and used to verify
    # payloads signed by the same Notary in other endpoints.
    class KeysController < ApplicationController
      skip_before_action(:authenticate)

      NOTARY = VeteranVerification::Notary.new(Settings.vet_verification.key_path)

      def index
        render json: {
          keys: [
            {
              kty: 'RSA',
              alg: 'RS256',
              kid: NOTARY.kid,
              pem: NOTARY.public_key.to_pem,
              e: Base64.urlsafe_encode64(NOTARY.public_key.e.to_s(2)),
              n: Base64.urlsafe_encode64(NOTARY.public_key.n.to_s(2))
            }
          ]
        }
      end
    end
  end
end
