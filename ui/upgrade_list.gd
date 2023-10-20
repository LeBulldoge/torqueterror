extends ItemList


signal upgrade_selected(idx: int, description: String)
signal item_hovered(idx: int, description: String)

func add_upgrade_item(icon: Texture2D, description: String):
    var idx = add_icon_item(icon)
    set_item_metadata(idx, description)


func _on_gui_input(event: InputEvent):
    if not event is InputEventMouseMotion:
        return

    var item = get_item_at_position(get_local_mouse_position(), true)
    if item == -1:
        return

    select(item, true)
    item_selected.emit(item)


func _on_item_selected(index: int):
    var desc = get_item_metadata(index)
    item_hovered.emit(index, desc)


func _on_item_clicked(index: int, _at_position, _mouse_button_index):
    var desc = get_item_metadata(index)
    upgrade_selected.emit(index, desc)
