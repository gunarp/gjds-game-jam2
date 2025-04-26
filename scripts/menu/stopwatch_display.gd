extends Label

class_name StopWatchDisplay

const base = "Time Taken: "

func change_display_time(time: String) -> void:
  self.text = base + time