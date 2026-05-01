##============================================[br]
##WindowTitle 窗口标题栏
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
##V0.4[br]
##============================================[br]
##@tutorial(开发者 : 东方银狐 / DFYH / DF.SilverFox):https://github.com/bilibiliDFYH
##@tutorial(组织 : 东方银狐的奇妙工具 / SilverFox-Tools) : https://github.com/SilverFox-Tools
##@tutorial(仓库 : 银狐的 Godot 自定义控件 / SilverFox--godot-custom-controls) : https://github.com/SilverFox-Tools/SilverFox--godot-custom-controls

@tool
class_name WindowTitle
extends Panel

#region Node
##标题栏Node , 类型为 [WindowTitle]
var Node_Text : Label = Label.new () 
var Node_Parent : Control

var Node_Icon : TextureRect = TextureRect.new ()
var Node_Btn_Minimize : Button = Button.new ()
var Node_Btn_Maximize : Button = Button.new ()
var Node_Btn_Close : Button = Button.new ()
#endregion

var IsPressed : bool = false
var IsTouch : bool = false
var IsDrag : bool = false

var Mouse_Position : Vector2
var old_Mouse_Position : Vector2

var TitleNode_BtnNumber = 3
var TitleNode_NodeList : Array[Control] = [Node_Btn_Minimize , Node_Btn_Maximize , Node_Btn_Close]
var Btn_StyleTypeList : Array[String] = ["normal" , "hover" , "pressed" , "disabled" , "focus"]

#region 编辑器面板 标题栏 Title
@export_group ("标题栏", "Title_")
@export var Title_Text : String = "Title" :
	set (value) :
		Title_Text = value
		Node_Text.text = value
@export var Title_TextAlignment_Horizontal : HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT :
	set (value) :
		Title_TextAlignment_Horizontal = value
		Node_Text.horizontal_alignment = value
@export var Title_TextAlignment_Vertical : VerticalAlignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER :
	set (value) :
		Title_TextAlignment_Vertical = value
		Node_Text.vertical_alignment = value

@export var Title_TextPosition : Vector2 = Vector2 (32 , 4) :
	set (value) :
		Title_TextPosition = value
		Node_Text.position = value
@export var Title_TextSize : Vector2 = Vector2 (64 , 24) :
	set (value) :
		Title_TextSize = value
		Node_Text.size = value
#endregion

#region 编辑器面板 标题栏物体 TitleNode
@export_group ("标题栏物体", "TitleNode_")
@export var TitleNode_Allow : Array[bool] = [true , true , true] :
	set (value) :
		TitleNode_Allow = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_Position : Array[Vector2] = [Vector2 (0 , 0) , Vector2 (24 , 0) , Vector2 (48 , 0)] :
	set (value) :
		TitleNode_Position = value
		Set_Node_WindowTitle ("TitleNode")

@export var TitleNode_AllowIcon : bool = true :
	set (value) :
		TitleNode_AllowIcon = value
@export var TitleNode_IconPosition : Vector2 = Vector2 (4 , 4) :
	set (value) :
		TitleNode_IconPosition = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_IconSize : Vector2 = Vector2 (24 , 24) :
	set (value) :
		value.x = max (value.x , 0)
		value.y = max (value.y , 0)
		TitleNode_IconSize = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_Icon_PositionModeHorizontal : Enums.PositionMode_Horizontal = Enums.PositionMode_Horizontal.Left :
	set (value) :
		TitleNode_Icon_PositionModeHorizontal = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_Icon_PositionModeVertical : Enums.PositionMode_Vertical = Enums.PositionMode_Vertical.Central :
	set (value) :
		TitleNode_Icon_PositionModeVertical = value
		Set_Node_WindowTitle ("TitleNode")

@export var TitleNode_BtnPosition : Vector2 = Vector2 (-4 , 0) :
	set (value) :
		TitleNode_BtnPosition = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_BtnSize : Vector2 = Vector2 (24 , 24) :
	set (value) :
		value.x = max (value.x , 0)
		value.y = max (value.y , 0)
		TitleNode_BtnSize = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_Btn_PositionModeHorizontal : Enums.PositionMode_Horizontal = Enums.PositionMode_Horizontal.Right :
	set (value) :
		TitleNode_Btn_PositionModeHorizontal = value
		Set_Node_WindowTitle ("TitleNode")
