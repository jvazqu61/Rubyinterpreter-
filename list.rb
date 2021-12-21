require './node.rb'

# Linked List class
class LList
  attr_accessor :head, :tail, :size, :type, :last
  # init with value
  def LList.New(x)
    temp = LList.new
    temp.add x
    temp
  end

  def initialize
    @head = nil # head of list(first node)
    @last = nil # end of list(last node in list)
    @tail = nil # tail of list(list not including first node)
    @size = 0
    @type = "list"
  end

  # add -> appends a new node to the end of the list
  def add(x)
    new_node = Node.new x
    if @head.nil?
      @head = new_node
      @last = new_node
    else
      @last.next = new_node
      @last = new_node

    end
    unless @head.next.nil?
      @tail = @head.next
    end

    @size += 1
    1
  end

  def prepend(x)
    new_node = Node.new x
    if @head.nil?
      @head = new_node
      @last = new_node
    else
      new_node.next = @head
      @head = new_node
    end
    unless @head.next.nil?
      @tail = @head.next
    end

    @size += 1
  end


  # searches for data 'x' in the list
  # if found, returns data, 0 when not found
  def find (x)
    t = @head
    while t != nil
      if t.data == x
        return t.data
      end
      t = t.next
    end
    0
  end

  # recursively makes a deep copy of the link list
  def deep_copy (head, copy)
    if head.nil?
      return nil
    end
    n = Node.new(head.data)
    copy.last = n
    n.next = deep_copy(head.next,copy)
    n
  end


  # deeply clone the entire link list
  def clone
    copy = LList.new
    copy.size = @size
    copy.head = deep_copy(@head, copy)
    copy.tail = copy.head.next
    copy
  end

  # print out all nodes on list
  def to_s
    s = ""
    t = @head
    until t.nil?
      if t.data.type == "integer"
        s+=String(t.data)
      elsif t.data.type == "list"
        s+= t.data.to_s
      end
      unless t.next.nil?
        s += " "
      end
      t = t.next
    end
    "[#{s}]"
  end
end
