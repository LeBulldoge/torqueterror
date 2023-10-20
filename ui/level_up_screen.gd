extends CanvasLayer


@onready var upgrade_list = $MarginContainer/Panel/MarginContainer/VBoxContainer/UpgradeList as UpgradeList


signal upgrade_selected(idx: int)


func add_upgrade_item(icon: Texture2D, description: String):
    upgrade_list.add_upgrade_item(icon, description)


func choose_upgrade() -> Signal:
    show()
    return upgrade_selected


func _on_upgrade_list_upgrade_selected(idx: int, description: String):
    hide()
    upgrade_selected.emit(idx)
