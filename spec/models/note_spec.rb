require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:description) }
  end
end