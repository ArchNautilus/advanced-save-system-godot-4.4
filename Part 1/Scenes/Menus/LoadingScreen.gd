extends Control


var progress = []
var sceneName: String
var scene_load_status: int = 0

func _ready() -> void:
	sceneName = GameManager.target_scene
	ResourceLoader.load_threaded_request(sceneName)


func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
