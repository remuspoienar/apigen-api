<<-CODE

inside('../apigen') do
#{
str = ''
api_project.api_resources.map(&:name).each do |resource| 
  str << "\tgenerate(:scaffold, '#{resource.downcase}')\n"
  str << "\trun('bin/rails generate api_model #{resource} api_project=#{api_project.id}')\n"
end
str
}
  run('rm ../#{api_project.formatted_name}/app/models/!(application_record.rb)')
  run('mv api_projects/#{api_project.formatted_name}/app/models/* ../#{api_project.formatted_name}/app/models')
end

rails_command('db:setup')
rails_command('db:migrate')

after_bundle do
  git :init
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
end

CODE