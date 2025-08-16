extends Node

func _on_witch_interaction(body: Node2D) -> void:
	print("Witch interacts with: " + str(body))
	for child in body.get_children():
		if child is Interactable:
			child.interact()
