class Version
  include Comparable
  attr_reader :family_number, :update_number
  VERSION_NAME_REGEXP = /^JDK(\d*)u(\d*)$/

  def initialize(family_number, update_number)
    @family_number = family_number.to_i
    @update_number = update_number.to_i
  end

  def self.valid?(name)
    !!(VERSION_NAME_REGEXP =~ name)
  end

  def self.parse(name)
    return raise unless self.valid?(name)
    family_number, update_number = name.scan(VERSION_NAME_REGEXP).first
    Version.new(family_number, update_number)
  end

  def lt(other)
    self < other
  end

  def gt(other)
    self > other
  end

  def <=>(other)
    return self.update_number <=> other.update_number if self.family_number == other.family_number
    self.family_number <=> other.family_number
  end

  def next_limited_update
    next_update_number = @update_number + (20 - @update_number % 20)
    Version.new(@family_number, next_update_number)
  end

  def next_critical_patch_update
    next_update_number = @update_number + (5 - @update_number % 5)
    next_update_number += 1 if next_update_number % 2 == 0
    Version.new(@family_number, next_update_number)
  end

  def next_security_alert
    next_update_number = @update_number + 1
    Version.new(@family_number, next_update_number)
  end
end
