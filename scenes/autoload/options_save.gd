extends Node

const SAVE_FILE_PATH = "user://options.save"

var save_data: Dictionary = {
	"sfx_volume": 0.0,
	"music_volume": 0.0,
	"windowed": true
}

func _ready():
	load_settings()

func load_settings():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	
	if save_data != null:
		var options_menu = OptionsMenu.new()
		
		options_menu.set_bus_volume_percent("sfx", save_data["sfx_volume"])
		options_menu.set_bus_volume_percent("music", save_data["music_volume"])
		if not save_data["windowed"]:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif save_data["windowed"]:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func save_settings():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func set_settings(music_volume: float, sfx_volume: float, display_screen: String):
	save_data["sfx_volume"] = sfx_volume
	save_data["music_volume"] = music_volume
	if display_screen == "Windowed":
		save_data["windowed"] = true
	elif display_screen == "Fullscreen":
		save_data["windowed"] = false
		
	save_settings()
