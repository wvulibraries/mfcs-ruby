# Fieldable shared example.
RSpec.shared_examples 'readonly' do
  let(:klass) { described_class.new }
  let(:system) {  System.new(name: 'readonly', value: true) }

  context 'locked database should not save' do
    it 'does not save new' do
      system.save
      new_klass = described_class.new
      expect { new_klass.save(validate: false) }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'does not update existing' do
      klass.save(validate: false) # save class to use later
      system.save
      klass.updated_at = Time.now
      expect { klass.save(validate: false) }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'does not delete' do
      klass.save(validate: false) # save class to use later
      system.save
      expect { klass.destroy }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  context 'unlocked database should save' do
    it 'saves new' do
      system.value = false
      system.save
      new_klass = described_class.new
      expect(new_klass.save(validate: false)).to be_truthy
    end

    it 'updates existing' do
      klass.save(validate: false) # save class to use later
      system.value = false
      system.save
      klass.updated_at = Time.now
      expect(klass.save(validate: false)).to be_truthy
    end

    it 'deletes' do
      klass.save(validate: false) # save class to use later
      system.value = false
      system.save
      expect(klass.destroy).to be_truthy
    end
  end
end
