extends Node2D

class_name Passenger

# id of the room this passenger wants to go to
@export var dest_id : int
var style: int
# update to true when the passenger arrives at their destined room
var arrived: bool = false

var happiness = 100
# index of dest_floor = corresponding sprite frame
var sprite_translation_arr = [2, 1, 0, 5, 4, 3, 8, 7, 6]
# [x, y]
var bubble_offset_arr = [[-3,-15], [-3,-14], [-1,-16], [-2,-18], [-2,-17], [-2,-16]]


func _to_string() -> String:
  return "dest room: " + str(dest_id)


const passenger_scene: PackedScene = preload("uid://o2weteelt0wc")
static func new_passenger(dest_room: int, sprite_style: int) -> Passenger:
  var passenger: Passenger = passenger_scene.instantiate()
  passenger.dest_id = dest_room
  passenger.style = sprite_style
  passenger.name = "passenger_" + str(passenger.get_instance_id())

  return passenger


func _ready() -> void:
  var sprite_count = style * 9 + sprite_translation_arr[dest_id]
  var bubble_offset_vector = Vector2(bubble_offset_arr[style][0], bubble_offset_arr[style][1])
  # print(self.get_instance_id(), " ready children: ", get_children(true))
  # print()
  $Sprite.set_frame(sprite_count)
  $HappyBubble.translate(bubble_offset_vector)


func get_y_offset() -> float:
  return $Sprite.get_rect().size.y / 2.0


func change_dest(dest: Vector2):
  dest = dest
  # based on distance away, change speed


func display_happy_bubble():
  $HappyBubble.set_visible(true)
  $HappyBubble.play()


func _process(_delta: float):
  # cancel tween, create a new one

  # proposed animation flow
  # if we're supposed to move
  # we have our own position
  # if position!= dest:
  #   travel x units towards dest

  pass
