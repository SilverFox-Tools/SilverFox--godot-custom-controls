##============================================[br]
##Window 窗口[br]
##作者 :[br]
##——>	东方银狐 / DFYH / DF.SilverFox[br]
##———	——>	https://github.com/bilibiliDFYH[br]
##[br]
##组织 : 东方银狐的奇妙工具 / SilverFox-Tools[br]
##——>	https://github.com/SilverFox-Tools[br]
##[br]
##仓库 : 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls[br]
##——>	https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls[br]
##[br]
##许可证: MIT[br]
##V0.3[br]
##============================================[br]
##@tutorial(开发者 : 东方银狐 / DFYH / DF.SilverFox):https://github.com/bilibiliDFYH
##@tutorial(组织 : 东方银狐的奇妙工具 / SilverFox-Tools) : https://github.com/SilverFox-Tools
##@tutorial(仓库 : 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls) : https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls

@tool
class_name CustomWindow
extends Panel

#region Node
##标题栏Node , 类型为 [WindowTitle]
var Node_WindowTitle : WindowTitle = WindowTitle.new () 
#endregion

##标题栏位置[br]
##设置 [member Node_WindowTitle] 的位置
enum TitleEnum_Position {
	Up ,	## 在窗口上方 , 标题栏 高度 为 [member Title_Size]
	Down ,	## 在窗口下方 , 标题栏 宽度 为 [member Title_Size]
	Left ,	## 在窗口左方 , 标题栏 高度 为 [member Title_Size]
	Right ,	## 在窗口右方 , 标题栏 宽度 为 [member Title_Size]
}

#region 编辑器面板 窗口 Window
@export_group ("窗口", "Window_")
#endregion

#region 编辑器面板 标题栏 Title
@export_group ("标题栏", "Title_")
##标题栏的位置[br]
##使用 [enum TitleEnum_Position] 枚举[br]
##默认为在窗口上方
@export var Title_Position : TitleEnum_Position = TitleEnum_Position.Up :
	set (value) :
		Title_Position = value
		Set_Node_CustomWindow ("Title")
##在 [member Title_Position] 为 [enum TitleEnum_Position]的Up和Down时 , 作为标题栏的 高度[br]
##在 [member Title_Position] 为 [enum TitleEnum_Position]的Left和Right时 , 作为标题栏的 宽度
@export var Title_Size : int = 32 :
	set (value) :
		Title_Size = value
		Set_Node_CustomWindow ("Title")

##允许使用 [member Title_Theme]
@export var Title_AllowTheme : bool :
	set (value) :
		Title_AllowTheme = value
		Set_Theme_CustomWindow ("Title")
@export var Title_Theme : Theme :
	set (value) :
		Title_Theme = value
		Set_Theme_CustomWindow ("Title")

@export var Title_Text : String = "Title" :
	set (value) :
		Title_Text = value
		Node_WindowTitle.Title_Text = value
@export var Title_TextAlignment_Horizontal : HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT :
	set (value) :
		Title_TextAlignment_Horizontal = value
		Node_WindowTitle.Title_TextAlignment_Horizontal = value
@export var Title_TextAlignment_Vertical : VerticalAlignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER :
	set (value) :
		Title_TextAlignment_Vertical = value
		Node_WindowTitle.Title_TextAlignment_Vertical = value

@export var Title_TextPosition : Vector2 = Vector2 (32 , 4) :
	set (value) :
		Title_TextPosition = value
		Node_WindowTitle.Title_TextPosition = value
@export var Title_TextSize : Vector2 = Vector2 (64 , 24) :
	set (value) :
		Title_TextSize = value
		Node_WindowTitle.Title_TextSize = value
#endregion

#region 编辑器面板 标题栏物体 TitleNode
@export_group ("标题栏物体", "TitleNode_")
@export var TitleNode_Allow : Array[bool] = [true , true , true] :
	set (value) :
		TitleNode_Allow = value
		TitleNode_Allow.resize (Node_WindowTitle.TitleNode_BtnNumber)
		Node_WindowTitle.TitleNode_Allow = value
@export var TitleNode_Position : Array[Vector2] = [Vector2 (0 , 0) , Vector2 (24 , 0) , Vector2 (48 , 0)] :
	set (value) :
		TitleNode_Position = value
		TitleNode_Position.resize (Node_WindowTitle.TitleNode_BtnNumber)
		Node_WindowTitle.TitleNode_Position = value

@export var TitleNode_AllowIcon : bool = true :
	set (value) :
		TitleNode_AllowIcon = value
		Node_WindowTitle.TitleNode_AllowIcon = value
@export var TitleNode_Icon : Texture = null :
	set (value) :
		TitleNode_Icon = value
		Node_WindowTitle.TitleNode_Icon = value
@export var TitleNode_IconPosition : Vector2 = Vector2 (4 , 0) :
	set (value) :
		TitleNode_IconPosition = value
		Node_WindowTitle.TitleNode_IconPosition = value
