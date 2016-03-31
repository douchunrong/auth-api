require 'rails_helper'

describe PartiUrlHelper do
  subject do
    Class.new do
      include PartiUrlHelper
    end.new
  end

  describe '#auth_api_port' do
    it 'returns default when env is empty' do
      stub_const 'ENV', { }
      expect(subject.auth_api_port).to eq(3030)
    end

    it 'returns from env' do
      stub_const 'ENV', {'AUTH_API_PORT' => '3040' }
      expect(subject.auth_api_port).to eq(3040)
    end

    it 'returns from env of docker link' do
      stub_const 'ENV', {'AUTH_API_PORT' => 'tcp://172.17.0.3:3050'}
      expect(subject.auth_api_port).to eq(3050)
    end
  end

  describe '#users_api_port' do
    it 'returns default when env is empty' do
      stub_const 'ENV', { }
      expect(subject.users_api_port).to eq(3030)
    end

    it 'returns from env' do
      stub_const 'ENV', {'USERS_API_PORT' => '3040' }
      expect(subject.users_api_port).to eq(3040)
    end

    it 'returns from env of docker link' do
      stub_const 'ENV', {'USERS_API_PORT' => 'tcp://172.17.0.3:3050'}
      expect(subject.users_api_port).to eq(3050)
    end
  end
end
