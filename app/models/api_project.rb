class ApiProject < ApplicationRecord
  belongs_to :created_by, class_name: 'ApiUser'

  has_many :api_resources, dependent: :destroy, inverse_of: :api_project

  validates_uniqueness_of :name, scope: :created_by_id
  validates_presence_of :name, :created_by

  validates_uniqueness_of :api_host, case_sensitive: true

  accepts_nested_attributes_for :api_resources, reject_if: :all_blank, allow_destroy: true

  after_create :allocate_host
  before_update :do_touch

  def as_json(opts={})
    result = self.attributes.symbolize_keys.except(:created_by_id, :updated_at)

    result[:created_by] = self.created_by.as_json
    result[:api_resources] = self.api_resources.to_a.map{|api_resource| api_resource.as_json }
    result
  end

  def formatted_name
    name.downcase.gsub(' ', '_')
  end

  def allocate_host
    base = 'http://localhost:'
    (3004..5000).each do |port|
      self.api_host = base + port.to_s
      if valid?
        save!
        return
      end
    end
    raise 'Could not find an available PORT'
  end

  def generate_code
    shutdown if launched?
    system "cd #{Rails.root} ; bundle exec rails generate application_template #{formatted_name} api_project=#{id} ; rm ~/projects/#{formatted_name}_template.rb  ; mv application_templates/#{formatted_name}_template.rb ~/projects ; cd ~/projects ; rm -rf #{formatted_name} ; rails _5.0.3_ new #{formatted_name} -T --database=\"postgresql\" --api -m #{formatted_name}_template.rb"
  end

  def launch
    return if launched
    port = api_host.split(':').last
    fork do
      system "cd ~/projects/#{formatted_name} ; bundle exec rails server -p #{port}"
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

  private

  def do_touch
    self.touch
  end

end


# ApiProject.create!(created_by: user, name: 'proj name', api_resources_attributes: [{name: 'Message', api_attributes_attributes: [{name: 'content', db_type: 'text'}]}, {name: 'Enterprise', api_attributes_attributes: [{name: 'alert_key', db_type: 'string', api_validations_attributes: [{trait: 'length', advanced_options: '{"min": "32", "max":"50"}'}]}]}])


# from controller: current_user.api_projects.create!(api_projects_params) where it may look like below
# {"name":"sample name","api_resources_attributes":[{"name":"Message","api_attributes_attributes":[{"name":"content","db_type":"text"}]},{"name":"Enterprise","api_attributes_attributes":[{"name":"alert_key","db_type":"string","api_validations_attributes":[{"trait":"length","advanced_options":"{\"min\": \"32\", \"max\":\"50\"}"}]}]}]}
