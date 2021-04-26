extends CanvasLayer

onready var scorelabel = $Gameplay/ScoreLabel
onready var player = get_node("/root/Main/Path2D/Player")
onready var admob = get_parent().get_node("AdMob")
onready var gameservices = get_parent().get_node("GooglePlayServices")
onready var shareservices = get_parent().get_node("ShareService")

onready var start_gui = $StartMenu
onready var gameover_gui = $GameOverMenu
onready var gameplay_gui = $Gameplay
onready var pause_gui = $PauseMenu
onready var options_gui = $OptionsMenu
onready var newrecord_gui = $NewRecordMenu

signal restart
signal gui_changed

var share = null

onready var GUINodes ={
	0:gameplay_gui,
	1:gameover_gui,
	2:pause_gui,
	3:options_gui,
	4:start_gui,
	5:newrecord_gui
}

var actualShowingNode = null

func _ready():
	yield(get_tree(), "idle_frame")
	connect("gui_changed", self, "verifyAd")
	gameservices.sign_in()
	admob.load_banner()
	admob.move_banner(false)
	start_gui.get_node("VBoxContainer/ScoreLabel").text = "\nBest Distance: "+str(GLOBAL.max_score)+"m\n"
	options_gui.get_node("VBoxContainer/CenterContainer/CheckButton").pressed = GLOBAL.sound
	showGUINode(4)

func _process(_delta):
	scorelabel.text = "\nDISTANCE\n"+str(player.score)+"m"
	get_tree().paused = (!gameplay_gui.visible)# and !gameover_gui.visible)
	
	if Input.is_action_just_pressed("pause") and !player.dead:
		calculeScore()
		showGUINode(2)
	
func verifyAd():
	GLOBAL.showAds = (start_gui.visible or pause_gui.visible or gameover_gui.visible)
	if GLOBAL.showAds:
		admob.show_banner()
	else:
		admob.hide_banner()

func calculeScore():
	if GLOBAL.max_score <= player.score:
		gameover_gui.get_node("VBoxContainer/ScoreLabel").text = "\nNEW RECORD!"+"\nBest Distance: "+str(player.score)+"m\n"
		gameservices.submit_leaderboard_score(player.score)
		gameover_gui.get_node("VBoxContainer/ShareButton").show()
		pause_gui.get_node("VBoxContainer/ScoreLabel").text = "\nNEW RECORD!"+"\nBest Distance: "+str(player.score)+"m\n"
		GLOBAL.max_score = player.score
	else:
		gameover_gui.get_node("VBoxContainer/ScoreLabel").text = "\nDistance: "+str(player.score)+"m\nBest Distance: "+str(GLOBAL.max_score)+"m\n"
		gameover_gui.get_node("VBoxContainer/ShareButton").hide()
		pause_gui.get_node("VBoxContainer/ScoreLabel").text = "\nDistance: "+str(player.score)+"m\nBest Distance: "+str(GLOBAL.max_score)+"m\n"
		


func _notification(what):
	if what == MainLoop.NOTIFICATION_APP_PAUSED or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST or what == MainLoop.NOTIFICATION_WM_FOCUS_OUT and !player.dead:
		calculeScore()
		TOOLS.saveData()
		if GLOBAL.started:
			if !get_tree().paused:
				showGUINode(2)
			else:
				showGUINode(0)
				
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		gameservices.sign_out()
		TOOLS.exitGame()

func _on_RetryButton_pressed():
	emit_signal("restart")
	

func _on_CheckButton_toggled(button_pressed):
	GLOBAL.sound = button_pressed


func showGUINode(id):
	for i in range(GUINodes.size()):
		if GUINodes[i] != GUINodes[id]:
			GUINodes[i].hide()
	GUINodes[id].show()
	actualShowingNode = GUINodes[id]
	emit_signal("gui_changed")
	


func _on_ResumeButton_pressed():
	showGUINode(0)


func _on_OptionsButton_pressed():
	showGUINode(3)


func _on_BackButton_pressed():
	if GLOBAL.started:
		showGUINode(2)
	else:
		showGUINode(4)
	TOOLS.saveData()


func _on_StartButton_pressed():
	GLOBAL.started = true
	showGUINode(0)
	

func _on_MainMenuButton_pressed():
	get_parent().restart_game()
	GLOBAL.started = false
	start_gui.get_node("VBoxContainer/ScoreLabel").text = "\nBest Distance: "+str(GLOBAL.max_score)+"m\n"
	showGUINode(4)
	


func _on_ExitButton_pressed():
	gameservices.sign_out()
	TOOLS.exitGame()



func _on_LeaderboardButton_pressed():
	gameservices.show_leaderboard()


#func shareScreenshot():
	
	#shareservices.takeScreenshot()
	#shareservices.shareImage()


func _on_ShareButton_pressed():
	newrecord_gui.get_node("VBoxContainer/ScoreLabel").text = "\nDistance: "+str(GLOBAL.max_score)+"m\n"
	showGUINode(5)
	shareservices.takeScreenshot()
	
