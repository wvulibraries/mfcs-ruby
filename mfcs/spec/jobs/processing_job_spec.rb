require 'rails_helper'

RSpec.describe ProcessingJob, type: :job do
  describe "#perform_later" do
    it "creates working copy" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ProcessingJob.perform_later(1)
      }.to have_enqueued_job
    end
  end
end
