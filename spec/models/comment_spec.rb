require 'rails_helper'

describe Comment, type: :model do
  it { should validate_presence_of :content }
  it { should belong_to :post }
  it { should belong_to :user }
end
