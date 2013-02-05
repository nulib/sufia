# Copyright © 2013 The Pennsylvania State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe Collection do
  before(:all) do
    @user = FactoryGirl.find_or_create(:user)
  end
  after(:all) do
  	@user.destroy
  end
  before(:each) do
    @collection = Collection.new
    @collection.apply_depositor_metadata(@user.user_key)
    @collection.save
    @gf1 = GenericFile.new
    @gf1.apply_depositor_metadata(@user.user_key)
    @gf1.save
    @gf2 = GenericFile.new
    @gf2.apply_depositor_metadata(@user.user_key)
    @gf2.save
  end
  after(:each) do
  	@collection.destroy
  	@gf1.destroy
  	@gf2.destroy
  end
  it "should have a depositor" do
  	@collection.depositor.should == @user.user_key
  end
  it "should be empty by default" do 
  	@collection.generic_files.should be_empty
  end
  it "should have many files" do
  	@collection.generic_files = [@gf1, @gf2]
  	@collection.save
  	Collection.find(@collection.pid).generic_files.should == [@gf1, @gf2]
  end
  it "should allow new files to be added" do
  	@collection.generic_files = [@gf1]
  	@collection.save
    @collection = Collection.find(@collection.pid)
    @collection.generic_files << @gf2
  	@collection.save
  	Collection.find(@collection.pid).generic_files.should == [@gf1, @gf2]
  end

  it "should include the noid in solr" do
    @collection.save
    @collection.to_solr['noid_s'].should == @collection.noid
  end

  it "should set the date uploaded on create" do
    @collection.save
    @collection.date_uploaded.should be_kind_of(Date)
  end

  pending "should update the date modified on update" do

    upload_time = DateTime.now
    modified_time = DateTime.now
    DateTime.stub(:now).and_return(upload_time, modified_time)
    @collection.save
    @collection.date_modified.should == upload_time.iso8601
    @collection.generic_files = [@gf1] 
    @collection.save
    @collection.date_modified.should == modified_time.iso8601
  end

  it "should have the expected display terms"
  it "should have the expected edit terms"
  it "should have a title"
  it "should have a description"
  it "should be able to have zero files"
  it "should not delete member files when deleted"
end
