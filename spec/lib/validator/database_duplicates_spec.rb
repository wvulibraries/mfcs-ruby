require 'rails_helper'

RSpec.describe Validator::DatabaseDuplicates, type: :model do
  
  before(:each) do
    @form = FactoryBot.create(:form)
    names = (1..10).map { Faker::Movies::LordOfTheRings.character }.uniq.sort
    names.each do |title|  
      item = FactoryBot.build(:metadata)
      item.data = {"title" => "#{title}"}
      item.form_id = @form.id
      item.save! 
    end 
  end
  
  context '.perform' do
    it 'has items to work with' do
      expect(Item.where(form_id: @form.id).count).to be_between(1, 10)
    end 
    
    it 'true because there are no duplicates in the database' do
      dups = described_class.new(@form.id, 'title')
      expect(dups.perform).to be true
    end 
    
    it 'false there are duplicates in the database' do
      2.times do 
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "Franklin D. Roose"}
        item.form_id = @form.id
        item.save! 
      end 

      dups = described_class.new(@form.id, 'title')
      expect(dups.perform).to be false
    end 
  end 

  context '.duplicate_items' do
    it 'should not have any duplicate items' do
      dups = described_class.new(@form.id, 'title')
      expect(dups.duplicate_items.count).to be_zero
      expect(dups.duplicate_items).to be_a Array
    end 

    it 'should return with a count of 1' do
      4.times do 
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "Franklin D. Roose"}
        item.form_id = @form.id
        item.save! 
      end 

      dups = described_class.new(@form.id, 'title')
      expect(dups.duplicate_items.count).to eq 1
      expect(dups.duplicate_items).to be_a Array
    end 
  end

  context '.records' do
    it 'should return blank or nil' do
      dups = described_class.new(@form.id, 'title')
      expect(dups.records).to be_nil
    end
    
    it 'should return 4 records' do
      4.times do 
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "Franklin D. Roose"}
        item.form_id = @form.id
        item.save! 
      end 

      dups = described_class.new(@form.id, 'title')
      expect(dups.records).to be_truthy
      expect(dups.records.count).to eq 4
      expect(dups.records).to be_an ActiveRecord::Relation
    end 
  end   
end 