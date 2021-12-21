# Author: Juan Vazquez
# Last modified: 3-17-21
# SPL interpreter -> Simple Programming Language Interpreter that has a set of instructions.
#                    SPL has just two data structures, integer numbers and linked lists. Linked
#                    list elements can be integers or linked lists themselves. Identifiers must be
#                    declared before they are used, but are not typed
#
require './list.rb'
require './ro_mem.rb'
require './SPLInst.rb'


# SPL class
# contains 2 memories, a read-only memory that stores an SPL program loaded from the input file,
# and a memory holding identifiers declared in the program and the values bound to each identifier.
# the SPL Interpreter keeps a program counter (PC) holding the index position of the statement being currently executed
class SPL
  def initialize
    @d_ram = Memory.new # ro_memory
    @identifiers = Hash.new # identifiers memory
    @instruction_count = 0
  end

  # print the identifiers memory with the current PC
  def print_mem
    puts("\nPC:#{@d_ram.pc['counter']} => #{@d_ram.get_curr_instruction['line']}\nmemory:\n")
    s = ""
    @identifiers.map do |k, v|
      puts("#{k}: #{v.nil? ? "nil" : "#{v}"}")
    end
    puts""
  end

  # runs a single instruction read from the d_ram (read only memory)
  def run_instruction
      inst = @d_ram.get_curr_instruction # instruction to be executed

      case inst["keyword"] #match the instruction keyword
      when 'NEWID'
        NewId.new_id(inst["params"][0],@identifiers)
      when 'COMBINE'
        Combine.combine_(@identifiers,inst["params"])
      when 'COPY'
        Copy.list_copy(@identifiers,inst["params"])
      when 'HEAD'
        Head.list_head(@identifiers,inst["params"])
      when 'TAIL'
        Tail.list_tail(@identifiers,inst["params"])
      when 'ASSIGN'
        Assign.assign_int(@identifiers,inst["params"])
      when 'CHS'
        CHS.chs(@identifiers,inst["params"])
      when 'ADD'
        Add.add_int(@identifiers,inst["params"])
      when 'IF'
        Jump.if_jump(@identifiers,inst["params"],@d_ram)
      when 'HLT'
        print_mem
        puts "Finished executing the spl program!"
        exit(1)
      else
        puts "unknown instruction!"
        exit(-1)
      end
      @d_ram.update_pc

  end


# run the user commands
  def user_program
    #prompt user for file name
    print "Enter a filename to execute: "
    file_name = gets.chomp

    @d_ram.read_file_into_mem file_name #read the contents of the file to memory

    # prompt the user for a command
    while true
      puts "l: Executes a line of code\na: Executes all the instructions until a halt instruction\nq: quits program"
      print "Enter a command: "
      user_command = gets.chomp
      case user_command
        # l– Executes a line of code, starting from line 0, updates the PC, and the memory according to the instruction and prints the values of memory, the PC after the line is executed.
      when 'l'
        run_instruction
        print_mem_
        @instruction_count+=1

        # a – Executes all the instructions until a halt instruction is encountered or there are no more instructions to be executed. The values of the PC and the data memory are printed.
      when 'a'
         until @d_ram.nil?
           run_instruction
           @instruction_count+=1
         end
         # quits the program
      when 'q'
        puts "Exiting..."
        exit(1)
      else
        puts "wrong command. Try again"
        next
      end
      if @instruction_count > 1000
        puts "Infinite Loop"
        exit(-1)
      end
      end
    end
end

r = SPL.new
r.user_program





