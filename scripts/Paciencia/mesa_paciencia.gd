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

func _process(delta):
	movimento.processamento_movimento(delta)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			movimento.mouse_esq_press()
		else:
			movimento.mouse_esq_solta()


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
	var carta_m = movimento.get_carta()
	var container_og = movimento.get_onde_veio()
	var container_alvo = movimento.get_onde_esta_agora()
	
	
	# Problema: Movimentos independentes do mouse
		# 1 - Modificar a função soltando_cartas do movimento_jogo
			# Desvantagens:
				# - chatinho de modificar, alem de modificar a chamada dela no controle_jogo
		# 2 - Criar uma função nova de movimento (seja aki, seja no movimento_jogo)
			# Desvantagens:
				# - ela vai ficar muito parecida com a soltando_cartas original (ainda precisa de posiçoes alvo, ainda precisa de tweens)
		
	if container_og.is_in_group("Colunas Jogo"): # Carta estava nas colunas do jogo
		# Quando voltar um movimento de coluna jogo, precisa garantir que a carta anterior seja virada novamente
		pass
	elif container_og.is_in_group("Casas Jogo"): # Carta estava nas casas do jogo 
		# So movimentoar a carta de volta
		pass
	else: # Carta estava nas cartas viradas do deck
		# Quando voltar, vai ter q chamar adicionar_carta_virada 
		pass
	

func movimento_placeholder():
	pass
