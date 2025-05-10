namespace :spec do
  desc "Run only approved specs listed in spec/approved_tests.txt"
  task approved: :environment do
    file_path = Rails.root.join("spec", "approved_tests.txt")
    unless File.exist?(file_path)
      puts "spec/approved_tests.txt not found!"
      exit(1)
    end

    test_targets = File.readlines(file_path).map(&:strip).reject(&:empty?).map do |path|
      path = path.sub(%r{^/}, "")            # remove leading slash
      path = "spec/#{path}" unless path.start_with?("spec/")
      path
    end

    puts "Running approved specs:"
    test_targets.each { |f| puts " - #{f}" }

    output_file = Rails.root.join("tmp", "approved_test_output.txt")
    fail_file   = Rails.root.join("tmp", "failing_examples.txt")

    # Ensure tmp folder exists
    FileUtils.mkdir_p("tmp")

    # Run specs with output capture
    system(
      "bundle exec rspec #{test_targets.join(' ')} " \
      "--format documentation --out #{output_file} " \
      "--failure-exit-code 1 " \
      "--format RSpec::Core::Formatters::FailureListFormatter --out #{fail_file}"
    )

    if File.exist?(fail_file) && !File.zero?(fail_file)
      puts "\n💥 Failures written to: #{fail_file}"
    else
      puts "\n✅ All specs passed!"
    end
  end
end


