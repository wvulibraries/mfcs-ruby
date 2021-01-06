RSpec.shared_examples "a ip class" do
  context '.perform' do
    valid_ip = [ 
      Faker::Internet.public_ip_v4_address, 
      Faker::Internet.private_ip_v4_address, 
      Faker::Internet.ip_v4_cidr, 
      Faker::Internet.ip_v6_address, 
      Faker::Internet.ip_v6_cidr
    ]

    valid_ip.each do |ip| 
      it "valid ips -- #{ip} using the ip method" do
        base = described_class.new(ip, {}, 1)
        expect(base.perform).to be true
      end
    end 

    it 'expects failure on fake ip' do
      ip = '999.999.999.999'
      base = described_class.new(ip, {}, 1)
      expect(base.perform).to be false
    end

    it 'returns true for nil' do
      ip = nil
      base = described_class.new(ip, {}, 1)
      expect(base.perform).to be true
    end

    it 'returns true for empty' do
      ip = ''
      base = described_class.new(ip, {}, 1)
      expect(base.perform).to be true
    end
  end
end 