@export var TitleNode_Btn_PositionModeVertical : Enums.PositionMode_Vertical = Enums.PositionMode_Vertical.Central :
	set (value) :
		TitleNode_Btn_PositionModeVertical = value
		Set_Node_WindowTitle ("TitleNode")
#endregion

#region 编辑器面板 主题覆盖 ThemeOverrides
@export_group ("主题覆盖", "ThemeOverrides_")
##允许使用 [member ThemeOverrides_Title]
@export var ThemeOverrides_Allow_Title : bool = false :
	set (value) :
		ThemeOverrides_Allow_Title = value
		Set_Theme_WindowTitle ("Title")
##StyleBox的覆盖 Title
@export var ThemeOverrides_Title : StyleBox :
	set (value) :
		ThemeOverrides_Title = value
		Set_Theme_WindowTitle ("Title")

@export var ThemeOverrides_Allow_TitleFont : bool = false :
	set (value) :
		ThemeOverrides_Allow_TitleFont = value
		Set_Theme_WindowTitle ("Title")
@export var ThemeOverrides_TitleFont : Font :
	set (value) :
		ThemeOverrides_TitleFont = value
		Set_Theme_WindowTitle ("Title")

@export var ThemeOverrides_AllowButton : Dictionary[String , bool] = {
	"normal" : false ,
	"hover" : false ,
	"pressed" : false ,
	"disabled" : false ,
	"focus" : false
} :
	set (value) :
		ThemeOverrides_AllowButton = Handle_ThemeOverridesButton (value , false)
		Set_Theme_WindowTitle ("Node")

@export var ThemeOverrides_Button : Dictionary[String , StyleBox] = {
	"normal" : null ,
	"hover" : null ,
	"pressed" : null ,
	"disabled" : null ,
	"focus" : null
} :
	set (value) :
		ThemeOverrides_Button = Handle_ThemeOverridesButton (value , null)
		Set_Theme_WindowTitle ("Node")
#endregion

##重置WindowTitle的按钮
@export_tool_button ("重置WindowTitle") var ResetWindowTitle_Btn = ResetWindowTitle
func ResetWindowTitle () :
	for node in [
		Node_Text , Node_Icon , Node_Btn_Minimize , Node_Btn_Maximize , Node_Btn_Close
		] :
		if node and node.is_inside_tree () :
			node.queue_free ()

	#region 重置node变量
	Node_Text = Label.new ()
	Node_Icon = TextureRect.new ()
	Node_Btn_Minimize = Button.new ()
	Node_Btn_Maximize = Button.new ()
	Node_Btn_Close = Button.new ()
	#endregion

	TitleNode_NodeList = [Node_Btn_Minimize , Node_Btn_Maximize , Node_Btn_Close]

	Initialization_WindowTitle ()


#region 初始化
var _AddedToScene_WindowTitle = false
var _ModifyTheme_WindowTitle = false
func _notification (what : int) :
	if what == NOTIFICATION_POST_ENTER_TREE and not _AddedToScene_WindowTitle :
		_AddedToScene_WindowTitle = true
		Initialization_WindowTitle ()

	if what == NOTIFICATION_RESIZED :
		Set_Node_WindowTitle ()

	if what == NOTIFICATION_THEME_CHANGED and not _ModifyTheme_WindowTitle :
		Set_Theme_WindowTitle ()

func Initialization_WindowTitle () :
	#region 初始化_实例化node
	add_child (Node_Text)
	add_child (Node_Icon)
	add_child (Node_Btn_Minimize)
	add_child (Node_Btn_Maximize)
	add_child (Node_Btn_Close)
	#设置属性
	Node_Text.name = "Text"
	Node_Icon.name = "Icon"
	Node_Btn_Minimize.name	= "Btn Minimize"
	Node_Btn_Maximize.name	= "Btn Maximize"
	Node_Btn_Close.name		= "Btn Close"
	#endregion

	Set_Node_WindowTitle ()
	Set_Theme_WindowTitle ()
#endregion


func _input (event : InputEvent) -> void :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		IsPressed = event.pressed and (IsTouch or IsDrag)


func _ready () -> void :
	Mouse_Position = get_viewport ().get_mouse_position ()
	old_Mouse_Position = Mouse_Position
	self.mouse_entered.connect (func () : IsTouch = true)
	self.mouse_exited.connect (func () : IsTouch = false)

