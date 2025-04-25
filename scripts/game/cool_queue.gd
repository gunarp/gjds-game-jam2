extends Node2D

class_name CoolQueue

# maps position to name of child Passenger node
var internal_array: Dictionary[int, String]

func _init():
  internal_array = {
    0: "",
    1: "",
    2: "",
  }


func _ready() -> void:
  pass


func _invert_direction(direction: Elevator.COMMAND) -> Elevator.COMMAND:
  return Elevator.COMMAND.RIGHT if direction == Elevator.COMMAND.LEFT else Elevator.COMMAND.LEFT


# returns first position travelling from the
# incoming direction which satisfies condition
func _internal_search(incoming_direction: Elevator.COMMAND, condition: Callable) -> int:
  var positions = internal_array.keys()
  if (incoming_direction == Elevator.COMMAND.RIGHT):
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


func push_passenger(incoming_direction: Elevator.COMMAND, passenger: Passenger) -> void:
  var open_pos: int = _internal_search(_invert_direction(incoming_direction), _push_search_condition)
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

func pop_passenger(incoming_direction: Elevator.COMMAND) -> Passenger:
  var pop_pos: int = _internal_search(incoming_direction, _pop_search_condition)
  if pop_pos == -1:
    print(internal_array, " pop_pos = ", pop_pos)
    return null

  var passenger_node = _pop_pos(pop_pos)
  print(internal_array, " pop_pos = ", pop_pos)
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
  return internal_array.duplicate()
