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
# V0.1
# ============================================

@tool
class_name CustomWindow
extends Panel

var Window_Title : WindowTitle = WindowTitle.new ()

enum RestrictMode {
	FREE = 0 ,
	PARENT = 1 ,
	VIEWPORT = 2,
}

var old_Position : Vector2

@export_group ("窗口", "Window_")
@export var Restrict_PositionMod : RestrictMode = 0 as RestrictMode
@export var Restrict_Position : Vector4 = Vector4 (self.size.x / 2 , 0 , self.size.x / 2 , (self.size.y + Title_Height) / 2)

@export_tool_button ("设置Restrict_Position为默认值") var RestrictPosition_resetBtn = Restrict_Position_reset
func Restrict_Position_reset () :
	Restrict_Position = Vector4 (self.size.x / 2 , 0 , self.size.x / 2 , (self.size.y + Title_Height) / 2)

@export_group ("标题栏", "Title_")
@export var Title_Height : int = 32 :
	set (value) :
		value = max (value , 0)
		Title_Height = value
		Window_Title.size.y = Title_Height
		Window_Title.position.y = -Window_Title.size.y

@export var Title_Title : String = "Title" :
	set (value) :
		Title_Title = value
		Window_Title.Title_Title = Title_Title

@export var Title_TextPosition : Vector2 = Vector2.ZERO :
	set (value) :
		Title_TextPosition = value
		if Window_Title :
			Window_Title.Title_Position = value

@export var Title_TextSize : Vector2 = Vector2 (self.size.x , Title_Height) :
	set (value) :
		Title_TextSize = value
		if Window_Title :
			Window_Title.Title_Size = value

#region 再编辑器里初始化 Initialize in the editor
var _added_to_scene = false
var Engine_ready = false

func _notification (what : int) :
	if what == NOTIFICATION_RESIZED and Engine.is_editor_hint () and Engine_ready :
		Set_Node ()
		#DropDown_Size = self.size
		#Calculate_DropDownBtn_Position ()

	if what == NOTIFICATION_POST_ENTER_TREE and not _added_to_scene :
		_added_to_scene = true

		if Window_Title and not Window_Title.is_inside_tree () :
			add_child (Window_Title)

		Set_Node ()

		get_window ().size_changed.connect (apply_Position_Restrict)
#endregion

func _ready () -> void :
	if Engine.is_editor_hint () :
		await get_tree ().process_frame
		Engine_ready = true
		Set_Node ()


func _process (_delta : float) -> void :
	if position != old_Position :
		apply_Position_Restrict ()

	old_Position = self.position

func apply_Position_Restrict () :
	var Parent_Size : Vector2
	match Restrict_PositionMod :
		0 :
			return

		1 :
			Parent_Size = get_parent ().size

		2 :
			Parent_Size = get_viewport ().get_visible_rect ().size

	self.position.x = max (self.position.x , -Restrict_Position.x)
	self.position.y = max (self.position.y , -Restrict_Position.y + Title_Height)
	self.position.x = min (self.position.x , Parent_Size.x - self.size.x + Restrict_Position.z)
	self.position.y = min (self.position.y , Parent_Size.y - self.size.y + Restrict_Position.w + Title_Height)

func Set_Node () :
	Window_Title.size.x = self.size.x
	Window_Title.size.y = Title_Height
	Window_Title.position.x = 0
	Window_Title.position.y = -Window_Title.size.y
