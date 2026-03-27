# ============================================
# DropDown 下拉控件
# 作者: 东方银狐
# GitHub: https://github.com/bilibiliDFYH
# 许可证: MIT
# V0.2
# ============================================

@tool
extends Button
class_name DropDown

var DropDownButton_Is_Touch = false :
	set (value) :
		DropDownButton_Is_Touch = value
		Update_DropDownButton_Icon ()

var Node_Button : Button = Button.new ()
var Node_Background : Panel = Panel.new ()
var Node_Item : Control = Control.new ()
var NodeList_Items : Array[Button] = []

#region 下拉栏 DropDown_
@export_group ("下拉栏", "DropDown_")
@export var DropDown_Size : Vector2 = Vector2 (128 , 32) :
	set (value) :
		DropDown_Size = Vector2 (max (value.x , 0) , max (value.y , 0) )
		self.size = DropDown_Size
		Calculate_DropDownBtn_Position ()

@export var DropDown_Is_DropDown : bool = false :
	set (value) :
		DropDown_Is_DropDown = value
		Update_DropDownButton_Icon ()
		Node_Background.visible = DropDown_Is_DropDown

@export var DropDown_Index : int = -1 :
	set (value) :
		value = max (value , -1)
		value = min (value , DropDownItem_Items.size () - 1)
		DropDown_Index = value
		if DropDown_Index == -1 :
			self.text = ""
			self.icon = null
		else :
			self.text = DropDownItem_Items[DropDown_Index].Text
			self.icon = DropDownItem_Items[DropDown_Index].Icon
#endregion


#region 按钮 DropDownBtn_
@export_group ("按钮", "DropDownBtn_")
## 按钮大小
@export var DropDownBtn_Size : Vector2 = Vector2 (24 , 32) :
	set (value) :
		DropDownBtn_Size = Vector2 (max (value.x , 0) , max (value.y , 0) )
		Node_Button.size = DropDownBtn_Size
		Calculate_DropDownBtn_Position ()

## 按钮位置模式[br]
@export var DropDownBtn_PositionMod : Enums.PositionMode = 0 as Enums.PositionMode :
	set (value) :
		DropDownBtn_PositionMod = value
		Calculate_DropDownBtn_Position ()

## 按钮位置
@export var DropDownBtn_Position : Vector2 = Vector2 (0 , 0) :
	set (value) :
		DropDownBtn_Position = value
		Calculate_DropDownBtn_Position ()
#endregion


#region 选项 DropDownItem_
@export_group ("选项", "DropDownItem_")
## 选项大小
@export var DropDownItem_Width : float = 124 :
	set (value) :
		DropDownItem_Width = max (value , 0)
		Update_Items ()

@export_tool_button ("重置Item宽度") var DropDownItem_reset_Width = DropDownItem_resetWidth

func DropDownItem_resetWidth () :
	DropDownItem_Width = DropDown_Size.x - DropDownItem_Margin.x - DropDownItem_Margin.z

@export var DropDownItem_Height : float = 32 :
	set (value) :
		DropDownItem_Height = max (value , 0)
		Update_Items ()

@export var DropDownItem_Position : Vector2 = Vector2 (0 , DropDown_Size.y) :
	set (value) :
		DropDownItem_Position = value
		Node_Background.position = DropDownItem_Position

@export_tool_button ("重置Item位置") var DropDownItem_reset_position = DropDownItem_resetPosition

func DropDownItem_resetPosition () :
	DropDownItem_Position = Vector2 (0 , DropDown_Size.y)


@export var DropDownItem_Items : Array[OptionItem] = [] :
	set (Items) :
		DropDownItem_Items = Items
		Update_Items ()

@export var DropDownItem_NeedBackground : bool = true

@export var DropDownItem_Margin : Vector4 = Vector4 (2 , 2 , 2 , 2) :
	set (value) :
		DropDownItem_Margin = Vector4 (max (value.x , 0) , max (value.y , 0) , max (value.z , 0) , max (value.w , 0))
		Node_Item.position = Vector2 (DropDownItem_Margin.x , DropDownItem_Margin.y)
		Node_Background.size = Node_Item.size + Vector2 (DropDownItem_Margin.x , DropDownItem_Margin.y) + Vector2 (DropDownItem_Margin.z , DropDownItem_Margin.w)
