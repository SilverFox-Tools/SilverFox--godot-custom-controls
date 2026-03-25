# ============================================
# DropDown 下拉控件
# 作者: 东方银狐
# GitHub: https://github.com/bilibiliDFYH
# 许可证: MIT
# V0.1
# ============================================

@tool
extends Button
class_name DropDown

var DropDownButton : Button = Button.new ()
var Is_DropDown = false
var Node_Item = Control.new ()
var NodeList_Options : Array[Button] = []

@export_group("下拉栏", "DropDown_")
@export var DropDown_Size : Vector2 = Vector2 (128 , 32) :
	set (value) :
		DropDown_Size = Vector2 (max (value.x , 0) , max (value.y , 0) )
		Node_Item.position.y = DropDown_Size.y

@export var DropDown_ItemSize : Vector2 = Vector2 (128 , 32) :
	set (value) :
		DropDown_ItemSize = Vector2 (max (value.x , 0) , max (value.y , 0) )

@export var DropDown_ButtonWidth : float = 32
@export var DropDown_ButtonTheme: Theme
@export var DropDown_ItemTheme: Theme

@export_group("选项", "Option_")
@export var Option_Options : Array[OptionItem] = [] :
	set (Options) :
		Option_Options = Options
		Update_Options ()

@export var Option_Selected : int = 0 :
	set (value) :
		Update_Options ()
		value = max (value , 0)
		value = min (value , Option_Options.size () - 1 )
		Option_Selected = value

		text = Option_Options[Option_Selected].Text
		icon = Option_Options[Option_Selected].Icon

func _ready() -> void:
	self.size = DropDown_Size - Vector2 (DropDown_ButtonWidth , 0)
	self.pressed.connect (DropDownButton_Pressed)

	DropDownButton.theme = DropDown_ButtonTheme
	DropDownButton.size = Vector2 (DropDown_ButtonWidth , DropDown_Size.y)
	DropDownButton.position.x = self.size.x
	DropDownButton.pressed.connect (DropDownButton_Pressed)
	add_child (DropDownButton)

	Node_Item.visible = false
	Node_Item.position.y = DropDown_Size.y
	add_child(Node_Item)

func DropDownButton_Pressed () :
	Is_DropDown = !Is_DropDown

	Node_Item.visible = Is_DropDown

func Set_Selected (Number) :
	Option_Selected = Number
	Is_DropDown = false
	Node_Item.visible = false

func Update_Options () :
	if Option_Options.is_empty () :
		Option_Options.append (OptionItem.new () )

	for i in Option_Options.size () :
		if Option_Options[i] is not OptionItem :
			Option_Options[i] = OptionItem.new ()

	for node in NodeList_Options :
		if node && node.is_inside_tree () :
			node.queue_free ()

	NodeList_Options = []

	var Item_position = Vector2.ZERO
	for i in Option_Options.size () :
		var item = Option_Options[i]
		var node = Button.new ()
		node.size = DropDown_ItemSize
		node.position = Item_position
		node.theme = DropDown_ItemTheme
		node.text = item.Text
		node.icon = item.Icon
		node.disabled = item.Disabled

		node.pressed.connect (Set_Selected.bind (i) )

		NodeList_Options.append (node)
		Node_Item.add_child (node)
		Item_position.y += DropDown_ItemSize.y
