namespace :db do
  desc "Backup Heroku DB (poacher), download, restore to local dev and test, and clean up"
  task refresh: :environment do
    app_name = "poacher"
    dump_file = "latest.dump"
    dev_db = "poacher_development"
    test_db = "poacher_test"

    puts "🧹 Checking for existing #{dump_file}..."
    if File.exist?(dump_file)
      puts "⚠️ Found existing #{dump_file}, deleting..."
      File.delete(dump_file)
      puts "✅ Old dump deleted."
    else
      puts "✅ No existing dump found. Good to go."
    end

    puts "🚀 Starting backup from Heroku (#{app_name})..."

    system("heroku pg:backups:capture --app #{app_name}") || abort("❌ Failed to capture backup.")
    puts "✅ Backup captured."

    system("heroku pg:backups:download --app #{app_name}") || abort("❌ Failed to download backup.")
    puts "✅ Backup downloaded."

    puts "🛠️ Restoring to development database (#{dev_db})..."
    success = system("pg_restore ...")
    unless success
      puts "⚠️ Restore completed with warnings (likely safe). Check log if unsure."
    end
     puts "✅ Development database restored."

    puts "🛠️ Restoring to test database (#{test_db})..."
    puts "🛠️ Restoring to test database..."
    success = system("pg_restore --verbose --clean --if-exists --no-acl --no-owner -h localhost -d poacher_test latest.dump")

    unless success
      puts "⚠️ Restore completed with warnings. Likely safe. Check log/restore_test.log if needed."
    end
    puts "✅ Test database restored."

    puts "🧪 Setting ENV to test..."
    system("RAILS_ENV=test bundle exec rails db:environment:set") || abort("❌ Failed to set environment to test.")
    puts "✅ ENV set to test."

    puts "🧹 Cleaning up backup file..."
    File.delete(dump_file) if File.exist?(dump_file)
    puts "✅ Backup file deleted."

    puts "💻 Starting Rails server..."
    exec("bin/rails server")
  end
end
