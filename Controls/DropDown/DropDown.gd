# ============================================
# DropDown 下拉控件
# 作者:
# ——>	东方银狐 / DFYH / DF.SilverFox
# ———	——>	https://github.com/bilibiliDFYH
#
# 组织: 东方银狐的奇妙工具 / SilverFox-Tools
# ——>	https://github.com/SilverFox-Tools
#
# 许可证: MIT
# V0.3a
# ============================================

@tool
extends Button
class_name DropDown

var DropDownBtn_Is_Touch = false :
	set (value) :
		DropDownBtn_Is_Touch = value
		Update_DropDownBtn_Icon ()

var DropDown_Is_Touch = false
var Scroll_direction = 1

var Node_Button : Button = Button.new ()
var Node_Background : Panel = Panel.new ()
var Node_Item : Control = Control.new ()
var NodeList_Items : Array[Button] = []

var DefaultTheme = ThemeDB.get_project_theme ()
var EditorTheme = ThemeDB.get_default_theme ()

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
		Update_DropDownBtn_Icon ()
		Node_Background.visible = DropDown_Is_DropDown

@export var DropDown_AllowNotToSelect : bool = true :
	set (value) :
		DropDown_AllowNotToSelect = value
		DropDown_Index = DropDown_Index

@export var DropDown_Index : int = -1 :
	set (value) :
		if DropDown_AllowNotToSelect :
			value = max (value , -1)
		else :
			value = max (value , 0)
		value = min (value , DropDownItem_Items.size () - 1)

		value = Select_NonDisabled (value)

		DropDown_Index = value
		Update_SelfDisplay ()

@export var DropDown_Alignment : HorizontalAlignment = 0 as HorizontalAlignment :
	set (value) :
		DropDown_Alignment = value
		Update_Alignment ()

@export var DropDown_IconAlignment : HorizontalAlignment = 0 as HorizontalAlignment :
	set (value) :
		DropDown_IconAlignment = value
		Update_Alignment ()

@export var DropDown_IconAlignment_Vertical : VerticalAlignment = 1 as VerticalAlignment :
	set (value) :
		DropDown_IconAlignment_Vertical = value
		Update_Alignment ()
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
@export var DropDownItem_Width : float = 128 - 8 :
	set (value) :
		DropDownItem_Width = max (value , 0)
		Update_Items ("ItemDisplay")

@export_tool_button ("重置Item宽度") var DropDownItem_reset_Width = DropDownItem_resetWidth

func DropDownItem_resetWidth () :
	DropDownItem_Width = DropDown_Size.x - DropDownItem_Margin.x - DropDownItem_Margin.z

@export var DropDownItem_Height : float = 32 :
	set (value) :
		DropDownItem_Height = max (value , 0)
		Update_Items ("ItemDisplay")

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

@export var DropDownItem_Margin : Vector4 = Vector4 (4 , 4 , 4 , 4) :
	set (value) :
		DropDownItem_Margin = Vector4 (max (value.x , 0) , max (value.y , 0) , max (value.z , 0) , max (value.w , 0))
		Node_Item.position = Vector2 (DropDownItem_Margin.x , DropDownItem_Margin.y)
		Node_Background.size = Node_Item.size + Vector2 (DropDownItem_Margin.x , DropDownItem_Margin.y) + Vector2 (DropDownItem_Margin.z , DropDownItem_Margin.w)

@export var DropDownItem_Alignment : HorizontalAlignment = 0 as HorizontalAlignment :
	set (value) :
		DropDownItem_Alignment = value
		Update_Alignment ()

@export var DropDownItem_IconAlignment : HorizontalAlignment = 0 as HorizontalAlignment :
	set (value) :
		DropDownItem_IconAlignment = value
		Update_Alignment ()

