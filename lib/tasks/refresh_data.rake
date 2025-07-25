namespace :db do
  desc "Backup Heroku DB (poacher), download, restore to local dev and test, and clean up"
  task refresh: :environment do
    app_name = "poacher"
    dump_file = "latest.dump"
    dev_db = "poacher_development"
    test_db = "poacher_test"

    # Detect current Postgres user
    pg_user = ENV["PGUSER"] || `whoami`.strip
    pg_host = "localhost"

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

    # Shared restore logic
    restore_db = lambda do |db_name|
      puts "🛠️ Restoring to #{db_name}..."

      puts "💣 Terminating active connections to #{db_name}..."
      disconnect_cmd = <<~SQL
        SELECT pg_terminate_backend(pg_stat_activity.pid)
        FROM pg_stat_activity
        WHERE pg_stat_activity.datname = '#{db_name}'
          AND pid <> pg_backend_pid();
      SQL
      system("psql -U #{pg_user} -h #{pg_host} -d postgres -c \"#{disconnect_cmd.strip}\"") ||
        puts("⚠️ Could not terminate connections (maybe none existed).")

      puts "🧨 Dropping #{db_name}..."
      system("dropdb -U #{pg_user} -h #{pg_host} #{db_name}") ||
        puts("⚠️ Could not drop #{db_name} (maybe it didn’t exist).")

      puts "🧱 Creating #{db_name}..."
      system("createdb -U #{pg_user} -h #{pg_host} #{db_name}") ||
        abort("❌ Failed to create #{db_name}.")

      puts "📦 Restoring data into #{db_name}..."
      success = system("pg_restore --verbose --clean --if-exists --no-acl --no-owner -U #{pg_user} -h #{pg_host} -d #{db_name} #{dump_file}")
      unless success
        puts "⚠️ Restore completed with warnings. Likely safe. Check logs if unsure."
      end
      puts "✅ #{db_name} restored."
    end

    # Restore and migrate dev DB
    restore_db.call(dev_db)
    puts "🚚 Running migrations on #{dev_db}..."
    system("RAILS_ENV=development bundle exec rails db:migrate") || abort("❌ Failed to migrate #{dev_db}.")
    puts "✅ Migrations applied to #{dev_db}."

    # Restore and migrate test DB
    restore_db.call(test_db)
    puts "🚚 Running migrations on #{test_db}..."
    system("RAILS_ENV=test bundle exec rails db:migrate") || abort("❌ Failed to migrate #{test_db}.")
    puts "✅ Migrations applied to #{test_db}."


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

