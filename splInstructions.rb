# abstract superclass for SPL instructions with concrete
# subclasses for each particular instruction.

class SplInst
  #identifier NEWID-> This statement declares a new identifier, which can be used in
  # subsequent statements. The identifier is initialized with the null value
  # (i.e., an empty list)
  def new_id
  end

  # id list COMBINE-> The value bound to id is appended to the list bound to list.
  # The value bound to id (i.e., an integer or a list) becomes the first element of the list
  # bound to list. If id is bound to a list l1, l1 will become the first element of list
  def combine
  end

  #: list1 list2 COPY-> The list bound to list1 is deep-copied and bound to identifier list2.
  def list_copy
  end

  #: identifier1 identifier2 HEAD-> The first element of the list bound to identifier1 is
  # bound to identifier2. This list is not modified
  def list_head
  end

  #: identifier1 identifier2 TAIL-> A list containing all elements but the first of identifier1
  # is bound to identifier2. The list is not copied.
  def list_tail
  end

  #: identifier integer ASSIGN-> This statement assigns (binds) an integer constant to
  # identifier.
  def assign_int
  end

  #: identifier CHS-> This statement changes the sign of the integer value bound to identifier.
  def chs
  end

  #: identifier1 identifier2 ADD-> This statement adds the integers bound to the two arguments
  # and stores the result in identifier1.
  def add_int
  end

  #: identifier1 positive int IF-> If identifier1 is an empty list or the number zero, jump to
  # instruction at line positive int
  def if_jump
  end

  #: HLT-> Terminates program execution.
  def hlt
  end
end
