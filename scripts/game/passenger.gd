extends Node2D

class_name Passenger

@export var dest_floor = 1
var happiness = 100

func _to_string() -> String:
  return str(dest_floor)
