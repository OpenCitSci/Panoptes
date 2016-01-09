class RequeueClassificationsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly.minute_of_hour(0, 15, 30, 45)}

  def perform
    non_lifecycled.find_in_batches do |classifications|
      classifications.each do |classification|
        ClassificationWorker.perform_async(classification.id, :create)
      end
    end
  end

  private

  def non_lifecycled
    Classification
    .where(lifecycled_at: nil)
    .where("created_at <= ?", Panoptes.lifecycled_live_window.minutes.ago)
  end
end
