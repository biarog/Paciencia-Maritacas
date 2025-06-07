extends Control

var movimento : Movimento_Jogo 
@onready var controle_deck := $"Controle Deck"
@onready var controle_casas := $"Controle Casas"
@onready var controle_jogo := $"Controle Jogo"

var pilha_movimentos : Pilha

func _ready() -> void:
	# Criar o nó de movimento específico desse jogo
	movimento = Movimento_Jogo.novo_movimento_jogo($"Camada Drag")
	self.add_child(movimento)
	controle_jogo.movimento = movimento
	controle_deck.movimento = movimento
	controle_casas.movimento = movimento
	controle_jogo.inicia_jogo()
	controle_casas.inicia_casas()
	controle_deck.inicia_deck()
	
	movimento.moveuCarta.connect(salvar_movimento)
	
	pilha_movimentos = Pilha.new()



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()


# Funções relacionadas a pausar

func _pause_game():
	$MenuPausa.visible = true
	get_tree().paused = true

func _unpause_game():
	$MenuPausa.visible = false
	get_tree().paused = false

func _on_continue_pressed() -> void:
	_unpause_game()

func _on_retornar_menu_inicial_pressed() -> void:
	_unpause_game()
	get_tree().change_scene_to_file("res://cenas/menu_inicial.tscn")

func _on_recomecar_pressed() -> void:
	_unpause_game()
	get_tree().change_scene_to_file("res://cenas/mesa_paciencia.tscn")


# Funções relacionadas a pilha de movimentos

func salvar_movimento(carta_movida:Carta, container_og:Control, container_alvo:Control) -> void:
	var no_novo:No_Pilha = No_Pilha.new(carta_movida, container_og, container_alvo)
	pilha_movimentos.push(no_novo)

func voltar_movimento() -> void:
	if pilha_movimentos.is_empty():
		return
	
	var movimento:No_Pilha = pilha_movimentos.pop()
	
	
