extends Label

class_name StopWatchDisplay

const base = "Time Taken: "

# Thanks https://gamedevbeginner.com/how-to-make-a-timer-in-godot-count-up-down-in-minutes-seconds/
func change_display_time(time: float) -> void:
  var minutes: int = int(time / 60)
  var seconds: int = int(fmod(time, 60))
  var millis: int = int(fmod(time, 1) * 100)

  self.text = base + "%02d:%02d.%02d" % [minutes, seconds, millis]