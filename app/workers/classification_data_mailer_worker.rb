class ClassificationDataMailerWorker
  include Sidekiq::Worker

  def perform(project_id, s3_url)
    ClassificationDataMailer.classification_data(Project.find(project_id), s3_url.to_s).deliver
  end
end
