extends Node2D

class_name Passenger

# index of the room this passenger wants to go to
@export var dest_id : int

@export var dest_floor = 1
var happiness = 100

func _to_string() -> String:
  return str(dest_floor)
