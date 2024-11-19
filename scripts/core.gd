extends Node
class_name GameCore

enum GameState
{
	NONE,
	DAY_INTRO,
	GAME,
}

var game_state: GameState = GameState.NONE
@export var item_manager: ItemManager
var game_scene: GameScene

var day_format_string: String

func _ready() -> void:
	game_scene = $"/root/GameScene"
	assert(game_scene != null)
	day_format_string = game_scene.day_text.text
	
	item_manager.initialize()
	
	set_state(GameState.DAY_INTRO)
	
func set_state(state: GameState):
	# exit state
	match game_state:
		GameState.DAY_INTRO:
			pass
		
		GameState.GAME:
			item_manager.set_drag_enabled(false)
			pass
	
	game_state = state
	
	# enter state
	match game_state:
		GameState.DAY_INTRO:
			game_scene.day_text.text = day_format_string.format({"day": 1})
			game_scene.animation_player.animation_finished.connect(day_intro_animation_finished)
			game_scene.animation_player.play("day_intro")
			
			pass
		
		GameState.GAME:
			item_manager.set_drag_enabled(true)
			pass
			
			

func _process(_delta: float):
	match game_state:
		GameState.DAY_INTRO:
			pass
		
		GameState.GAME:
			pass

func day_intro_animation_finished(anim_name: StringName):
	assert(anim_name == "day_intro")
	game_scene.animation_player.animation_finished.disconnect(day_intro_animation_finished)
	set_state(GameState.GAME)
