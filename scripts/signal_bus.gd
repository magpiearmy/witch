extends Node

## Something in the world was picked up; the Inventory decides whether it fits.
signal item_collected(collectable: Collectable, item: Node2D)
## ...and it did fit. Carries the world node that was collected, so the thing
## that grew it (a tree, a bush) can react.
signal collect_successful(item: Node2D)
## ...and it didn't - the satchel is full.
signal collect_failed

signal cauldron_opened
signal cauldron_closed

signal cottage_entered
signal cottage_exited