@export var DropDownItem_IconAlignment_Vertical : VerticalAlignment = 1 as VerticalAlignment :
	set (value) :
		DropDownItem_IconAlignment_Vertical = value
		Update_Alignment ()
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

	self.pressed.connect (DropDownBtn_Pressed)
	self.mouse_entered.connect (DropDown_entered)
	self.mouse_exited.connect (DropDown_exited)

	Node_Button.name = "Button"
	Node_Button.pressed.connect (DropDownBtn_Pressed)
	Node_Button.mouse_entered.connect (DropDownBtn_entered)
	Node_Button.mouse_exited.connect (DropDownBtn_exited)
	Node_Button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

	Node_Background.name = "Background"
	Node_Item.name = "Items"

	Set_Theme ()
	Update_Items ()

	DropDown_Index = Select_NonDisabled (DropDown_Index)
	Update_SelfDisplay ()

	Update_Alignment ()

var _last_disabled = self.disabled
func _process (_delta : float) -> void :
	if _last_disabled != self.disabled :
		Update_DropDownBtn_Icon ()
		Node_Button.disabled = self.disabled

	_last_disabled = self.disabled


#region 输入信号
func DropDownBtn_Pressed () :
	DropDown_Is_DropDown = !DropDown_Is_DropDown

func DropDown_entered() :
	DropDown_Is_Touch = true
	grab_focus ()

func DropDown_exited() :
	DropDown_Is_Touch = false


func DropDownBtn_entered () :
	DropDownBtn_Is_Touch = true

func DropDownBtn_exited () :
	DropDownBtn_Is_Touch = false

func Item_Pressed (value : int) :
	DropDown_Index = value
	DropDownBtn_Pressed ()

var temp_Rolling_volume = 0.0
func _gui_input (event : InputEvent) -> void :
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			if DropDown_Is_Touch :
				Scroll_direction = 0
				temp_Rolling_volume -= 0.5

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			if DropDown_Is_Touch :
				Scroll_direction = 1
				temp_Rolling_volume += 0.5

	if event is InputEventKey :
		match event.keycode :
			KEY_UP :
				if event.pressed :
					if DropDown_Is_Touch :
						Scroll_direction = 0
						temp_Rolling_volume -= 1
			KEY_DOWN :
				if event.pressed :
					if DropDown_Is_Touch :
						Scroll_direction = 1
						temp_Rolling_volume += 1
			KEY_ESCAPE :
				if event.pressed and DropDown_Is_DropDown :
					DropDown_Is_DropDown = false

	var temp_DropDown_Index = DropDown_Index + int (temp_Rolling_volume)

	DropDown_Index = temp_DropDown_Index

	if temp_Rolling_volume >= 1 or temp_Rolling_volume <= -1 :
		temp_Rolling_volume = 0
#endregion


func Update_Items (Type : String = "Redraw") :
	match Type :
		"Redraw" :
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
					NodeList_Items[i].pressed.connect (Item_Pressed.bind (i) )

					Node_Item.add_child (NodeList_Items[i])

				elif not node.is_inside_tree () :
					Node_Item.add_child (node)

			Update_Items ("ItemDisplay")

		"ItemDisplay" :
			var Position_NodeItem = 0
			for i in DropDownItem_Items.size () :
				var node : Button = NodeList_Items[i]
				var Item : OptionItem = DropDownItem_Items[i]
				node.size = Vector2 (DropDownItem_Width , DropDownItem_Height)
				node.position = Vector2 (0 , Position_NodeItem)

				node.text = Item.Text
				node.icon = Item.Icon
				node.disabled = Item.Disabled


				Position_NodeItem += node.size.y

			Node_Item.size = Vector2 (DropDownItem_Width , Position_NodeItem)

			DropDownItem_Margin = DropDownItem_Margin

			Set_Theme ("DropDownItem")
			Update_Alignment ()

	DropDown_Index = Select_NonDisabled (DropDown_Index)
	Update_SelfDisplay ()


