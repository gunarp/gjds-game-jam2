extends Node2D

class_name Passenger

# id of the room this passenger wants to go to
@export var dest_id : int
var style: int
# update to true when the passenger arrives at their destined room
var arrived: bool = false

var happiness = 100
# index of dest_floor = corresponding sprite frame
var translation_arr = [2, 1, 0, 5, 4, 3, 8, 7, 6]

func _to_string() -> String:
  return "dest room: " + str(dest_id)

func _init(dest_room: int, sprite_style: int):
  print(dest_room)
  print(sprite_style)
  print("poggers passenger exists!")
  dest_id = dest_room
  # TODO: generate Sprite2D for specific style
  # TODO: set Sprite2D "frame" with translation_arr
  # TODO: generate Sprite2D for happy bubble
  pass

func change_dest(dest: Vector2):
  dest = dest
  # based on distance away, change speed


func _process(delta: float):
  # cancel tween, create a new one

  # proposed animation flow
  # if we're supposed to move
  # we have our own position
  # if position!= dest:
  #   travel x units towards dest

  pass
