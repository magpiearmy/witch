extends GutTest
## Unit tests for the Inventory autoload (scripts/inventory.gd).
##
## Inventory is a singleton, so each test starts from a cleared satchel
## rather than a fresh instance - that way the object under test is the one
## actually wired up to SignalBus in the running game.

const RED := Constants.Item.RED_FRUIT
const BLUE := Constants.Item.BLUE_FRUIT
const PURPLE := Constants.Item.PURPLE_FRUIT
const BERRIES := Constants.Item.PINK_BERRIES

func before_each() -> void:
	Inventory.stacks.clear()


# --- add / count -----------------------------------------------------------

func test_starts_empty() -> void:
	assert_eq(Inventory.stacks.size(), 0)
	assert_eq(Inventory.count(RED), 0, "absent items count as zero")

func test_add_creates_a_stack() -> void:
	assert_true(Inventory.add(RED))
	assert_eq(Inventory.count(RED), 1)

func test_add_respects_amount() -> void:
	Inventory.add(RED, 4)
	assert_eq(Inventory.count(RED), 4)

func test_add_stacks_onto_the_same_type() -> void:
	Inventory.add(RED, 2)
	Inventory.add(RED, 3)
	assert_eq(Inventory.count(RED), 5)
	assert_eq(Inventory.stacks.size(), 1, "same type must not open a second stack")

func test_different_types_get_their_own_stacks() -> void:
	Inventory.add(RED)
	Inventory.add(BLUE)
	assert_eq(Inventory.stacks.size(), 2)

func test_stack_order_follows_first_pickup() -> void:
	Inventory.add(BLUE)
	Inventory.add(RED)
	Inventory.add(BLUE)  # topping up must not reorder
	assert_eq(Inventory.stacks.keys(), [BLUE, RED], "views draw slots in this order")


# --- capacity --------------------------------------------------------------

func _fill_to_capacity() -> void:
	for i in Inventory.CAPACITY:
		Inventory.stacks[i + 1] = 1  # Item values 1..CAPACITY, skipping NONE

func test_is_full_at_capacity() -> void:
	assert_false(Inventory.is_full())
	_fill_to_capacity()
	assert_true(Inventory.is_full())

func test_add_rejects_a_new_type_when_full() -> void:
	_fill_to_capacity()
	var spare: Constants.Item = Inventory.CAPACITY + 1
	assert_false(Inventory.add(spare), "no room to open another stack")
	assert_eq(Inventory.count(spare), 0)

func test_add_still_tops_up_a_held_type_when_full() -> void:
	_fill_to_capacity()
	var held: Constants.Item = 1
	assert_true(Inventory.add(held), "stacking needs no new slot")
	assert_eq(Inventory.count(held), 2)


# --- can_craft -------------------------------------------------------------

func test_can_craft_needs_every_ingredient() -> void:
	Inventory.add(RED, 1)
	Inventory.add(BLUE, 1)
	assert_false(Inventory.can_craft({RED: 1, BLUE: 1, PURPLE: 1}), "purple missing")
	Inventory.add(PURPLE, 1)
	assert_true(Inventory.can_craft({RED: 1, BLUE: 1, PURPLE: 1}))

func test_can_craft_needs_enough_of_each() -> void:
	Inventory.add(RED, 2)
	assert_false(Inventory.can_craft({RED: 3}))
	Inventory.add(RED, 1)
	assert_true(Inventory.can_craft({RED: 3}))

func test_can_craft_of_nothing_is_true() -> void:
	assert_true(Inventory.can_craft({}))


# --- take ------------------------------------------------------------------

func test_take_removes_the_exact_amount() -> void:
	Inventory.add(RED, 5)
	Inventory.take({RED: 3})
	assert_eq(Inventory.count(RED), 2)

func test_take_frees_the_stack_when_it_empties() -> void:
	Inventory.add(RED, 3)
	Inventory.take({RED: 3})
	assert_eq(Inventory.count(RED), 0)
	assert_eq(Inventory.stacks.size(), 0, "an emptied stack frees its slot")

func test_take_handles_several_ingredients() -> void:
	Inventory.add(BERRIES, 4)
	Inventory.add(BLUE, 1)
	Inventory.take({BERRIES: 2, BLUE: 1})
	assert_eq(Inventory.count(BERRIES), 2)
	assert_eq(Inventory.count(BLUE), 0)


# --- changed signal --------------------------------------------------------

func test_add_announces_a_change() -> void:
	watch_signals(Inventory)
	Inventory.add(RED)
	assert_signal_emit_count(Inventory, "changed", 1)

func test_take_announces_a_change() -> void:
	Inventory.add(RED, 2)
	watch_signals(Inventory)
	Inventory.take({RED: 1})
	assert_signal_emit_count(Inventory, "changed", 1)

func test_take_of_nothing_is_silent() -> void:
	# Regression: take() used to emit unconditionally, making every view
	# rebuild for a no-op.
	watch_signals(Inventory)
	Inventory.take({})
	assert_signal_emit_count(Inventory, "changed", 0)

func test_rejected_add_is_silent() -> void:
	_fill_to_capacity()
	watch_signals(Inventory)
	assert_false(Inventory.add(Inventory.CAPACITY + 1))
	assert_signal_emit_count(Inventory, "changed", 0)


# --- pickup flow (SignalBus wiring) ---------------------------------------

func _make_collectable(type: Constants.Item) -> Collectable:
	var collectable := Collectable.new()
	collectable.item = autofree(Node2D.new())
	collectable.item_type = type
	return autofree(collectable)

func test_collected_item_lands_in_the_satchel() -> void:
	watch_signals(SignalBus)
	var collectable := _make_collectable(RED)
	SignalBus.item_collected.emit(collectable, collectable.item)
	assert_eq(Inventory.count(RED), 1)
	assert_signal_emitted(SignalBus, "collect_successful")

func test_pickup_fails_when_the_satchel_is_full() -> void:
	_fill_to_capacity()
	watch_signals(SignalBus)
	var collectable := _make_collectable(Inventory.CAPACITY + 1)
	SignalBus.item_collected.emit(collectable, collectable.item)
	assert_signal_emitted(SignalBus, "collect_failed")
	assert_signal_not_emitted(SignalBus, "collect_successful")

func test_collectable_without_a_type_is_not_collected() -> void:
	# Regression: `item_type != null` could never be false, so an unset
	# Collectable silently read as RED_FRUIT.
	watch_signals(SignalBus)
	var collectable := _make_collectable(Constants.Item.NONE)
	collectable.try_collect()
	assert_signal_not_emitted(SignalBus, "item_collected")
	assert_eq(Inventory.stacks.size(), 0)
