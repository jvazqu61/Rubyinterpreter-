# Node class
# node with data and pointer to next node
class Node
  attr_accessor :data, :next
  def initialize(x)
    @data = x
    @next = nil
  end
end
