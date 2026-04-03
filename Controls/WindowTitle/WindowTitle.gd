# ============================================
# WindowTitle 窗口标题栏
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
class_name WindowTitle
extends Panel

var Node_Parent : Control

var Mouse_Position : Vector2
var old_Mouse_Position : Vector2

var IsTouch : bool = false
var MousePressed : bool = false
var IsDrag : bool = false

var Parent_Position : Vector2

var Node_Text : Label = Label.new ()

@export var Title : String = "Title" :
	set (value) :
		Title = value
		if Node_Text :
			Node_Text.text = value

@export var Title_Position : Vector2 = Vector2.ZERO :
	set (value) :
		Title_Position = value
		if Node_Text :
			Node_Text.position = value

@export var Title_Size : Vector2 = self.size :
	set (value) :
		Title_Size = value
		if Node_Text :
			Node_Text.size = value

#region 再编辑器里初始化 Initialize in the editor
var _added_to_scene = false
var Engine_ready = false

func _notification (what : int) :
	#if what == NOTIFICATION_RESIZED and Engine.is_editor_hint () and Engine_ready :
		#Set_Node ()
		#DropDown_Size = self.size
		#Calculate_DropDownBtn_Position ()

	if what == NOTIFICATION_POST_ENTER_TREE and not _added_to_scene :
		_added_to_scene = true

		if Node_Text and not Node_Text.is_inside_tree () :
			add_child (Node_Text)
		Node_Text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		Node_Text.text = Title

		Set_Node ()

	#if what == NOTIFICATION_THEME_CHANGED and not _Modify_theme :
		#Set_Theme ()
#endregion

func _ready () -> void :
	if Engine.is_editor_hint () :
		await get_tree ().process_frame
		Engine_ready = true

	self.mouse_entered.connect (MouseEntered)
	self.mouse_exited.connect (MouseExited)

func _process (_delta : float) -> void :
	if not Node_Parent and self.is_inside_tree () :
		Node_Parent = get_parent ()

	if not Engine.is_editor_hint () :
		Mouse_Position = get_viewport ().get_mouse_position ()

		MousePressed = Input.is_mouse_button_pressed (MOUSE_BUTTON_LEFT) and (IsTouch or IsDrag)

		if IsTouch and MousePressed and not IsDrag :
			if Node_Parent :
				Parent_Position = Node_Parent.position
				old_Mouse_Position = Mouse_Position

		var Offset : Vector2 = Mouse_Position - old_Mouse_Position

		if (IsTouch or IsDrag) and MousePressed :
			IsDrag = true
			if Node_Parent :
				Node_Parent.position = Parent_Position + Offset
		if !MousePressed :
			IsDrag = false

func MouseEntered () :
	IsTouch = true

func MouseExited () :
	IsTouch = false

func Set_Node () :
	Node_Text.position = Title_Position
	Node_Text.size = Title_Size
