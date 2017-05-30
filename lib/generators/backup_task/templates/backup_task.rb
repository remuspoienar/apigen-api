<<-CODE
namespace :backup do

  desc 'Backup all previous existing data through JSON serialization'

  task :store => :environment do
    Dir.mkdir('db/backup')
    (ActiveRecord::Base.connection.tables - %w{schema_migrations ar_internal_metadata}).each do |table|
      json = ActiveRecord::Base.connection.execute("SELECT * FROM \#{table.upcase}").to_json
      File.open("db/backup/\#{table}.json", 'w') { |f| f.write(json) }
    end
  end

  desc 'Restore previously created data'

  task :load => :environment do
    (ActiveRecord::Base.connection.tables - %w{schema_migrations ar_internal_metadata}).each do |table|
      ActiveRecord::Base.connection.execute("ALTER TABLE \#{table} DISABLE TRIGGER ALL") # needed when child record are created before their parent corespondent
    end

    table_for_klass = #{api_project.api_resources.each.map { |api_resource| [api_resource.name, api_resource.advanced_options['last_table_name']] }.to_h.inspect}

    table_for_klass.each do |klass, table|
      table_data = JSON.parse(File.read(File.open("db/backup/\#{table}.json")))
      klass = klass.constantize
      its_columns = klass.column_names

      table_data.each do |row|
        new_one = klass.new
        its_columns.each do |column|
          value = row.has_key?(column) ? row[column] : '(default)'
          new_one.send(:write_attribute, column, value)
        end
        new_one.save(validate: false)
      end
      File.delete("db/backup/\#{table}.json")
    end

    (ActiveRecord::Base.connection.tables - %w{schema_migrations ar_internal_metadata}).each do |table|
      ActiveRecord::Base.connection.execute("ALTER TABLE \#{table} ENABLE TRIGGER ALL") # needed when child record are created before their parent corespondent
    end
  end

end
CODE