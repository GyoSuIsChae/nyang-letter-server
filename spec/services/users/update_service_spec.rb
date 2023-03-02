# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::UpdateService, "#run", type: :integration do
  let(:base_params) { {} }

  subject {
    result = described_class.run(params)
    result.log_error(Logger.new(STDOUT))
    result
  }


  context "when" do
    let(:params) { base_params.merge({}) }

    it { expect(subject.valid?).to be true }
  end
end
