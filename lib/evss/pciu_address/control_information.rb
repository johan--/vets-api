# frozen_string_literal: true
require 'common/models/base'

module EVSS
  module PCIUAddress
    class ControlInformation < Common::Base
      attribute :corp_avail_indicator, Boolean
      attribute :corp_rec_found_indicator, Boolean
      attribute :has_no_bdn_payments_indicator, Boolean
      attribute :incompetent_indicator, Boolean
      attribute :indentity_indicator, Boolean
      attribute :index_indicator, Boolean
      attribute :no_fiduciary_assigned_indicator, Boolean
      attribute :not_deceased_indicator, Boolean
    end
  end
end
