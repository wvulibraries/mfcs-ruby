require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ConvertingFileJob, type: :job do
  include ActiveJob::TestHelper
  let(:media) { FactoryBot.create :media }
  let(:job) { described_class.perform_later(media.id) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(media.id)
      .on_queue("default")
  end
end
