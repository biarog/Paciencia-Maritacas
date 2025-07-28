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
	
	controle_jogo.moveuCartaColuna.connect(salvar_movimento)
	movimento.moveuCartaCasa2.connect(salvar_movimento)
	movimento.moveuCartaDeck2.connect(salvar_movimento)
	controle_deck.virouCartaDeck.connect(salvar_movimento)
	
	pilha_movimentos = Pilha.new()

func _process(delta):
	movimento.processamento_movimento(delta)

func _input(event):
	if event.is_action_pressed("ui_cancel") and !get_tree().paused:
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

func _on_pausar_pressed() -> void:
	_pause_game()

# Funções relacionadas a pilha de movimentos

func salvar_movimento(carta_movida:Carta, container_og:Control, container_alvo:Control, desvirou_carta:bool) -> void:
	var no_novo:No_Pilha = No_Pilha.new(carta_movida, container_og, container_alvo, desvirou_carta)
	pilha_movimentos.push(no_novo)

func voltar_movimento() -> void:
	if pilha_movimentos.is_empty():
		return
	
	var movimento_feito:No_Pilha = pilha_movimentos.pop()
	var carta_m = movimento_feito.get_carta()
	var container_og = movimento_feito.get_onde_veio()
	var container_alvo = movimento_feito.get_onde_esta_agora()
	var desvirou_carta = movimento_feito.get_desvirou_carta()
	
	if container_og.is_in_group("Colunas Jogo"): # Carta estava nas colunas do jogo
		# Quando voltar um movimento de coluna jogo, precisa garantir que a carta anterior seja virada novamente
		await voltar_colunas(carta_m, container_og, container_alvo, desvirou_carta)
	
	elif container_og.is_in_group("Casas Jogo"): # Carta estava nas casas do jogo 
		# So movimentoar a carta de volta e reconectá-la
		await voltar_casas(carta_m, container_og, container_alvo)
	
	elif container_og == $"Controle Deck/Cartas Viradas": # Carta estava nas cartas viradas do deck
		# Quando voltar, vai ter q chamar adicionar_carta_virada
		await voltar_deck_desvirada(carta_m, container_og, container_alvo)
	
	else: # Carta estava no deck e foi virada para cartas viradas:
		await voltar_deck_virada(carta_m, container_og, container_alvo)
	
	if container_alvo.is_in_group("Casas Jogo"): controle_casas.atualizar_conexoes()

func voltar_colunas(carta_m:Carta, container_og:Control, container_alvo:Control, desvirou_carta:bool):
	if desvirou_carta:
		container_og.get_child(container_og.get_child_count() - 1).virar_carta()
	movimento.carregando_cartas(carta_m)
	movimento.soltando_cartas(container_og, container_alvo, controle_jogo.calcula_pos_carta(container_og), true, true)

func voltar_casas(carta_m:Carta, container_og:Control, container_alvo:Control):
	controle_jogo.conectar_carta(carta_m)
	movimento.carregando_cartas(carta_m)
	movimento.soltando_cartas(container_og, container_alvo, controle_jogo.calcula_pos_carta(container_og), true, true)
	controle_casas.atualizar_conexoes()

func voltar_deck_desvirada(carta_m:Carta, container_og:Control, container_alvo:Control):
	movimento.carregando_cartas(carta_m)
	movimento.soltando_cartas(container_og, container_alvo, controle_deck.calcula_pos_deck_viradas(), true, true)
	controle_deck.adicionar_carta_virada(carta_m, true)

func voltar_deck_virada(carta_m:Carta, container_og:Control, container_alvo:Control):
	if !carta_m.virada: carta_m.virar_carta()
	movimento.carregando_cartas(carta_m)
	movimento.soltando_cartas(container_og, container_alvo, controle_deck.deck.global_position, true, true)
	controle_deck.carta_removida_deck()
