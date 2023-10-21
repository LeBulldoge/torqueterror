class_name UpgradeList
extends VBoxContainer


signal upgrade_selected(idx: int, description: String)



func add_upgrade_item(title: String, icon: Texture2D, description: String):
    var idx = $List.add_item(title, icon)
    $List.set_item_metadata(idx, description)


func _on_list_gui_input(event: InputEvent):
    if not event is InputEventMouseMotion:
        return

    var item = $List.get_item_at_position(get_local_mouse_position(), true)
    if item == -1 or $List.get_selected_items().has(item):
        return

    $List.select(item, true)
    $List.item_selected.emit(item)


func _on_list_item_selected(index: int):
    var desc = $List.get_item_metadata(index)
    $Description.parse_bbcode(desc)


func _on_list_item_clicked(index: int, _at_position, _mouse_button_index):
    var desc = $List.get_item_metadata(index)
    $List.clear()
    $Description.clear()
    upgrade_selected.emit(index, desc)
