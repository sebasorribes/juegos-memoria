class_name Landscape_Game;
extends Node2D

var landscapes =[
    preload("res://Sprites/Paisajes/Alemania_vinedo.jpg"),
    preload("res://Sprites/Paisajes/Alpes_prado.jpg"),
    preload("res://Sprites/Paisajes/Austria_Gazebo_pabellon.jpg"),
    preload("res://Sprites/Paisajes/Bosque_naturaleza_arboles.jpg"),
    preload("res://Sprites/Paisajes/Cabana_con_techo_de_paja.jpg"),
    preload("res://Sprites/Paisajes/Cascada_rio_otono.jpg"),
    preload("res://Sprites/Paisajes/Ciudad_mar_edificios.jpg"),
    preload("res://Sprites/Paisajes/Delta_del_Okavango.jpg"),
    preload("res://Sprites/Paisajes/Desierto_Sahara_dunas.jpg"),
    preload("res://Sprites/Paisajes/Escocia_faro_paisaje.jpg"),
    preload("res://Sprites/Paisajes/Ferrocarril.jpg"),
    preload("res://Sprites/Paisajes/Hielo_lago.jpg"),
    preload("res://Sprites/Paisajes/Montanas_con_nieve.jpg"),
    preload("res://Sprites/Paisajes/Muelle.jpg"),
    preload("res://Sprites/Paisajes/Terrazas_campos.jpg"),
    preload("res://Sprites/Paisajes/Torre_Eiffel.jpg") ]


var card := preload("res://Scenes/Landscape/landscape_card.tscn");
var ListLandscapes := [];
var cardShowed : Landscape_Card;

var instructionTurn := 0;
var gameTurn := 0;

var points := 0;

var instructionPanel : Control;
var gamePanel : Control;
var endGamePanel : Control;
var pointsText : Label;

var yesButton : Button;
var noButton : Button;

func _ready() -> void:
    instructionTurn = 0;
    gameTurn = 0;
    cardShowed = null;
    
    points = 0;
    
    instructionPanel = get_node("Transform/Control/ColorRect/instructionsPanel");
    gamePanel = get_node("Transform/Control/ColorRect/GamePanel");
    endGamePanel = get_node("Transform/Control/ColorRect/EndGame")
    pointsText = get_node("Transform/Control/ColorRect/EndGame/Label");
    
    instructionPanel.show();
    gamePanel.hide();
    endGamePanel.hide();
    
    yesButton = get_node("Transform/Control/ColorRect/GamePanel/YesButton");
    noButton = get_node("Transform/Control/ColorRect/GamePanel/NoButton");
    BuildList();

func BuildList() -> void:
    var counter := 0;
    while (counter < 8):
        var auxLandscape = landscapes.pick_random();
        if(!ListLandscapes.has(auxLandscape)):
            ListLandscapes.append(auxLandscape);
            counter += 1;
    ListLandscapes.shuffle();

func BuildCard(texture : Texture2D) -> void:
    if(cardShowed != null):
        cardShowed.queue_free();
    cardShowed = card.instantiate();
    get_node("Transform").add_child(cardShowed);
    (cardShowed as Landscape_Card).SetUp(texture);
    cardShowed.position = Vector2(340, 640);


func _on_next_button_pressed() -> void:
    InstructionMenu();

func InstructionMenu():
    if(instructionTurn < 8):
        BuildCard(ListLandscapes[instructionTurn])
        instructionTurn += 1;
    elif (instructionTurn == 8):
        cardShowed.queue_free();
        instructionPanel.get_child(0).hide();
        instructionPanel.get_child(1).show();
        instructionTurn += 1;
    else:
        StartPlay();
        
func StartPlay() -> void:
    instructionPanel.hide();
    gamePanel.show();
    BuildCard(landscapes[gameTurn]);
    yesButton.pressed.connect(Selection.bind(true));
    noButton.pressed.connect(Selection.bind(false));
    

func IsInList() -> bool:
    var textureCard = cardShowed.sprite.texture;
    return ListLandscapes.has(textureCard);

func Selection(decision : bool) -> void:
    if(IsInList() == decision):
        points +=1;
    nextTurn();

func nextTurn() -> void:
    gameTurn += 1;
    if(gameTurn < 16):
        BuildCard(landscapes[gameTurn]);
    else:
        EndGame();

func EndGame() -> void:
    cardShowed.queue_free();
    gamePanel.hide();
    pointsText.text = "Aciertos: " + str(points) + " / 16";
    endGamePanel.show();


func _on_end_game_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/main_menu.tscn");
