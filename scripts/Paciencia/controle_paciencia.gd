extends Control

var movimento : Movimento_Jogo 
var em_coluna:bool
var coluna_nova:Control

var save = load("res://scripts/save.gd") #para poder carregar a clase "abstrata"


signal moveuCartaColuna(carta_movida:Carta, coluna_og:Control, container_novo:Control, desvirou_carta:bool)

func inicia_jogo():
	await instancia_deck(Deck.cria_deck_desordenado(true))
	
	
	# Connectando sinais
	movimento.moveuCartasColuna.connect(update_vis_coluna)
	movimento.soltouCartasColuna.connect(update_pos_containers)
	movimento.soltandoCartas.connect(soltando_carta_check)
	
	for carta in get_tree().get_nodes_in_group("Cartas Jogo"):
		conectar_carta(carta)
		
	for coluna in get_tree().get_nodes_in_group("Areas Colunas Jogo"):
		coluna.mouse_entered.connect(Callable(self, "_on_area_container_mouse_entered").bind(coluna))
		coluna.mouse_exited.connect(_on_area_container_mouse_exited)
	
	for casa in get_tree().get_nodes_in_group("Casas Jogo"):
		casa.mouse_entered.connect(Callable(self, "_on_area_container_mouse_entered").bind(casa))
		casa.mouse_exited.connect(_on_area_container_mouse_exited)

# Funções relacionadas ao movimento de cartas
func on_carta_mouse_entered(carta:Carta):
	if carta.get_parent() != $"../Camada Drag":
		movimento.mouse_entrou_carta(carta)

func on_carta_mouse_exited(carta:Carta):
	movimento.mouse_saiu_carta(carta)

func _on_area_container_mouse_entered(container:Node):
	em_coluna = true
	#print("entrou!")
	if container.is_in_group("Areas Colunas Jogo"):
		coluna_nova = container.get_parent()
	else:
		coluna_nova = container

func _on_area_container_mouse_exited():
	#print("saiu!")
	em_coluna = false
	coluna_nova = null

# Funções para atualizar containers das colunas e visibilidade das cartas

func update_pos_containers():
	for coluna in get_tree().get_nodes_in_group("Colunas Jogo"):
		for i in range(coluna.get_child_count()) :
			var child = coluna.get_child(i)
			child.z_index = i

func update_vis_cartas() -> void:
	for coluna in get_tree().get_nodes_in_group("Colunas Jogo"):
		var nfilhos = coluna.get_child_count()
		if nfilhos > 1 and coluna.get_child(nfilhos-1).virada:
			coluna.get_child(nfilhos-1).virar_carta()

func update_vis_coluna(carta_movida:Carta, coluna_og:Control, container_novo:Control) -> void:
	var nfilhos = coluna_og.get_child_count()
	if nfilhos > 1 and coluna_og.get_child(nfilhos-1).virada:
		coluna_og.get_child(nfilhos-1).virar_carta()
		moveuCartaColuna.emit(carta_movida, coluna_og, container_novo, true)
	else:
		moveuCartaColuna.emit(carta_movida, coluna_og, container_novo, false)

# Função para instanciar o deck de cartas
func instancia_deck(deck_def:Array[Carta]):
	var colunas := get_tree().get_nodes_in_group("Colunas Jogo")
	var j := 0
	for i in range(28):
		var carta = deck_def[i]
		if ((i == 1) || (i == 3) || (i == 6) || (i == 10) || (i == 15) || (i == 21)):
			j = j + 1
		
		carta.add_to_group("Cartas Jogo")
		colunas[j].add_child(carta)
	
	for i in range(28,52):
		var deck_mesa := $"../Controle Deck/Deck"
		var carta = deck_def[i]
		deck_mesa.add_child(carta)
	
	update_pos_containers()
	update_vis_cartas()


# Funções da logica do paciencia

