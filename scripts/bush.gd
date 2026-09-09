extends StaticBody2D

func interact():
	if $Berries:
		$Berries/Collectable.try_collect()
