extends StaticBody2D

func interact():
	SignalBus.cauldron_opened.emit()
