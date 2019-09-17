require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#email' do
    email = 'USER@USER.USER'
    User.create(username: 'user1', email: email, password: '123456')
    subject { User.new(username: 'user', password: '123456')}

    it { should_not allow_value('asdf').for(:email) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it 'should convert it to downcase before save' do
      subject.email = email
      subject.run_callbacks :save
      expect(subject.email).to eq(email.downcase)
    end
  end

  describe '#password' do
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6)}
    it { should have_secure_password }
  end

  describe '#username' do
    it { should validate_presence_of(:username) }
  end
end
