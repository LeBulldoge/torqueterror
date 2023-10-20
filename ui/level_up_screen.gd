extends CanvasLayer


@onready var upgrade_list = $MarginContainer/Panel/MarginContainer/VBoxContainer/UpgradeList
@onready var upgrade_desc =$MarginContainer/Panel/MarginContainer/VBoxContainer/Label2


signal upgrade_selected(idx: int)


func add_upgrade_item(icon: Texture2D, description: String):
    upgrade_list.add_upgrade_item(icon, description)

func choose_upgrade() -> Signal:
    show()
    return upgrade_selected


func _on_upgrade_list_upgrade_selected(idx: int, description: String):
    hide()
    upgrade_selected.emit(idx)


func _on_upgrade_list_item_hovered(_idx: int, description: String):
    upgrade_desc.text = description