#region 设置外观
func Set_Theme (Type : String = "All") :
	var styleboxlist = ["normal" , "hover" , "pressed" , "disabled" , "focus"]
	var iconlist = ["" , "_hover" , "_pressed" , "_disabled"]

	_Modify_theme = true

	match Type :
		"All" :
			Set_Theme ("DropDown")
			Set_Theme ("DropDownBtn")
			Set_Theme ("DropDownBtn-Icon")
			Set_Theme ("DropDownItem")
			Set_Theme ("DropDownItemBackground")

		"DropDown" :
			for stylebox_name in styleboxlist :
				var style : StyleBox
				var LineEdit_stylebox_name : String = "normal"
				if stylebox_name == "disabled" :
					LineEdit_stylebox_name = "read_only"
				elif stylebox_name == "focus" :
					LineEdit_stylebox_name = "focus"

				var fallback_item = HandleTheme.FallbackItem.new (LineEdit_stylebox_name , "LineEdit")

				style = HandleTheme.get_style (theme , stylebox_name , "DropDown" , [fallback_item])
				if !style :
					style = HandleTheme.get_style (DefaultTheme , stylebox_name , "DropDown" , [fallback_item])
				if !style :
					style = HandleTheme.get_style (EditorTheme , fallback_item.name , fallback_item.theme_type)

				self.add_theme_stylebox_override (stylebox_name, style)

		"DropDownBtn" :
			for stylebox_name in styleboxlist :
				var style : StyleBox

				var fallback_item = HandleTheme.FallbackItem.new (stylebox_name , "Button")

				style = HandleTheme.get_style (theme , stylebox_name , "DropDownBtn" , [fallback_item])
				if !style :
					style = HandleTheme.get_style (DefaultTheme , stylebox_name , "DropDownBtn" , [fallback_item])
				if !style :
					style = HandleTheme.get_style (EditorTheme , fallback_item.name , fallback_item.theme_type)

				Node_Button.add_theme_stylebox_override (stylebox_name, style)

		"DropDownBtn-Icon" :
			for icon_name in iconlist :
				for temp_str in ["up" , "down"] :
					var theme_icon : Texture
					var icon_Fullname = temp_str + icon_name

					var fallback_item = HandleTheme.FallbackItem.new (icon_Fullname , "SpinBox")

					theme_icon = HandleTheme.get_icon (theme , icon_Fullname , "DropDownBtn" , [fallback_item])
					if !theme_icon :
						theme_icon = HandleTheme.get_icon (DefaultTheme , icon_Fullname , "DropDownBtn" , [fallback_item])
					if !theme_icon :
						theme_icon = HandleTheme.get_icon (EditorTheme , fallback_item.name , fallback_item.theme_type)

					if theme_icon :
						Node_Button.add_theme_icon_override (icon_Fullname , theme_icon)

			Update_DropDownBtn_Icon ()

		"DropDownItem" :
			for stylebox_name in styleboxlist :
				var style : StyleBox

				var fallback_item = HandleTheme.FallbackItem.new (stylebox_name , "FlatButton")

				style = HandleTheme.get_style (theme , stylebox_name , "DropDownItem" , [fallback_item])
				if !style :
					style = HandleTheme.get_style (DefaultTheme , stylebox_name , "DropDownItem" , [fallback_item])
				if !style :
					style = HandleTheme.get_style (EditorTheme , fallback_item.name , fallback_item.theme_type)

				for nodes_item in NodeList_Items :
					nodes_item.add_theme_stylebox_override (stylebox_name, style)

		"DropDownItemBackground" :
			var temp_style : StyleBox

			var temp_fallback_item = HandleTheme.FallbackItem.new ("normal" , "LineEdit")

			temp_style = HandleTheme.get_style (theme , "background" , "DropDownItem" , [temp_fallback_item])
			if !temp_style :
				temp_style = HandleTheme.get_style (DefaultTheme , "background" , "DropDownItem" , [temp_fallback_item])
			if !temp_style :
				temp_style = HandleTheme.get_style (EditorTheme , temp_fallback_item.name , temp_fallback_item.theme_type)

			Node_Background.add_theme_stylebox_override ("panel" , temp_style)

	_Modify_theme = false

func Update_DropDownBtn_Icon () :
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
	elif DropDownBtn_Is_Touch :
		temp_str2 = "_hover"
	else :
		temp_str2 = ""

	var theme_icon = Node_Button.get_theme_icon (temp_str1 + temp_str2)

	if theme_icon :
		Node_Button.add_theme_icon_override ("icon", theme_icon)

