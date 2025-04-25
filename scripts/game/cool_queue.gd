extends Node2D

class_name CoolQueue

var internal_array: Dictionary[int, Passenger]

func _init():
  internal_array = {
    0: null,
    1: null,
    2: null
  }


func _ready() -> void:
  pass


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


func _push_search_condition(p: Passenger) -> bool:
  return p == null


func push_passenger(incoming_direction: Elevator.COMMAND, passenger: Passenger) -> void:
  var open_pos: int = _internal_search(incoming_direction, _push_search_condition)
  if open_pos == -1:
    return

  internal_array[open_pos] = passenger
  add_child(passenger)


func _pop_search_condition(p: Passenger) -> bool:
  if p == null:
    return false
  return not p.arrived


func pop_passenger(incoming_direction: Elevator.COMMAND) -> Passenger:
  var pop_pos: int = _internal_search(incoming_direction, _pop_search_condition)
  if pop_pos == -1:
    return null

  var passenger_ref: Passenger = internal_array[pop_pos]
  remove_child(passenger_ref)
  return passenger_ref


func is_full() -> bool:
  for key in internal_array:
    if internal_array[key] == null:
      return false
  return true


func get_size() -> int:
  return internal_array.size()


# Called to render the room state (passengers inside the room)
func get_passengers() -> Dictionary[int, Passenger]:
  return internal_array.duplicate()