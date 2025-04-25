extends Node

class_name CoolQueue

var internal_array: Dictionary[int, Passenger]

func _init():
  internal_array = {
    0: null,
    1: null,
    2: null
  }


func push_passenger(passenger: Passenger, incoming_direction) -> void:
  pass


func pop_passenger(passenger: Passenger, incoming_direction) -> Passenger:
  return null


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