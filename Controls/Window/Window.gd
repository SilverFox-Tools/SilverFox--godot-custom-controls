# ============================================
# Window 窗口
# 作者:
# ——>	东方银狐 / DFYH / DF.SilverFox
# ———	——>	https://github.com/bilibiliDFYH
#
# 组织: 东方银狐的奇妙工具 / SilverFox-Tools
# ——>	https://github.com/SilverFox-Tools
#
# 仓库: 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls
# ——>	https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls
#
# 许可证: MIT
# V0.2
# ============================================

@tool
class_name CustomWindow
extends Panel

var Node_WindowTitle : WindowTitle = WindowTitle.new ()

var Node_TitleBtn_Icon : TextureRect = TextureRect.new ()
var Node_TitleBtn_Minimize : Button = Button.new ()
var Node_TitleBtn_Maximize : Button = Button.new ()
var Node_TitleBtn_Close : Button = Button.new ()

enum RestrictMode {
	FREE = 0 ,
	PARENT = 1 ,
	VIEWPORT = 2,
}

var old_Position : Vector2

var DefaultTheme = ThemeDB.get_project_theme ()
var EditorTheme = ThemeDB.get_default_theme ()

#region 窗口 Window
@export_group ("窗口", "Window_")
@export var Window_Restrict_PositionMod : RestrictMode = 0 as RestrictMode
@export var Window_Restrict_Position : Vector4 = Vector4 (self.size.x / 2 , 0 , self.size.x / 2 , (self.size.y + Title_Height) / 2)

@export_tool_button ("默认设置 RestrictPosition") var RestrictPosition_resetBtn = Restrict_Position_reset
func Restrict_Position_reset () :
	var temp_Title_Height = 0
	if Window_Title :
		temp_Title_Height = Title_Height

	Window_Restrict_Position = Vector4 (self.size.x / 2 , 0 , self.size.x / 2 , (self.size.y + temp_Title_Height) / 2)

@export var Window_Title : bool = true :
	set (value) :
		Window_Title = value
		Node_WindowTitle.visible = value

@export var Window_Maximize : bool = false :
	set (value) :
		Window_Maximize = value
		Update_icon ()
#endregion


#region 标题栏 Title
@export_group ("标题栏", "Title_")
@export var Title_Height : int = 32 :
	set (value) :
		value = max (value , 0)
		Title_Height = value
		Node_WindowTitle.size.y = Title_Height
		Node_WindowTitle.position.y = -Node_WindowTitle.size.y

@export var Title_Title : String = "Title" :
	set (value) :
		Title_Title = value
		Node_WindowTitle.Title_Title = Title_Title

@export var Title_TextPosition : Vector2 = Vector2.ZERO :
	set (value) :
		Title_TextPosition = value
		if Node_WindowTitle :
			Node_WindowTitle.Title_Position = value

@export var Title_TextSize : Vector2 = Vector2 (self.size.x , Title_Height) :
	set (value) :
		Title_TextSize = value
		if Node_WindowTitle :
			Node_WindowTitle.Title_Size = value

@export_tool_button ("默认设置 TitleText Position and Size") var SetDefault_Title_Text_Btn = SetDefault_Title_Text
func SetDefault_Title_Text () :
	Title_TextPosition = Vector2 (4 , 4)
	Title_TextSize = Vector2 (self.size.x , Title_Height) - Title_TextPosition * 2
#endregion


@export_group ("标题栏按钮", "TitleBtn_")
@export var TitleBtn_Icon : bool = true
@export var TitleBtn_Minimize : bool = true :
	set (value) :
		TitleBtn_Minimize = value
		Node_TitleBtn_Minimize.visible = value
		Refresh_TitleBtn_btn_lit ()

@export var TitleBtn_Maximize : bool = false :
	set (value) :
		TitleBtn_Maximize = value
		Node_TitleBtn_Maximize.visible = value
		Refresh_TitleBtn_btn_lit ()

@export var TitleBtn_Close : bool = true :
	set (value) :
		TitleBtn_Close = value
		Node_TitleBtn_Close.visible = value
		Refresh_TitleBtn_btn_lit ()

@export var TitleBtn_IconSize : Vector2 = Vector2 (32 , 32)
@export var TitleBtn_IconPosition : Vector2 = Vector2.ZERO