func Update_Alignment () :
	self.alignment = DropDown_Alignment
	self.icon_alignment = DropDown_IconAlignment
	self.vertical_icon_alignment = DropDown_IconAlignment_Vertical

	for node : Button in NodeList_Items :
		node.alignment = DropDownItem_Alignment
		node.icon_alignment = DropDownItem_IconAlignment
		node.vertical_icon_alignment = DropDownItem_IconAlignment_Vertical

func Update_SelfDisplay () :
		if DropDown_Index != -1 && DropDownItem_Items.size () > 0 :
			self.text = DropDownItem_Items[DropDown_Index].Text
			self.icon = DropDownItem_Items[DropDown_Index].Icon
		else :
			self.text = ""
			self.icon = null
#endregion


#region 设置Item
func Add_Item (value) :
	DropDownItem_Items += [OptionItem.new ()]
	Set_Item (value , DropDownItem_Items.size () - 1)

func Add_Items (Array_value : Array) :
	for value_2 in Array_value :
		Add_Item (value_2)

func Set_Item (value , ID : int = 0) :
	if ID < 0 :
		printerr (	"Set_Item: 索引低于最小值")
		printerr (	"├─	索引:")
		printerr (	"│	└─	" , ID)
		#printerr (	"└─	你是脑袋被驴踢了吗,居然试图设置第 ",ID," 个Item的数据,你家List有低于第0个的元素啊")
		#咳咳，我们应该文明用词
		printerr (	"└─	List/Array列表没有低于第 0 个的元素")

		print ()
		return

	var MAX_ITEMS = DropDownItem_Items.size () - 1
	if ID > MAX_ITEMS :
		printerr (	"Set_Item: 索引超出列表长度")
		printerr (	"├─	索引:")
		printerr (	"│	└─	" , ID)
		printerr (	"└─	列表最大项:")
		printerr (	"	└─	" , MAX_ITEMS)

		print ()
		return

	if value is String :
		DropDownItem_Items[ID].Text = value
	elif value is Texture :
		DropDownItem_Items[ID].Icon = value
	elif value is bool :
		DropDownItem_Items[ID].Disabled = value
	elif value is OptionItem :
		DropDownItem_Items[ID] = value

	elif value is Array :
		for value_1 in value :
			if value_1 is String :
				DropDownItem_Items[ID].Text = value_1
			elif value_1 is Texture :
				DropDownItem_Items[ID].Icon = value_1
			elif value_1 is bool :
				DropDownItem_Items[ID].Disabled = value_1

	elif value is Dictionary :
		for value_key : String in value :
			var value_value = value[value_key]

			match value_key.to_lower () :
				"text" , "name" , "label" :
					if value_value is String :
						DropDownItem_Items[ID].Text = value_value

				"icon" , "image" :
					if value_value is Texture :
						DropDownItem_Items[ID].Icon = value_value

				"disabled" , "disable" :
					DropDownItem_Items[ID].Disabled = bool (value_value)
#endregion


func Select_NonDisabled (value : int) -> int :
	if value != -1 and value < DropDownItem_Items.size () and DropDownItem_Items[value].Disabled :
		if DropDownItem_Items.size () <= 1 :
			value = -1

		else :
			var temp_int = 1
			var Previous = 0
			var Next = 0

			while DropDownItem_Items.size () > temp_int + value :
				if not DropDownItem_Items[temp_int + value].Disabled :
					Next = temp_int
					break
				temp_int += 1

			temp_int = -1
			while -1 < temp_int + value :
				if not DropDownItem_Items[temp_int + value].Disabled :
					Previous = temp_int
					break
				temp_int -= 1

			if Scroll_direction == 1 :
				if Next != 0 :
					value += Next
				elif Previous != 0 :
					value += Previous

			elif Scroll_direction == 0 :
				if Previous != 0 :
					value += Previous
				elif Next != 0 :
					value += Next

	return value
