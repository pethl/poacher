require 'roo'
namespace :import do
  desc 'Uploads data from xlsx'

  task :data, [:xlsx_path] => :environment do |_t, args|
    samples_controller = SamplesController.new
    samples_controller.import_data(xlsx_path: args[:xlsx_path])
  end


end
