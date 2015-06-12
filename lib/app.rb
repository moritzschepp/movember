class App

  def self.fake_over!
    @over = true
  end
  
  def self.release_fake_over!
    @over = false
  end
  
  def self.config
    @config = nil if Rails.env != 'production'
  
    @config ||= begin
      file = "#{Rails.root}/config/app.defaults.yml"
      result = YAML.load_file(file)
      
      file = "#{Rails.root}/config/app.yml"
      result.merge(File.exists?(file) ? YAML.load_file(file) : {})
    end
  end
  
  def self.count
    over? ? config['real_count'].to_i : Vote.where(:state => 'voted').count
  end
  
  def self.started?
    Time.parse(config['starts_at']) < Time.now
  end
  
  def self.over?
    @over || (Time.parse(config['ends_at']) < Time.now)
  end
  
  def self.active?
    started? && !over?
  end
  
end
