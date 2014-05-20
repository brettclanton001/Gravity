# encoding: utf-8
require 'spec_helper'

describe CostCalculator do
  describe "Basic Maths" do
    before do
      @gb = 1073741824 # 1 GB
      @hundred_gb = @gb * 100 # 100 GB
      @cc = CostCalculator.new
      @cc.bytes = @hundred_gb
    end
    it "should return inputted values" do
      @cc.bytes.should eq @hundred_gb
    end
    it "should calculate cost in cents" do
      @cc.s3_cost.should eq 300
    end
    it "should calculate charge" do
      @cc.charge.should eq 648
    end
    it "should calculate final charge" do
      @cc.final_charge.should eq 648
    end
    it "should calculate final charge with minimum value" do
      @cc.bytes = @gb
      @cc.final_charge.should eq 50
    end
  end
end
