extends Node2D

class_name Passenger

# id of the room this passenger wants to go to
@export var dest_id : int
# update to true when the passenger arrives at their destined room
var arrived: bool = false

var happiness = 100

# func _to_string() -> String:
#   return str(dest_id)


func change_dest(dest: Vector2):
  dest = dest
  # based on distance away, change speed


func _process(_delta: float):
  # cancel tween, create a new one

  # proposed animation flow
  # if we're supposed to move
  # we have our own position
  # if position!= dest:
  #   travel x units towards dest

  pass