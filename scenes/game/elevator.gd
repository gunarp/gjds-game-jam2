extends Node2D

var current_floor: int = 0
var dest_floor: int = 0
var min_height = 0
var max_height: int = 2
var elevator_num = 0

signal left_door_opened(dest_floor)
signal right_door_opened(dest_floor)

func _ready():
  current_floor = 0
  
func _process(_delta: float):
  if Input.is_anything_pressed():
    if Input.is_action_just_pressed("down_floor"):
      print("destination floor - 1")
      if (dest_floor - 1) >= min_height:
        dest_floor -= 1
      else:
        print("you are already traveling to min floor")
      
    if Input.is_action_just_pressed("up_floor"):
      print("destination floor + 1")
      if (dest_floor + 1) <= max_height:
        dest_floor += 1
      else:
        print("you are already traveling to the max floor")
      
    if Input.is_action_just_pressed("confirm_floor"):
      if (dest_floor != current_floor):
        print("traveling to floor %s" % str(dest_floor))
      else:
        print("you are already on floor %s!" % str(dest_floor))
      
    if Input.is_action_just_pressed("open_left"):
      print("opening left door on elevator %s" % str(elevator_num))
      left_door_opened.emit(dest_floor)
      
    if Input.is_action_just_pressed("open_right"):
      print("opening right door on elevator %s" % str(elevator_num))
      right_door_opened.emit(dest_floor)
    
    print("destination floor: %s" % str(dest_floor))
  pass
