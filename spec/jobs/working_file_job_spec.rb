require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe WorkingFileJob, type: :job do
  include ActiveJob::TestHelper
  let(:media) { FactoryBot.create :media }
  let(:job) { described_class.perform_later(media.id) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(media.id)
      .on_queue("default")
  end

  describe "#perform_later" do
    it "creates working copy" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        WorkingFileJob.perform_later(1)
      }.to have_enqueued_job
    end
  end
end
