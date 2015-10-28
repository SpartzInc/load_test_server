namespace :fixture do
  desc "generate fixtures for a given sql query from the current development database"
  #rake fixture:generator["select * from users","users"]
  task :generator, [:sql, :file_name] => :environment do |t, args|
    args.with_defaults(:sql => nil, :file_name => nil)
    i = "000"
    p "creating fixture - #{args.file_name}"
    File.open("#{Rails.root}/test/fixtures/#{args.file_name}.yml", 'a+') do |file|
      data = ActiveRecord::Base.connection.select_all(args.sql)
      file.write data.inject({}) { |hash, record|
                   number = i.succ!
                   hash["#{args.file_name}_#{number}"] = record
                   hash
                 }.to_yaml
    end
  end

  task :generate_all => :environment do
    data = ActiveRecord::Base.connection.select_all('SHOW TABLES;')
    data.each { |record|
      table_name = record.values.first
      next if table_name.match(/schema_migrations/)

      p "creating fixture - #{table_name}.yml"

      i = "000"
      File.open("#{Rails.root}/test/fixtures/#{table_name}.yml", 'a+') do |file|
        data = ActiveRecord::Base.connection.select_all("select * from #{table_name}")
        file.write data.inject({}) { |hash, record|
                     number = i.succ!
                     hash["#{table_name}_#{number}"] = record
                     hash
                   }.to_yaml
      end
    }
  end
end