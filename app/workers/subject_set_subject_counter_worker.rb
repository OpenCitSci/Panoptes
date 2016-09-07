class SubjectSetSubjectCounterWorker
  include Sidekiq::Worker

  sidekiq_options queue: :data_high,
    congestion: Panoptes::CongestionControlConfig.
      counter_worker.congestion_opts.merge({
        reject_with: :reschedule,
        key: ->(subject_set_id) {
          "subject_set_#{ subject_set_id }_counter_worker"
        }
      })

  def perform(subject_set_id)
    set = SubjectSet.find(subject_set_id)
    set.update_column(:set_member_subjects_count, set.set_member_subjects.count)
    set.workflow_ids.each do |w_id|
      UnfinishWorkflowWorker.perform_async(w_id)
    end
  end
end
