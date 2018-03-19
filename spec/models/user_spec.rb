require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without a username" do
    user = FactoryBot.build(:user, username: nil)
    user.valid?
    expect(user.errors[:username]).to include("を入力してください")
  end

  it "is invalid without a email" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is invalid with a duplicate username" do
    FactoryBot.create(:user, username: "foo")
    user = FactoryBot.build(:user, username: "foo")
    user.valid?
    expect(user.errors[:username]).to include("はすでに存在します")
  end

  it "is invalid with a duplicate email" do
    FactoryBot.create(:user, email: "foo@example.com")
    user = FactoryBot.build(:user, email: "foo@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end


end
