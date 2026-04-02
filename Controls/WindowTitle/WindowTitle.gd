# ============================================
# WindowTitle 窗口标题栏
# 作者:
# ——>	东方银狐 / DFYH / DF.SilverFox
# ———	——>	https://github.com/bilibiliDFYH
#
# 组织: 东方银狐的奇妙工具 / SilverFox-Tools
# ——>	https://github.com/SilverFox-Tools
#
# 窗口: 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls
# ——>	https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls
#
# 许可证: MIT
# V0.1
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

func _ready () -> void :
	self.mouse_entered.connect (MouseEntered)
	self.mouse_exited.connect (MouseExited)

func _process (_delta : float) -> void :
	if not Node_Parent and self.is_inside_tree () :
		Node_Parent = get_parent ()

	if not Engine.is_editor_hint () :
		Mouse_Position = DisplayServer.mouse_get_position ()

		#偏移,鼠标位置 和 old_鼠标位置 的距离差
		var Offset : Vector2 = Mouse_Position - old_Mouse_Position

		MousePressed = Input.is_mouse_button_pressed (MOUSE_BUTTON_LEFT)

		#当 鼠标触碰 or 正在拖拽 时,并且 鼠标按下 and 偏移不为零
		if (IsTouch or IsDrag) and MousePressed and Offset != Vector2.ZERO :
			IsDrag = true
			if Node_Parent :
				Node_Parent.position += Vector2 (Offset)
		if !MousePressed :
			IsDrag = false

		old_Mouse_Position = Mouse_Position

func MouseEntered () :
	IsTouch = true

func MouseExited () :
	IsTouch = false