@export var TitleBtn_BtnSize : Vector2 = Vector2 (32 , 32) :
	set (value) :
		TitleBtn_BtnSize = value
		Set_Node ()

@export var TitleBtn_BtnPosition : Vector2 = Vector2.ZERO :
	set (value) :
		TitleBtn_BtnPosition = value
		Set_Node ()

@export var TitleBtn_PositionMode : Enums.PositionMode = 1 as Enums.PositionMode :
	set (value) :
		TitleBtn_PositionMode = value
		Set_Node ()

@export var TitleBtn_BtnOrder : Array[int] = [2 , 1 , 0] :
	set (List) :
		List.resize (TitleBtn_btn_lit.size () )
		TitleBtn_BtnOrder = List
		Set_Node ()

var TitleBtn_btn_lit : Array

#region 再编辑器里初始化 Initialize in the editor
var _added_to_scene = false
var Engine_ready = false
var _Modify_theme = false

func _notification (what : int) :
	if what == NOTIFICATION_RESIZED and Engine.is_editor_hint () and Engine_ready :
		Set_Node ()
		#DropDown_Size = self.size
		#Calculate_DropDownBtn_Position ()

	if what == NOTIFICATION_POST_ENTER_TREE and not _added_to_scene :
		_added_to_scene = true

		if Node_WindowTitle and not Node_WindowTitle.is_inside_tree () :
			add_child (Node_WindowTitle)

			Node_WindowTitle.add_child (Node_TitleBtn_Icon)
			Node_TitleBtn_Icon.visible = TitleBtn_Icon
			Node_TitleBtn_Icon.name = "TitleBtn_Icon"

			Node_WindowTitle.add_child (Node_TitleBtn_Minimize)
			Node_TitleBtn_Minimize.visible = TitleBtn_Minimize
			Node_TitleBtn_Minimize.name = "minimize"
			Node_TitleBtn_Minimize.expand_icon = true
			Node_TitleBtn_Minimize.pressed.connect (_Minimize)

			Node_WindowTitle.add_child (Node_TitleBtn_Maximize)
			Node_TitleBtn_Maximize.visible = TitleBtn_Maximize
			Node_TitleBtn_Maximize.name = "maximize"
			Node_TitleBtn_Maximize.expand_icon = true
			Node_TitleBtn_Maximize.pressed.connect (_Maximize)

			Node_WindowTitle.add_child (Node_TitleBtn_Close)
			Node_TitleBtn_Close.visible = TitleBtn_Close
			Node_TitleBtn_Close.name = "close"
			Node_TitleBtn_Close.expand_icon = true
			Node_TitleBtn_Close.pressed.connect (_Close)

		Set_Node ()
		Set_Theme ()

		get_window ().size_changed.connect (apply_Position_Restrict)

	if what == NOTIFICATION_THEME_CHANGED and not _Modify_theme :
		Set_Theme ()
#endregion

func _ready () -> void :
	if Engine.is_editor_hint () :
		await get_tree ().process_frame
		Engine_ready = true

	Set_Theme ()

	Refresh_TitleBtn_btn_lit ()
	TitleBtn_BtnOrder = TitleBtn_BtnOrder

func _process (_delta : float) -> void :
	if position != old_Position :
		apply_Position_Restrict ()

	old_Position = self.position


func _Minimize () :
	self.visible = false

func _Maximize () :
	self.Window_Maximize = not Window_Maximize

func _Close () :
	self.queue_free ()


func Refresh_TitleBtn_btn_lit () :
	TitleBtn_btn_lit = []
	if TitleBtn_Minimize :
		TitleBtn_btn_lit.append (Node_TitleBtn_Minimize)
	if TitleBtn_Maximize :
		TitleBtn_btn_lit.append (Node_TitleBtn_Maximize)
	if TitleBtn_Close :
		TitleBtn_btn_lit.append (Node_TitleBtn_Close)
	TitleBtn_BtnOrder = TitleBtn_BtnOrder

func apply_Position_Restrict () :
	var temp_Title_Height = 0
	if Window_Title :
		temp_Title_Height = Title_Height

	var Parent_Size : Vector2
	match Window_Restrict_PositionMod :
		0 :
			return

		1 :
			Parent_Size = get_parent ().size

		2 :
			Parent_Size = get_viewport ().get_visible_rect ().size

	self.position.x = max (self.position.x , -Window_Restrict_Position.x)
	self.position.y = max (self.position.y , -Window_Restrict_Position.y + temp_Title_Height)
	self.position.x = min (self.position.x , Parent_Size.x - self.size.x + Window_Restrict_Position.z)
	self.position.y = min (self.position.y , Parent_Size.y - self.size.y + Window_Restrict_Position.w + temp_Title_Height)

