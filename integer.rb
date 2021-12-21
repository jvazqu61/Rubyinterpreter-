# integer class containing an integer value
class MyInteger
  attr_reader :type
  def initialize(value)
    @data = value
    @type = "integer"
  end

  # set the value of the integer
  def set_value(val)
    @data = Integer(val)
  end

  # get the value of the integer
  def get_value

    Integer(@data)
  end

  def to_s
    "#{@data}"
  end
end