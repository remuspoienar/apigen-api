class ApiProject < ApplicationRecord
  belongs_to :created_by, class_name: 'ApiUser'

  has_many :api_resources, dependent: :destroy, inverse_of: :api_project

  validates_uniqueness_of :name, scope: :created_by_id

  accepts_nested_attributes_for :api_resources, reject_if: :all_blank, allow_destroy: true

  def as_json(opts={})
    result = self.attributes.symbolize_keys.except(:created_by_id, :updated_at)

    # result[:created_by] = self.created_by.as_json
    result[:api_resources] = self.api_resources.to_a.map{|api_resource| api_resource.as_json }

    result
  end

  def formatted_name
    name.downcase.gsub(' ', '_')
  end

  def generate_code
    shutdown if launched?
    system "cd #{Rails.root} ; bundle exec rails generate application_template #{formatted_name} api_project=#{id} ; rm ~/projects/#{formatted_name}_template.rb  ; mv application_templates/#{formatted_name}_template.rb ~/projects ; cd ~/projects ; rm -rf #{formatted_name} ; rails _5.0.3_ new #{formatted_name} -T --database=\"postgresql\" --api -m #{formatted_name}_template.rb"
  end

  def launch
    # ([*3000..3500] - [3000, 3003]).sample
    return if launched
    fork do
      system "cd ~/projects/#{formatted_name} ; bundle exec rails server -p #{4000}"
    end
    update_attribute(:launched, true)
  end

  def shutdown
    return unless launched
    fork do
      path = File.join(Rails.root, '..', formatted_name, 'tmp', 'pids')
      pid = File.read(File.open(path + '/server.pid'))
      puts "Killing rails server with pid: #{pid}"
      system "kill -9 #{pid}"
    end
    update_attribute(:launched, false)
  end

end


# ApiProject.create!(created_by: user, name: 'proj name', api_resources_attributes: [{name: 'Message', api_attributes_attributes: [{name: 'content', db_type: 'text'}]}, {name: 'Enterprise', api_attributes_attributes: [{name: 'alert_key', db_type: 'string', api_validations_attributes: [{trait: 'length', advanced_options: '{"min": "32", "max":"50"}'}]}]}])


# from controller: current_user.api_projects.create!(api_projects_params) where it may look like below
# {"name":"sample name","api_resources_attributes":[{"name":"Message","api_attributes_attributes":[{"name":"content","db_type":"text"}]},{"name":"Enterprise","api_attributes_attributes":[{"name":"alert_key","db_type":"string","api_validations_attributes":[{"trait":"length","advanced_options":"{\"min\": \"32\", \"max\":\"50\"}"}]}]}]}
