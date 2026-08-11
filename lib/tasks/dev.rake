namespace :dev do
  desc "Set every user's password to a known value for local testing (dev only, refuses to run elsewhere)"
  task reset_passwords: :environment do
    abort "Refusing to run outside development — this resets every user's password." unless Rails.env.development?

    password = ENV.fetch("PASSWORD", "newpassword")

    User.find_each do |user|
      user.update!(password: password, password_confirmation: password)
    end

    puts "Reset password for #{User.count} users to #{password.inspect}."
  end
end
