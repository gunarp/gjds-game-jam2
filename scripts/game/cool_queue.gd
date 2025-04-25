extends Node2D

class_name CoolQueue

# maps position to name of child Passenger node
var internal_array: Dictionary[int, String]

func _init(queue_size: int):
  for i in range(queue_size):
    internal_array[i] = ""


func _ready() -> void:
  pass


func _invert_direction(direction: Elevator.COMMAND) -> Elevator.COMMAND:
  return Elevator.COMMAND.RIGHT if direction == Elevator.COMMAND.LEFT else Elevator.COMMAND.LEFT


# returns first position travelling from the
# incoming direction which satisfies condition
# @param search_direction - order in which the searching wil traverse the positions
# searching left means starting at the right, and going left
# searching right means starting at the left, and going right
func _internal_search(search_direction: Elevator.COMMAND, condition: Callable) -> int:
  var positions = internal_array.keys()
  if (search_direction == Elevator.COMMAND.LEFT):
    positions.reverse()

  var ret_pos: int = -1
  for pos in positions:
    if condition.call(internal_array[pos]):
      ret_pos = pos
      break

  return ret_pos


func _push_search_condition(pname: String) -> bool:
  return pname.is_empty()


func _push_pos(pos: int, p: Passenger) -> void:
  internal_array[pos] = p.name
  add_child(p)


func push_passenger(elevator_direction: Elevator.COMMAND, passenger: Passenger) -> void:
  var open_pos: int = _internal_search(_invert_direction(elevator_direction), _push_search_condition)
  if open_pos == -1:
    print(internal_array, " open_pos = ", open_pos)
    return

  _push_pos(open_pos, passenger)
  print(internal_array, " open_pos = ", open_pos)


func _pop_search_condition(pname: String) -> bool:
  if pname.is_empty():
    return false
  var passenger = find_child(pname, false, false) as Passenger
  return not passenger.arrived


func _pop_pos(pos: int) -> Passenger:
  var pname = internal_array[pos]
  var pnode = find_child(pname, false, false) as Passenger

  internal_array[pos] = ""
  remove_child(pnode)

  return pnode


# shift elements of internal array by one to the left or right, starting at start
# the value at start is overwritten in this process
func _shift(start: int, dir: Elevator.COMMAND) -> void:
  if dir == Elevator.COMMAND.LEFT:
    var modified: bool = false
    for i in range(start, internal_array.size() - 1):
      modified = true
      internal_array[i] = internal_array[i+1]
    if modified:
      internal_array[internal_array.size() - 1] = ""
  else:
    var modified: bool = false
    for i in range(start, 0, -1):
      modified = true
      internal_array[i] = internal_array[i-1]
    if modified:
      internal_array[0] = ""


func pop_passenger(elevator_direction: Elevator.COMMAND) -> Passenger:
  var pop_pos: int = _internal_search(elevator_direction, _pop_search_condition)
  if pop_pos == -1:
    print(internal_array, " pop_pos = ", pop_pos)
    return null

  var passenger_node = _pop_pos(pop_pos)
  print(internal_array, " pop_pos = ", pop_pos)

  # If we popped the head of the queue, we'd want to shift the rest of
  # the elements in the same direction we popped
  _shift(pop_pos, _invert_direction(elevator_direction))

  return passenger_node


func is_full() -> bool:
  for key in internal_array:
    if internal_array[key].is_empty():
      return false
  return true


func get_size() -> int:
  return internal_array.size()


# Called to render the room state (passengers inside the room)
func get_passengers() -> Dictionary[int, Passenger]:
  var ret: Dictionary[int, Passenger] = {} as Dictionary[int, Passenger]
  for pos in internal_array.keys():
    if internal_array[pos] != "":
      ret[pos] = find_child(internal_array[pos], false, false)
    else:
      ret[pos] = null

  return ret
