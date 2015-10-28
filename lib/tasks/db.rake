namespace :db do
  task :setup_initial => :environment do
    `rake db:create`
    `rake db:migrate`
    `rake db:seed`
  end
end