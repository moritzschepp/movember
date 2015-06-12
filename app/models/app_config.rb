class AppConfig < ActiveRecord::Base

  def self.get(name)
    find_or_initialize_by(name: name).value
  end

  def self.set(name, value, kind = nil)
    config = find_or_initialize_by(name: name)
    config.value = value
    config.kind = kind || value.class.name
    config.save
    config.value
  end

  def value
    case self[:value]
      when Fixnum then self[:value].to_i
      when Float then self[:value].to_f
      when Time then Time.parse(self[:value])
      else
        self[:value]
    end
  end

end