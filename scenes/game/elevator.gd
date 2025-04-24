extends Node2D

class_name Elevator

var left_rooms = [0, 1] # what rooms are on the left
var right_rooms = [2, 3] # what rooms are on the right

var current_floor: int = 0
var dest_floor: int = 0
var min_height = 0
var max_height: int
var elevator_num = 0
var occupancy = []
var max_occupancy = 1
var is_empty = 1 # may be a redundant flag? thought it may be useful for animations

enum STATE {IDLE, LOADING, MOVING}

signal left_door_opened(dest_floor)
signal right_door_opened(dest_floor)

func _ready():
  current_floor = 0
  max_height = max(left_rooms.size(), right_rooms.size()) - 1
  
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
      print("opening left door to room " + str(left_rooms[dest_floor]) + " on elevator " + str(elevator_num))
      left_door_opened.emit(left_rooms[dest_floor])
      
    if Input.is_action_just_pressed("open_right"):
      print("opening right door to room " + str(right_rooms[dest_floor]) + " on elevator " + str(elevator_num))
      right_door_opened.emit(right_rooms[dest_floor])
    
    print("destination floor: %s" % str(dest_floor))
  pass