#endregion


#region 再编辑器里初始化 Initialize in the editor
var _added_to_scene = false
var _Modify_theme = false
var Engine_ready = false

func _notification (what : int) :
	if what == NOTIFICATION_RESIZED and Engine.is_editor_hint () and Engine_ready :
		DropDown_Size = self.size
		Calculate_DropDownBtn_Position ()

	if what == NOTIFICATION_POST_ENTER_TREE and not _added_to_scene :
		_added_to_scene = true
		Node_Button.size = DropDownBtn_Size

		add_child (Node_Button)
		add_child (Node_Background)
		Node_Background.add_child (Node_Item)
		Node_Background.position = DropDownItem_Position
		Node_Background.visible = DropDown_Is_DropDown

		Calculate_DropDownBtn_Position ()
		Set_Theme ()
		Update_Items ()

	if what == NOTIFICATION_THEME_CHANGED and not _Modify_theme :
		Set_Theme ()

func Calculate_DropDownBtn_Position () :
	if DropDownBtn_PositionMod == 0 :
		Node_Button.position = Vector2 (DropDown_Size.x , 0) + DropDownBtn_Position
	elif DropDownBtn_PositionMod == 1 :
		Node_Button.position = Vector2 (DropDown_Size.x - DropDownBtn_Size.x , 0) + DropDownBtn_Position

	elif DropDownBtn_PositionMod == 2 :
		Node_Button.position = Vector2 (0 - DropDownBtn_Size.x , 0) + DropDownBtn_Position
	elif DropDownBtn_PositionMod == 3 :
		Node_Button.position = DropDownBtn_Position

	else :
		Node_Button.position = DropDownBtn_Position
#endregion

func _ready () -> void :
	if Engine.is_editor_hint () :
		await get_tree ().process_frame
		Engine_ready = true
		self.size = DropDown_Size

	self.pressed.connect (DropDownButton_Pressed)

	Node_Button.name = "Button"
	Node_Button.pressed.connect (DropDownButton_Pressed)
	Node_Button.mouse_entered.connect (DropDownButton_entered)
	Node_Button.mouse_exited.connect (DropDownButton_exited)
	Node_Button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

	Node_Background.name = "Background"
	Node_Item.name = "Items"

	Set_Theme ()
	Update_Items ()

	if DropDown_Index == -1 :
		self.text = ""
		self.icon = null
	else :
		self.text = DropDownItem_Items[DropDown_Index].Text
		self.icon = DropDownItem_Items[DropDown_Index].Icon

var _last_disabled = self.disabled
func _process (_delta : float) -> void :
	if _last_disabled != self.disabled :
		Update_DropDownButton_Icon ()
		Node_Button.disabled = self.disabled

	_last_disabled = self.disabled


func DropDownButton_Pressed () :
	DropDown_Is_DropDown = !DropDown_Is_DropDown

func DropDownButton_entered () :
	DropDownButton_Is_Touch = true

func DropDownButton_exited () :
	DropDownButton_Is_Touch = false


func Item_Pressed (value : int) :
	DropDown_Index = value
	DropDownButton_Pressed ()


func Update_Items () :
	for i in DropDownItem_Items.size () :
		if DropDownItem_Items[i] is not OptionItem :
			DropDownItem_Items[i] = OptionItem.new ()
			DropDownItem_Items[i].set_parent (self)

	while NodeList_Items.size () > DropDownItem_Items.size () :
		var btn = NodeList_Items.pop_back ()
		if btn and btn.is_inside_tree () :
			btn.queue_free ()

	NodeList_Items.resize (DropDownItem_Items.size () )

	for i in NodeList_Items.size () :
		var node = NodeList_Items[i]
		if not node or node is not Button :
			if node and node.is_inside_tree () :
				node.queue_free ()
			NodeList_Items[i] = Button.new ()
			Node_Item.add_child (NodeList_Items[i])

		elif not node.is_inside_tree () :
			Node_Item.add_child (node)

	var Position_NodeItem = 0
	for i in DropDownItem_Items.size () :
		var node : Button = NodeList_Items[i]
		var Item : OptionItem = DropDownItem_Items[i]
		node.size = Vector2 (DropDownItem_Width , DropDownItem_Height)
		node.position = Vector2 (0 , Position_NodeItem)

		node.text = Item.Text
		node.icon = Item.Icon
		node.disabled = Item.Disabled

		node.pressed.connect (Item_Pressed.bind (i) )

		Position_NodeItem += node.size.y

	Node_Item.size = Vector2 (DropDownItem_Width , Position_NodeItem)

	DropDownItem_Margin = DropDownItem_Margin


