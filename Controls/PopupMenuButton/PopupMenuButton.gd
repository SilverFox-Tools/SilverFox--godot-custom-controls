# ============================================
# PopupMenuButton 弹出菜单
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
# V1.0
# ============================================

@tool
class_name PopupMenuButton
extends Button

const DefaultSize_MenuButton = Vector2 (128 , 32)

#region 弹出菜单按钮 MenuBTN_
@export_group ("弹出菜单按钮", "MenuBTN_")
@export var MenuBTN_Size : Vector2 = DefaultSize_MenuButton :
	set (value) :
		if value.x < 0 :
			value.x = DefaultSize_MenuButton.x
		if value.y < 0 :
			value.y = DefaultSize_MenuButton.y

		MenuBTN_Size = value
		self.size = MenuBTN_Size
@export var MenuBTN_Popup : bool = false
#endregion

@export_group ("弹出菜单选项", "PopupMenuItem_")
@export var PopupMenuItem_Item = []


#region 初始化
var _AddedToScene_MenuButton = false
var _Modify_theme = false
var IsEditor = false

func _notification (what : int) :
	if what == NOTIFICATION_POST_ENTER_TREE and not _AddedToScene_MenuButton :
		_AddedToScene_MenuButton = true
		Initialization_MenuButton ()

	if what == NOTIFICATION_RESIZED and IsEditor :
		MenuBTN_Size = self.size

func Initialization_MenuButton () :
	text_overrun_behavior = TextServer.OVERRUN_TRIM_CHAR

	#region 初始化_实例化node
	#add_child (Node_SidebarText_Bookmark)
	#add_child (Node_SidebarText_QuickAccess)
	#add_child (Node_SidebarText_Volume)
	#add_child (Node_SidebarText_RecentFolders)
	#add_child (Node_Sidebar_Bookmark)
	#add_child (Node_Sidebar_QuickAccess)
	#add_child (Node_Sidebar_Volume)
	#add_child (Node_Sidebar_RecentFolders)
#
	#add_child (Node_btn_Previous)
	#add_child (Node_btn_Next)
	#add_child (Node_btn_ParentDirectory)
	#add_child (Node_btn_Refresh)
	#add_child (Node_btn_NewFolder)
#
	#add_child (Node_FilePath)
#
	#add_child (Node_DisplayPanel)
	#设置属性
	#Node_SidebarText_Bookmark.		name = "Sidebar Bookmark Label"
	#Node_SidebarText_QuickAccess.	name = "Sidebar QuickAccess Label"
	#Node_SidebarText_Volume.		name = "Sidebar Volume Label"
	#Node_SidebarText_RecentFolders.	name = "Sidebar RecentFolders Label"
	#Node_Sidebar_Bookmark.		name = "Sidebar Bookmark"
	#Node_Sidebar_QuickAccess.	name = "Sidebar QuickAccess"
	#Node_Sidebar_Volume.		name = "Sidebar Volume"
	#Node_Sidebar_RecentFolders.	name = "Sidebar RecentFolders"
#
#
	#Node_btn_Previous.			name = "Previous Btn"
	#Node_btn_Next.				name = "Next Btn"
	#Node_btn_ParentDirectory.	name = "ParentDirectory Btn"
	#Node_btn_Refresh.			name = "Refresh Btn"
	#Node_btn_NewFolder.			name = "NewFolder Btn"

	#Node_FilePath.name = "FilePath"

	#Node_DisplayPanel.name = "DisplayPanel"
	#绑定函数
	#Node_Sidebar_Volume.item_selected.connect (Sidebar_SwitchPath.bind ("volume") )

	#Node_FilePath.text_submitted.connect (FilePath_InputComplete)
	#Node_FilePath.focus_exited.connect (FilePath_InputComplete)
	#endregion

	#Set_Node_Explorer ()
	#RefreshDisplay ()
#endregion

func _ready () -> void :
	if Engine.is_editor_hint () :
		await get_tree ().process_frame
		IsEditor = true

	self.size = MenuBTN_Size
