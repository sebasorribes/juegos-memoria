extends Node

var creditsPanel : Control;
var buttonsPanel : Control;

func _ready() -> void:
	creditsPanel = get_node("CreditsPanel");
	buttonsPanel = get_node("Mainbuttons");
	creditsPanel.hide();
	buttonsPanel.show();

func _on_match_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Match/match_game.tscn");

func _on_paisajes_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Landscape/landscape_game.tscn");

func _on_compras_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Compras/compras_game.tscn");


func _on_credits_button_pressed() -> void:
	buttonsPanel.hide();
	creditsPanel.show();

func _on_exit_credits_pressed() -> void:
	creditsPanel.hide();
	buttonsPanel.show();