func Set_Theme () :
	var current_theme = ThemeDB.get_default_theme ()

	if !theme :
		theme = ThemeDB.get_project_theme ()

	if theme :
		_Modify_theme = true
		var styleboxlist = ["normal" , "hover" , "pressed" , "disabled" , "focus"]
		var iconlist = ["" , "_hover" , "_pressed" , "_disabled"]

#DropDown
		for stylebox_name in styleboxlist :
			var style = theme.get_stylebox (stylebox_name , "DropDown")
			if !style :
				style = theme.get_stylebox ("normal" , "LineEdit")
			if current_theme and !style :
				style = current_theme.get_stylebox ("normal" , "LineEdit")

			if style :
				self.add_theme_stylebox_override (stylebox_name, style)

#DropDownBtn
		for stylebox_name in styleboxlist :
			var style = theme.get_stylebox (stylebox_name , "DropDownBtn")
			if style :
				Node_Button.add_theme_stylebox_override (stylebox_name, style)

#DropDownBtn-Icon
		for icon_name in iconlist :
			for temp_str in ["up" , "down"] :
				var theme_icon = theme.get_icon (temp_str + icon_name , "DropDownBtn")
				if !theme_icon :
					theme_icon = theme.get_icon (temp_str + icon_name , "SpinBox")
				if current_theme and !theme_icon :
					theme_icon = current_theme.get_icon (temp_str + icon_name , "LineEdit")

				if theme_icon :
					Node_Button.add_theme_icon_override (temp_str + icon_name, theme_icon)

#DropDownItem
		for stylebox_name in styleboxlist :
			var style

			if theme.has_stylebox (stylebox_name, "DropDownItem") :
				style = theme.get_stylebox (stylebox_name , "DropDownItem")

			elif theme.has_stylebox (stylebox_name , "FlatButton") :
				style = theme.get_stylebox (stylebox_name , "FlatButton")

			elif current_theme and current_theme.has_stylebox (stylebox_name , "FlatButton") :
				style = current_theme.get_stylebox (stylebox_name , "FlatButton")

			if style :
				for nodes_item in NodeList_Items :
					nodes_item.add_theme_stylebox_override (stylebox_name, style)

#DropDownItemBackground
		var temp_style

		if theme.has_stylebox ("Background" , "DropDownItem") :
			temp_style = theme.get_stylebox ("Background" , "DropDownItem")

		elif theme.has_stylebox ("normal" , "LineEdit") :
			temp_style = theme.get_stylebox ("normal" , "LineEdit")

		elif current_theme and current_theme.has_stylebox ("normal" , "LineEdit") :
			temp_style = current_theme.get_stylebox ("normal" , "LineEdit")

		if temp_style :
			Node_Background.add_theme_stylebox_override ("panel" , temp_style)

		_Modify_theme = false

	Update_DropDownButton_Icon ()

func Update_DropDownButton_Icon () :
	var temp_str1 = "down"
	var temp_str2 = ""
	if DropDown_Is_DropDown :
		temp_str1 = "up"
	else :
		temp_str1 = "down"

	if Node_Button.disabled :
		temp_str2 = "_disabled"
	elif Node_Button.button_pressed :
		temp_str2 = "_pressed"
	elif DropDownButton_Is_Touch :
		temp_str2 = "_hover"
	else :
		temp_str2 = ""

	var theme_icon = Node_Button.get_theme_icon (temp_str1 + temp_str2)

	if theme_icon :
		Node_Button.add_theme_icon_override ("icon", theme_icon)
