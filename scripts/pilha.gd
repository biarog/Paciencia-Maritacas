class_name Pilha
extends Object

# Um Array para armazenar os nós da pilha.
var _elementos: Array = []

# Empilha: Adiciona um novo nó ao topo da pilha.
func push(no_pilha: No_Pilha):
	_elementos.push_back(no_pilha)

# Desempilha: Remove e retorna o nó do topo.
# Retorna null se a pilha estiver vazia.
func pop() -> No_Pilha:
	if not is_empty():
		return _elementos.pop_back()
	
	print("Aviso: Tentativa de remover de uma pilha vazia.")
	return null

# Espia: Retorna o nó do topo sem removê-lo.
# Retorna null se a pilha estiver vazia.
func peek() -> No_Pilha:
	if not is_empty():
		return _elementos.back() # .back() é um atalho para o último elemento
	return null

# Verifica se a pilha não contém elementos.
func is_empty() -> bool:
	return _elementos.is_empty()

# Retorna a quantidade de nós na pilha.
func get_tamanho() -> int:
	return _elementos.size()