@export var TitleNode_IconSize : Vector2 = Vector2 (24 , 24) :
	set (value) :
		TitleNode_IconSize = value
		Node_WindowTitle.TitleNode_IconSize = value
@export var TitleNode_Icon_PositionModeHorizontal : Enums.PositionMode_Horizontal = Enums.PositionMode_Horizontal.Left :
	set (value) :
		TitleNode_Icon_PositionModeHorizontal = value
		Node_WindowTitle.TitleNode_Icon_PositionModeHorizontal = value
@export var TitleNode_Icon_PositionModeVertical : Enums.PositionMode_Vertical = Enums.PositionMode_Vertical.Central :
	set (value) :
		TitleNode_Icon_PositionModeVertical = value
		Node_WindowTitle.TitleNode_Icon_PositionModeVertical = value


@export var TitleNode_BtnPosition : Vector2 = Vector2 (-4 , 0) :
	set (value) :
		TitleNode_BtnPosition = value
		Node_WindowTitle.TitleNode_BtnPosition = value
@export var TitleNode_BtnSize : Vector2 = Vector2 (24 , 24) :
	set (value) :
		TitleNode_BtnSize = value
		Node_WindowTitle.TitleNode_BtnSize = value
@export var TitleNode_Btn_PositionModeHorizontal : Enums.PositionMode_Horizontal = Enums.PositionMode_Horizontal.Right :
	set (value) :
		TitleNode_Btn_PositionModeHorizontal = value
		Node_WindowTitle.TitleNode_Btn_PositionModeHorizontal = value
@export var TitleNode_Btn_PositionModeVertical : Enums.PositionMode_Vertical = Enums.PositionMode_Vertical.Central :
	set (value) :
		TitleNode_Btn_PositionModeVertical = value
		Node_WindowTitle.TitleNode_Btn_PositionModeVertical = value
#endregion

#region 编辑器面板 主题覆盖 ThemeOverrides
@export_group ("主题覆盖", "ThemeOverrides_")
##允许使用 [member ThemeOverrides_Window]
@export var ThemeOverrides_Allow_Window : bool = false :
	set (value) :
		ThemeOverrides_Allow_Window = value
		Set_Theme_CustomWindow ("Window")
##StyleBox的覆盖 Window
@export var ThemeOverrides_Window : StyleBox :
	set (value) :
		ThemeOverrides_Window = value
		Set_Theme_CustomWindow ("Window")

@export_group ("主题覆盖 标题栏", "ThemeOverrides_")
##允许使用 [member ThemeOverrides_Title]
@export var ThemeOverrides_Allow_Title : bool = false :
	set (value) :
		ThemeOverrides_Allow_Title = value
		Node_WindowTitle.ThemeOverrides_Allow_Title = value
##StyleBox的覆盖 Title
@export var ThemeOverrides_Title : StyleBox :
	set (value) :
		ThemeOverrides_Title = value
		Node_WindowTitle.ThemeOverrides_Title = value

@export var ThemeOverrides_Allow_TitleFont : bool = false :
	set (value) :
		ThemeOverrides_Allow_TitleFont = value
		Node_WindowTitle.ThemeOverrides_Allow_TitleFont = ThemeOverrides_Allow_TitleFont
@export var ThemeOverrides_TitleFont : Font :
	set (value) :
		ThemeOverrides_TitleFont = value
		Node_WindowTitle.ThemeOverrides_TitleFont = ThemeOverrides_TitleFont

@export var ThemeOverrides_AllowButton : Dictionary[String , bool] = {
	"normal" : false ,
	"hover" : false ,
	"pressed" : false ,
	"disabled" : false ,
	"focus" : false
} :
	set (value) :
		ThemeOverrides_AllowButton = Node_WindowTitle.Handle_ThemeOverridesButton (value , false)
		Node_WindowTitle.ThemeOverrides_AllowButton = ThemeOverrides_AllowButton

@export var ThemeOverrides_Button : Dictionary[String , StyleBox] = {
	"normal" : null ,
	"hover" : null ,
	"pressed" : null ,
	"disabled" : null ,
	"focus" : null
} :
	set (value) :
		ThemeOverrides_Button = Node_WindowTitle.Handle_ThemeOverridesButton (value , null)
		Node_WindowTitle.ThemeOverrides_Button = ThemeOverrides_Button
#endregion

##重置CustomWindow的按钮
@export_tool_button ("重置CustomWindow") var ResetCustomWindow_Btn = ResetCustomWindow
func ResetCustomWindow () :
	for node in [
		Node_WindowTitle
		] :
		if node and node.is_inside_tree () :
			node.queue_free ()

	#region 重置node变量
	Node_WindowTitle = WindowTitle.new ()
	#endregion

	RefreshVariable_CustomWindow_to_WindowTitle ()
	Initialization_CustomWindow ()

##重置WindowTitle的按钮
@export_tool_button ("重置WindowTitle") var ResetWindowTitle_Btn = ResetWindowTitle
func ResetWindowTitle () :
	if Node_WindowTitle :
		RefreshVariable_CustomWindow_to_WindowTitle ()
		Node_WindowTitle.ResetWindowTitle ()


