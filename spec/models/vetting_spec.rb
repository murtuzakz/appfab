require 'spec_helper'

describe Vetting do
  it "should not be valid by default" do
    Vetting.new.should_not be_valid
  end

  context 'given anunsized idea' do
    before do
      @idea = Idea.make!
    end

    it 'cannot be created' do
      @user = User.make!.plays!(:product_manager)
      @user.vettings.build(idea: @idea).should_not be_valid
    end
  end

  context 'given a sized idea' do
    before do
      @idea = Idea.make!(:sized)
    end

    it 'can be created by a PM' do
      @user = User.make!.plays!(:product_manager)
      @user.vettings.create!(idea: @idea)
    end

    xit 'can be created by an architect' do
      @user = User.make!.plays!(:architect)
      @user.vettings.create!(idea: @idea)
    end

    xit 'cannot be created by other roles' do
      expect {
        @idea.author.vettings.create!(idea: @idea)
      }.to raise_error
    end

    xit 'can only be done once by a PM' do
      @user1 = User.make!.plays!(:product_manager)
      @user2 = User.make!.plays!(:product_manager)
      @user1.vettings.create!(idea: @idea)
      @user2.vettings.build(idea: @idea).should_not be_valid
    end

    it 'cannot be created twice by the same user' do
      @idea.author.vettings.create!(idea: @idea)
      @idea.author.vettings.build(idea: @idea).should_not be_valid
    end

    it 'triggers notification to the idea author' do
      @user = User.make!.plays!(:product_manager)
      lambda {
        @user.vettings.create!(idea: @idea)
      }.should change(@idea.author.notifications, :count).by(1) 
    end
  end
end