func _process (_delta : float) -> void :
	Mouse_Position = get_viewport ().get_mouse_position ()
	if not Node_Parent and self.is_inside_tree () :
		Node_Parent = get_parent ()

	if not IsPressed :
		IsDrag = false

	if not IsDrag :
		if IsPressed and IsTouch :
			IsDrag = true

	if IsDrag and not old_Mouse_Position == Mouse_Position :
		var temp_Offset : Vector2 = Mouse_Position - old_Mouse_Position
		if Node_Parent :
			Node_Parent.position += temp_Offset

	old_Mouse_Position = Mouse_Position


func Set_Node_WindowTitle (Type : String = "All") :
	match Type :
		"All" :
			Set_Node_WindowTitle ("Title")
			Set_Node_WindowTitle ("TitleNode")

		"Title" :
			Node_Text.text = Title_Text
			Node_Text.horizontal_alignment = Title_TextAlignment_Horizontal
			Node_Text.vertical_alignment = Title_TextAlignment_Vertical
			Node_Text.position = Title_TextPosition
			Node_Text.size = Title_TextSize

		"TitleNode" :
			TitleNode_Allow.resize (TitleNode_BtnNumber)
			TitleNode_Position.resize (TitleNode_BtnNumber)

			var min_float : float = INF
			var temp_List_V2 : Array[Vector2] = []
			var max_pos : Vector2 = Vector2 (- min_float , - min_float)
			var min_pos : Vector2 = Vector2 (min_float , min_float)

			for i in TitleNode_BtnNumber :
				if TitleNode_Allow[i] :
					temp_List_V2.append (TitleNode_Position[i])
			for v2 in temp_List_V2 :
				max_pos.x = max (max_pos.x , v2.x) 
				max_pos.y = max (max_pos.y , v2.y) 
				min_pos.x = min (min_pos.x , v2.x) 
				min_pos.y = min (min_pos.y , v2.y) 
			max_pos += TitleNode_BtnSize - min_pos

			var temp_v2 : Vector2 = Enums.PositionMode_Application (
						TitleNode_Btn_PositionModeHorizontal ,
						TitleNode_Btn_PositionModeVertical ,
						self.size , max_pos , TitleNode_BtnPosition
						) - min_pos

			for i in TitleNode_BtnNumber :
				var node : Control = TitleNode_NodeList[i]
				if TitleNode_Allow[i] :
					node.size = TitleNode_BtnSize
					node.position = temp_v2 + TitleNode_Position[i]
					if node and self.is_inside_tree () and not node.is_inside_tree () :
						add_child (node)
				elif node and node.is_inside_tree () :
					remove_child (node)


func Set_Theme_WindowTitle (Type : String = "All" , _temp : bool = true) :
	_ModifyTheme_WindowTitle = true
	match Type :
		"All" :
			pass
			Set_Theme_WindowTitle ("Title" , false)
			Set_Theme_WindowTitle ("Node" , false)

		"Title" :
			HandleTheme.apply_style (self , "panel" ,
				"title" , "WindowTitle" ,
				"panel" , "Panel" ,
				ThemeOverrides_Allow_Title , ThemeOverrides_Title)

			HandleTheme.apply_font (Node_Text , "font" ,
				"font" , "WindowTitle" ,
				"font" , "Label" ,
				ThemeOverrides_Allow_TitleFont , ThemeOverrides_TitleFont ,
				self.theme)

		"Node" :
			for node : Control in TitleNode_NodeList :
				for i in Btn_StyleTypeList.size () :
					var type = Btn_StyleTypeList[i]
					HandleTheme.apply_style (node , type ,
						"button_" + type , "WindowTitle" ,
						type , "Button" ,
						ThemeOverrides_AllowButton[type] , ThemeOverrides_Button[type] ,
						self.theme)

	if _temp :
		_ModifyTheme_WindowTitle = false


func Handle_ThemeOverridesButton (dictionary : Dictionary , DefaultValue) :
	if DefaultValue is bool :
		var temp_Dictionary : Dictionary[String , bool] = {}
		for type in Btn_StyleTypeList :
			if dictionary.has (type) :
				temp_Dictionary[type] = dictionary[type]
			else :
				temp_Dictionary[type] = DefaultValue

		return temp_Dictionary

	else :
		var temp_Dictionary : Dictionary[String , StyleBox] = {}
		for type in Btn_StyleTypeList :
			if dictionary.has (type) :
				temp_Dictionary[type] = dictionary[type]
			else :
				temp_Dictionary[type] = DefaultValue

		return temp_Dictionary