func soltando_carta_check(carta: Carta, coluna_og:Control):
	var container_alvo = coluna_og
	var movida : bool = false
	var pos_alvo:Vector2 = Vector2.ZERO
	
	if em_coluna and coluna_nova != null and coluna_nova != coluna_og:
		var nfilhos:int = coluna_nova.get_child_count()
		var valor_para_vazio:int
		var bool_casas_jogo:bool = coluna_nova.is_in_group("Casas Jogo")
		
		
		if bool_casas_jogo: valor_para_vazio = 1
		else: valor_para_vazio = 13
		
		if nfilhos > 1: # Colunas normais tem areacoluna e as casas de jogo tem um sprite2d 
			var carta_mae = coluna_nova.get_child(nfilhos-1)
			if !bool_casas_jogo and _comparar_cor(carta, carta_mae) and _comparar_valor_coluna(carta, carta_mae):
				container_alvo = coluna_nova
				movida = true
				
			if _comparar_naipe(carta, carta_mae) and _comparar_valor_casa(carta, carta_mae) and bool_casas_jogo:
				container_alvo = coluna_nova
				movida = true
				
		else: # Se for a primeira carta de uma casa ou de uma coluna
			if carta.valor == valor_para_vazio:
				container_alvo = coluna_nova
				movida = true
		
		
		pos_alvo = calcula_pos_carta(container_alvo)
	movimento.soltando_cartas(container_alvo, coluna_og, pos_alvo, movida, false)

# Retorna True se as cores entre duas cartas forem distintas
func _comparar_cor(carta1: Carta, carta2: Carta) -> bool:
	return carta1.cor != carta2.cor

# Retorna True se a diferença de valor entre a carta_mae e a carta_nova for de 1
func _comparar_valor_coluna(carta_nova: Carta, carta_mae: Carta) -> bool:
	return ((carta_mae.valor - carta_nova.valor) == 1)

func _comparar_valor_casa(carta_nova: Carta, carta_mae: Carta) -> bool:
	return ((carta_mae.valor - carta_nova.valor) == -1)

# Retorna True se carta1 e carta2 pertencerem ao mesmo naipe
func _comparar_naipe(carta1: Carta, carta2: Carta) -> bool:
	return carta1.naipe == carta2.naipe


func desconectar_carta(carta:Carta) -> void:
	if carta.is_connected("mouse_entered", on_carta_mouse_entered):
		carta.disconnect("mouse_entered", on_carta_mouse_entered)
	if carta.is_connected("mouse_exited", on_carta_mouse_exited):
		carta.disconnect("mouse_exited", on_carta_mouse_exited)

func conectar_carta(carta:Carta) -> void:
	if !carta.is_connected("mouse_entered", on_carta_mouse_entered):
		carta.connect("mouse_entered", on_carta_mouse_entered)
	if !carta.is_connected("mouse_exited", on_carta_mouse_exited):
		carta.connect("mouse_exited", on_carta_mouse_exited)

func update_conexoes() -> void:
	for i in get_tree().get_nodes_in_group("Colunas Jogo"):
		for j in i.get_children():
			if j is Carta and !j.virada:
				conectar_carta(j)


func calcula_posicao_alvo_de_carta_coluna(coluna_alvo: Node) -> Vector2:
	var pos_x_coluna = 76 + (150 * coluna_alvo.get_parent().get_children().find(coluna_alvo))
	var pos_y_alvo = 216 + ((coluna_alvo.get_child_count() - 1) * 25)
	
	return Vector2(pos_x_coluna, pos_y_alvo)

func calcula_posicao_alvo_de_carta_casa(coluna_alvo: Node) -> Vector2:
	var casa_alvo = coluna_alvo.name.trim_prefix("VBoxCasa ").to_int()
	var pos_x_alvo = 645 + (119 * (casa_alvo-1))
	var pos_y_casa = 22
	
	return Vector2(pos_x_alvo, pos_y_casa)

func calcula_pos_carta(container_alvo:Node) -> Vector2:
	if container_alvo.is_in_group("Casas Jogo"):
		return calcula_posicao_alvo_de_carta_casa(container_alvo)
	else:
		return calcula_posicao_alvo_de_carta_coluna(container_alvo)
