require "rails_helper"

RSpec.describe Membership, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:group) }
  end

  it "won't let the same user join the same group twice" do
    user = create(:user)
    group = create(:group, :office)
    create(:membership, user: user, group: group)

    duplicate = build(:membership, user: user, group: group)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:user_id]).to be_present
  end

  it "lets one user belong to several different groups" do
    user = create(:user)
    office = create(:group, :office)
    hs = create(:group, :hs)

    create(:membership, user: user, group: office)
    second = build(:membership, user: user, group: hs)

    expect(second).to be_valid
  end

  it "lets several different users belong to the same group" do
    group = create(:group, :dairy)
    first_user = create(:user)
    second_user = create(:user)

    create(:membership, user: first_user, group: group)
    second = build(:membership, user: second_user, group: group)

    expect(second).to be_valid
  end
end
