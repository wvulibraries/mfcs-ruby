# app/jobs/reporocess_form_job.rb

# Import Job
class ReprocessFormJob < ApplicationJob
  queue_as :default

  def perform(form_id)
    # get all items for form
    items = Item.where(form_id: form_id)
    items.each do |item|
      # submit item to reprocess
      ReprocessItemJob.perform_later(item.id)
    end
  end  

end
