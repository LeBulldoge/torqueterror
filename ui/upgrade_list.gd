class_name UpgradeList
extends VBoxContainer


signal upgrade_selected(idx: int, description: String)


func add_upgrade_item(icon: Texture2D, description: String):
    var idx = $List.add_icon_item(icon)
    $List.set_item_metadata(idx, description)

func _on_list_gui_input(event: InputEvent):
    if not event is InputEventMouseMotion:
        return

    var item = $List.get_item_at_position(get_local_mouse_position(), true)
    if item == -1:
        return

    $List.select(item, true)
    $List.item_selected.emit(item)


func _on_list_item_selected(index: int):
    var desc = $List.get_item_metadata(index)
    $Description.text = desc


func _on_list_item_clicked(index: int, _at_position, _mouse_button_index):
    var desc = $List.get_item_metadata(index)
    upgrade_selected.emit(index, desc)
