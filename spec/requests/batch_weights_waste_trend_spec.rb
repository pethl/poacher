require "rails_helper"

RSpec.describe "Batch weight waste trend", type: :request do
  let(:user) { create(:user) }

  before do
    # BatchWeight is Cutting-read / Admin+Mgmt only — grant directly rather than relying
    # on the business matrix (db/seeds/authorization.rb), which can change independently.
    join_group(user, "cutting")
    grant("cutting", "batch_weight", :read)

    sign_in user
  end

  it "filters the report by range and cheese type" do
    create(:batch_weight,
           date: Date.current - 1.month,
           makesheet: create(:makesheet, make_type: "Standard"),
           washed_batch_weight: 100,
           total_waste: 4)
    create(:batch_weight,
           date: Date.current - 1.month,
           makesheet: create(:makesheet, make_type: "Red"),
           washed_batch_weight: 100,
           total_waste: 8)

    get waste_trend_batch_weights_path, params: { months: 3, make_type: "Standard" }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Standard batches")
    expect(response.body).to include("Standard 3-month rolling average")
    expect(response.body).not_to include("Red batches")
    expect(response.body).to include("1 batch")
  end

  it "is denied for a user without :read on BatchWeight" do
    outsider = create(:user)
    sign_in outsider

    get waste_trend_batch_weights_path

    expect(response).to redirect_to(root_path)
  end
end