#region 初始化
var _AddedToScene_CustomWindow = false
var _ModifyTheme_CustomWindow = false
func _notification (what : int) :
	if what == NOTIFICATION_POST_ENTER_TREE and not _AddedToScene_CustomWindow :
		_AddedToScene_CustomWindow = true
		Initialization_CustomWindow ()

	if what == NOTIFICATION_RESIZED :
		Set_Node_CustomWindow ()

	if what == NOTIFICATION_THEME_CHANGED and not _ModifyTheme_CustomWindow :
		Set_Theme_CustomWindow ()

func Initialization_CustomWindow () :
	#region 初始化_实例化node
	add_child (Node_WindowTitle)
	#设置属性
	Node_WindowTitle.name = "Window Title"
	#endregion

	Set_Node_CustomWindow ()
	Set_Theme_CustomWindow ()
#endregion


func _ready () -> void :
	RefreshVariable_CustomWindow_to_WindowTitle ()


func Set_Node_CustomWindow (Type : String = "All") :
	match Type :
		#重绘
		"All" :
			Set_Node_CustomWindow ("Title")

		#标题栏
		"Title" :
			Node_WindowTitle.size = self.size
			match Title_Position :
				0 , 1 :
					Node_WindowTitle.size.y = Title_Size
					Node_WindowTitle.position.x = 0
				2 , 3 :
					Node_WindowTitle.size.x = Title_Size
					Node_WindowTitle.position.y = 0

			match Title_Position :
				0 :
					Node_WindowTitle.position.y = -Title_Size
				1 :
					Node_WindowTitle.position.y = self.size.y
				2 :
					Node_WindowTitle.position.x = -Title_Size
				3 :
					Node_WindowTitle.position.x = self.size.x


func Set_Theme_CustomWindow (Type : String = "All" , _temp : bool = true) :
	_ModifyTheme_CustomWindow = true
	match Type :
		"All" :
			pass
			Set_Theme_CustomWindow ("Window" , false)
			Set_Theme_CustomWindow ("Title" , false)

		"Window" :
			HandleTheme.apply_style (self , "panel" ,
				"window" , "CustomWindow" ,
				"panel" , "Panel" ,
				ThemeOverrides_Allow_Window , ThemeOverrides_Window)

		"Title" :
			if Title_AllowTheme and Title_Theme :
				Node_WindowTitle.theme = Title_Theme
			else :
				Node_WindowTitle.theme = self.theme

	if _temp :
		_ModifyTheme_CustomWindow = false


func RefreshVariable_CustomWindow_to_WindowTitle () :
	Set_Theme_CustomWindow ("Title")
	Node_WindowTitle.Title_Text								= Title_Text
	Node_WindowTitle.Title_TextAlignment_Horizontal			= Title_TextAlignment_Horizontal
	Node_WindowTitle.Title_TextAlignment_Vertical			= Title_TextAlignment_Vertical
	Node_WindowTitle.Title_TextPosition						= Title_TextPosition
	Node_WindowTitle.Title_TextSize							= Title_TextSize

	TitleNode_Allow.resize (Node_WindowTitle.TitleNode_BtnNumber)
	Node_WindowTitle.TitleNode_Allow						= TitleNode_Allow
	TitleNode_Position.resize (Node_WindowTitle.TitleNode_BtnNumber)
	Node_WindowTitle.TitleNode_Position						= TitleNode_Position

	Node_WindowTitle.TitleNode_AllowIcon					= TitleNode_AllowIcon
	Node_WindowTitle.TitleNode_Icon							= TitleNode_Icon
	Node_WindowTitle.TitleNode_IconPosition					= TitleNode_IconPosition
	Node_WindowTitle.TitleNode_IconSize						= TitleNode_IconSize
	Node_WindowTitle.TitleNode_Icon_PositionModeHorizontal	= TitleNode_Icon_PositionModeHorizontal
	Node_WindowTitle.TitleNode_Icon_PositionModeVertical	= TitleNode_Icon_PositionModeVertical

	Node_WindowTitle.TitleNode_BtnPosition					= TitleNode_BtnPosition
	Node_WindowTitle.TitleNode_BtnSize						= TitleNode_BtnSize
	Node_WindowTitle.TitleNode_Btn_PositionModeHorizontal	= TitleNode_Btn_PositionModeHorizontal
	Node_WindowTitle.TitleNode_Btn_PositionModeVertical		= TitleNode_Btn_PositionModeVertical

	Node_WindowTitle.ThemeOverrides_Allow_Title				= ThemeOverrides_Allow_Title
	Node_WindowTitle.ThemeOverrides_Title					= ThemeOverrides_Title

	Node_WindowTitle.ThemeOverrides_Allow_TitleFont			= ThemeOverrides_Allow_TitleFont
	Node_WindowTitle.ThemeOverrides_TitleFont				= ThemeOverrides_TitleFont

	Node_WindowTitle.ThemeOverrides_AllowButton = ThemeOverrides_AllowButton
	Node_WindowTitle.ThemeOverrides_Button = ThemeOverrides_Button
