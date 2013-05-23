# -*- encoding: utf-8 -*-

class Version
  VERSION_NAME_REGEXP = /^JDK(\d*)u(\d*)$/

  def initialize(name)
    @name = name
  end

  def self.valid?(name)
    !!(VERSION_NAME_REGEXP =~ name)
  end

  def self.parse(name)
    return raise unless self.valid?(name)
    Version.new(name)
  end

  def family_number
    return $1.to_i if VERSION_NAME_REGEXP =~ @name
  end

  def update_number
    return $2.to_i if VERSION_NAME_REGEXP  =~ @name
  end

  def lt(version)
    return self.update_number < version.update_number if self.family_number == version.family_number
    self.family_number < version.family_number
  end

  def gt(version)
    return self.update_number > version.update_number if self.family_number == version.family_number
    self.family_number > version.family_number
  end
end
