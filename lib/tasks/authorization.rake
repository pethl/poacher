namespace :permissions do
  desc "Seed/update groups and group_permissions from db/seeds/authorization.rb (idempotent, safe to re-run)"
  task seed: :environment do
    load Rails.root.join("db/seeds/authorization.rb")
  end
end