func Set_Node () :
	Node_WindowTitle.size.x = self.size.x
	Node_WindowTitle.size.y = Title_Height
	Node_WindowTitle.position.x = 0
	Node_WindowTitle.position.y = -Node_WindowTitle.size.y

	Node_TitleBtn_Icon.position = TitleBtn_IconPosition

	var TitleBtn_Initial_position : Vector2 = Enums.Application_PositionMode (TitleBtn_PositionMode , self.size , TitleBtn_BtnSize * TitleBtn_btn_lit.size () , TitleBtn_BtnPosition)

	for temp_node : Button in TitleBtn_btn_lit :
		temp_node.size = TitleBtn_BtnSize

	var temp_TitleBtn_BtnOrder = TitleBtn_BtnOrder.duplicate ()
	for i in TitleBtn_btn_lit.size () :
		var temp_int = temp_TitleBtn_BtnOrder.find (temp_TitleBtn_BtnOrder.max () )
		temp_TitleBtn_BtnOrder[temp_int] = pow (2 , 31) * -1
		var temp_node : Button = TitleBtn_btn_lit[temp_int]

		temp_node.position = TitleBtn_Initial_position + Vector2 (TitleBtn_BtnSize.x , 0) * i


func Set_Theme () :
	_Modify_theme = true
	if not Node_WindowTitle.theme :
		Node_WindowTitle.theme = self.theme

	var style : StyleBox

	var temp_fallback_item = HandleTheme.FallbackItem.new ("panel" , "Panel")

	style = HandleTheme.get_style (theme , "window" , "CustomWindow" , [temp_fallback_item])
	if !style :
		style = HandleTheme.get_style (DefaultTheme , "window" , "CustomWindow" , [temp_fallback_item])
	if !style :
		style = HandleTheme.get_style (EditorTheme , temp_fallback_item.name , temp_fallback_item.theme_type)

	self.add_theme_stylebox_override ("panel", style)


	var styleboxlist = ["normal" , "hover" , "pressed" , "disabled" , "focus"]

	for temp_node : Button in [Node_TitleBtn_Minimize , Node_TitleBtn_Maximize , Node_TitleBtn_Close] :
		for name_stylebox in styleboxlist :
			var name_stylebox_2 = temp_node.name + "_" + name_stylebox

			var fallback_item_0 = HandleTheme.FallbackItem.new ("default_" + name_stylebox , "CustomWindow")
			var fallback_item_1 = HandleTheme.FallbackItem.new (name_stylebox , "Button")

			style = HandleTheme.get_style (theme , name_stylebox_2 , "CustomWindow" , [fallback_item_0 , fallback_item_1])
			if !style :
				style = HandleTheme.get_style (DefaultTheme , name_stylebox_2 , "CustomWindow" , [fallback_item_0 , fallback_item_1])
			if !style :
				style = HandleTheme.get_style (EditorTheme , fallback_item_1.name , fallback_item_1.theme_type)

			temp_node.add_theme_stylebox_override (name_stylebox , style)

		if temp_node.name == "maximize" :
			var temp_icon = HandleTheme.get_icon (theme , temp_node.name + "_icon" , "CustomWindow")
			if temp_icon :
				temp_node.add_theme_icon_override (temp_node.name + "_icon" , temp_icon)

			temp_icon = HandleTheme.get_icon (theme , temp_node.name + "_icon_restore" , "CustomWindow")
			if temp_icon :
				temp_node.add_theme_icon_override (temp_node.name + "_icon_restore" , temp_icon)

			Update_icon ()

		else :
			var temp_icon = HandleTheme.get_icon (theme , temp_node.name + "_icon" , "CustomWindow")
			temp_node.icon = temp_icon

	_Modify_theme = false

func Update_icon () :
	if Window_Maximize :
		Node_TitleBtn_Maximize.icon = Node_TitleBtn_Maximize.get_theme_icon ("maximize_icon_restore")
	else :
		Node_TitleBtn_Maximize.icon = Node_TitleBtn_Maximize.get_theme_icon ("maximize_icon")
