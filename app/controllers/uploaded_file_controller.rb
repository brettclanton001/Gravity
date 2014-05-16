class UploadedFileController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show_file
    file = UploadedFile.find_with_token(params[:token])
    file.log_file_request
    send_file file.cached_file, filename: "#{file.token}.#{file.upload.file.extension.downcase}", type: file.type, disposition: "inline"
  end

  def create
    file = UploadedFile.new(uploaded_file_params)
    loop do
      file.token = SecureRandom.urlsafe_base64(4)
      break if UploadedFile.where(token: file.token).count == 0
    end
    file.user_id = current_user.id
    respond_to do |format|
      if file.save
        format.html { redirect_to root_path, notice: 'Uploaded image was successfully created.' }
        format.json { render json: {id: file.id, url: file.short_url, token: file.token} }
      else
        format.html { redirect_to root_path, notice: 'Something went wrong.' }
        format.json { render json: file.errors, status: :unprocessable_entity }
      end
    end
  end

  def uploaded_file_params
    params.require(:uploaded_file).permit(:upload)
  end
end
