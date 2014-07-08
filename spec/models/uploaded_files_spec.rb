require 'spec_helper'

describe UploadedFile do

  context 'unregistered file cleanup' do
    it 'should destroy old unregistered files' do
      FactoryGirl.create( :uploaded_file, token: '1', user_id: nil, created_at: Time.now - 12.minutes )
      FactoryGirl.create( :uploaded_file, token: '2', user_id: nil, created_at: Time.now - 8.minutes )
      FactoryGirl.create( :uploaded_file, token: '3', user_id: nil, created_at: Time.now - 1.day )
      FactoryGirl.create( :uploaded_file, token: '4', created_at: Time.now - 12.minutes )
      UploadedFile.count.should eq 4
      UploadedFile.clean_up_unregistered_files
      UploadedFile.count.should eq 2
    end

    it 'should destroy old unregistered files when all files are old and unregistered' do
      FactoryGirl.create( :uploaded_file, token: '1', user_id: nil, created_at: Time.now - 12.minutes )
      FactoryGirl.create( :uploaded_file, token: '3', user_id: nil, created_at: Time.now - 1.day )
      UploadedFile.count.should eq 2
      UploadedFile.clean_up_unregistered_files
      UploadedFile.count.should eq 0
    end

    it 'should destroy no files when none are old unregistered files' do
      FactoryGirl.create( :uploaded_file, token: '2', user_id: nil, created_at: Time.now - 8.minutes )
      FactoryGirl.create( :uploaded_file, token: '4', created_at: Time.now - 12.minutes )
      UploadedFile.count.should eq 2
      UploadedFile.clean_up_unregistered_files
      UploadedFile.count.should eq 2
    end
  end
end
