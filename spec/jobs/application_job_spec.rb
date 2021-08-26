require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  describe "#perform_later" do
    it "creates working copy" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ApplicationJob.perform_later(1)
      }.to have_enqueued_job
    end
  end
end
