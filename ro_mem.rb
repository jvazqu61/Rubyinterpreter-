#a read-only memory that stores an SPL program loaded from the
# input file. Uses a linked list as the "memory"

class Memory
  attr_accessor :memory, :pc
  def initialize
    @memory = LList.new
    @pc = Hash["counter" => 1, "current" => @memory.head] # contains a reference to instruction and number
  end

  # parse each line from the file into tokens
  def parse_line(line)
    tokens = Hash.new
    tokens["keyword"] = line.split[-1]
    tokens["line"] = line.strip
    tokens["params"] = line.split[0...-1]
    tokens
  end

  # add the file into the read-only memory
  def read_file_into_mem(file)
    File.foreach("#{file}") do |line|
      t = parse_line(line)
      @memory.add(t)
    end
    @pc['current'] = @memory.head
  end

  # return contents of the instruction the PC is currently in
  def get_curr_instruction
    if @pc['current'].nil?
      nil
    end
    @pc['current'].data
  end


  # set the PC to another instruction
  def set_pc(i)
    #puts "moving from:#{@pc["counter"]} to:#{i}"
    t = @memory.head
    t1 = 1
    # i-=1
    until t.nil?
      if t1 == i
        @pc["counter"] = t1
        @pc["current"] = t
        return
      end
      t = t.next
      t1+=1
    end
    # puts "not found"
  end

  # update the PC
  def update_pc
    @pc['current'] = @pc['current'].next
    @pc['counter']+=1
  end


  def to_s
    @memory.to_s
  end

end
