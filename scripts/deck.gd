class_name Deck extends Node

static func cria_deck(virado:bool) -> Array[Carta]:
	var deck: Array[Carta]
	for casa in range(4):
		for i in range(1,14):
			var nova_carta:Carta = Carta.cria_nova_carta(casa, i, virado)
			deck.append(nova_carta)
	return deck

static func cria_deck_desordenado(virado:bool) -> Array[Carta]:
	var deck = cria_deck(virado)
	deck.shuffle()
	return deck
