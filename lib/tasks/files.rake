namespace :files do

  desc "This task finds files that have no user id ( uploaded on homepage by unregistered user ) and deletes them if they are more than 10 minutes old"
  task clean_up_unregistered_files: :environment do
    Rails.logger.info "Cleaning up old unregistered files"
    UploadedFile.clean_up_unregistered_files
  end

  desc "Update file requests to mark if they are billable"
  task update_billable: :environment do
    User.update_file_requests_billable
  end

end
