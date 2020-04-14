# frozen_string_literal: true

module CARMA
  module Models
    class Submission < Base
      attr_reader :metadata
      attr_accessor :data, :carma_case_id, :submitted_at

      request_payload_key :data, :metadata

      # Returns a new CARMA::Models::Submission built from a CaregiversAssistanceClaim.
      #
      #
      # @param claim [CaregiversAssistanceClaim] A validated CaregiversAssistanceClaim
      # @param metadata [Hash] Additional data that can be submitted along with the claim's form data
      # @return [CARMA::Models::Submission] A persisted instance of Account
      #
      def self.from_claim(claim, metadata = {})
        new(
          data: claim.parsed_form,
          metadata: metadata.merge(claim_id: claim.id)
        )
      end

      def initialize(args = {})
        @carma_case_id = args[:carma_case_id]
        @submitted_at = args[:submitted_at]
        @data = args[:data]

        send('metadata=', args[:metadata] || {})
      end

      def submit!
        raise 'This submission has already been submitted to CARMA' if submitted?

        response = client.create_submission_stub(to_request_payload)

        @carma_case_id = response['data']['carmacase']['id']
        @submitted_at = response['data']['carmacase']['createdAt']

        self
      end

      def submitted?
        @submitted_at.present? || @carma_case_id.present?
      end

      def metadata=(args = {})
        @metadata = Metadata.new(args)
      end

      private

      def client
        @client ||= CARMA::Client::Client.new
      end
    end
  end
end
