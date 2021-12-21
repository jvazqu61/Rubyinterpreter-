require './splInstructions.rb'
require './integer'

#sub classes for the abstract SPLInst class

#:identifier NEWID-> This statement declares a new identifier, which can be used in
# subsequent statements. The identifier is initialized with the null value
# (i.e., an empty list)
class NewId < SplInst

  def NewId.new_id(identifier, hash)
    hash[identifier] = nil
  end
end



# assigns an int to an identifier
class Assign < SplInst
  # identifier integer ASSIGN-> This statement assigns (binds) an integer constant to
  # identifier.
  def Assign.assign_int(identifier_mem, params)
    #create an integer with the value set using second parameter
    identifier_mem[params[0]] = MyInteger.new(params[1])
  end
end

# identifier1 identifier2 ADD-> This statement adds the integers bound to the two arguments
# and stores the result in identifier1.
# **** Assuming both identifiers are of type integer
class Add < SplInst

  def Add.add_int(identifier_mem, params)

    # check that both identifiers are integers
    if !identifier_mem[params[0]].nil? and !identifier_mem[params[1]].nil?
      if identifier_mem[params[0]].type == "integer" and identifier_mem[params[1]].type == "integer"

        i1 = identifier_mem[params[0]]
        i2 = identifier_mem[params[1]]
        # add both values and store results in identifier 1
        identifier_mem[params[0]].set_value(i1.get_value + i2.get_value)
      end

    end
  end
end

# id list COMBINE-> The value bound to id is appended to the list bound to list.
# The value bound to id (i.e., an integer or a list) becomes the first element of the list
# bound to list. If id is bound to a list l1, l1 will become the first element of list
class Combine < SplInst

  def Combine.combine_(identifier_mem,params)
    id = identifier_mem[params[0]]
    list = identifier_mem[params[1]]
    # check that second arg is an nil or list
    if !list.nil?

      # if list is an integer, run time error
      if  list.type == "integer"
        puts("Error -> second arg must be a list or nil")
        exit(-1)

      elsif list.type == "list"
        if id.type == "integer"
          id2 = MyInteger.new(id.get_value)
          list.prepend(id2)
        else
          list.prepend(id) #prepend the value of id
        end

      end

    else # identifier is bound to nil, create a new linked list
      identifier_mem[params[1]] = LList.new # create a new list
      identifier_mem[params[1]].prepend(id)

      end
    end
end


# list1 list2 COPY-> The list bound to list1 is deep-copied and bound to identifier list2.
class Copy < SplInst

  def Copy.list_copy(identifier_mem, params)

    identifier_mem[params[1]] = LList.new
    unless identifier_mem[params[0]].nil?
      t = identifier_mem[params[0]].head
      # make deep copies of all nodes in list 1 and add to list 2
      until t.nil?
        if t.data.type == "list"
          l = t.data.clone
          identifier_mem[params[1]].add(l)
        elsif t.data.type == "integer"
          i = MyInteger.new(t.data.get_value)
          identifier_mem[params[1]].add(i)
        end
        t = t.next
      end
    end
  end
end


# identifier1 identifier2 HEAD-> The first element of the list bound to identifier1 is
# bound to identifier2. This list is not modified
class Head < SplInst

  def Head.list_head(identifier_mem, params)
    # check if head is an integer or another list
    if !identifier_mem[params[0]].nil?
      # check if list is actually a list, if an integer is passed: runtime error
      if identifier_mem[params[0]].type == "integer"
        puts("Error -> first arg must be a list or nil")
        exit(-1)

      elsif identifier_mem[params[0]].type == "list"
        val = identifier_mem[params[0]]
         if !identifier_mem[params[1]].nil? and !identifier_mem[params[0]].head.nil?
          if identifier_mem[params[1]].type == "integer" and identifier_mem[params[0]].head.data.type=="integer"
            identifier_mem[params[1]].set_value(val.head.data.get_value)
          end
        else
          if val.head.nil?
            identifier_mem[params[1]] = nil
          else
            identifier_mem[params[1]] = val.head.data
          end

        end

      end

    else # empty list, identifier 2 also bound to nil
      identifier_mem[params[1]] = nil
    end
  end
end


# identifier1 identifier2 TAIL-> A list containing all elements but the first of identifier1
# is bound to identifier2. The list is not copied.
class Tail < SplInst


  def Tail.list_tail(identifier_mem, params)

    # check that identifier 1 is a list
    if !identifier_mem[params[0]].nil?

      #runtime error if not a list
      if identifier_mem[params[0]].type == "integer"
        puts("Error -> second arg must be a list or nil")
        exit(-1)

        # set the 'tail' node to be bound to identifier 2
      elsif identifier_mem[params[0]].type == "list"
        identifier_mem[params[1]] = LList.new
        identifier_mem[params[1]].head = identifier_mem[params[0]].tail

        unless identifier_mem[params[1]].head.nil?
          identifier_mem[params[1]].tail = identifier_mem[params[1]].head.next
        end
      end

    else #identifier for list 1 is bound to empty list nil
      identifier_mem[params[1]] = LList.new
    end
  end
end


#identifier CHS-> This statement changes the sign of the integer value bound to identifier.
class CHS
  def CHS.chs(identifier_mem, params)

    # make sure identifier is not a list
    if identifier_mem[params[0]].type == "list"
      puts "Error -> identifier should be of type Integer"
      exit(-1)
    end
    # set the sign of the value
    val = identifier_mem[params[0]].get_value
    identifier_mem[params[0]].set_value(Integer(val)*-1)
  end
end


# identifier1 positive int IF-> If identifier1 is an empty list or the number zero, jump to
# instruction at line positive int
# **** Assuming that the instruction the user asks for is in range 1-> last instruction
class Jump < SplInst


  def Jump.if_jump(identifier_mem, params, mem)
    # check if list is empty or integer value is bound to 0
    # puts "if: #{identifier_mem[params[0]].type}, #{identifier_mem[params[0]]}"
    if !identifier_mem[params[0]].nil?

      if identifier_mem[params[0]].type == "list"
        if identifier_mem[params[0]].head.nil?
          mem.set_pc(Integer(params[1]))
        end

      elsif identifier_mem[params[0]].type == "integer" and identifier_mem[params[0]].get_value == 0
        mem.set_pc(Integer(params[1]))
      end
    elsif identifier_mem[params[0]].nil?
      mem.set_pc(Integer(params[1]))

    end
  end

end

