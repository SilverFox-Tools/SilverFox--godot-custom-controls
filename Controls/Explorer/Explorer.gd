# ============================================
# Explorer 文件资源管理器
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
class_name Explorer
extends CustomWindow

#region Node
##侧边栏_书签
var Node_SidebarText_Bookmark		: Label = Label.new ()
var Node_Sidebar_Bookmark			: ItemList = ItemList.new ()
##侧边栏_快速访问,获取系统的快速访问
var Node_SidebarText_QuickAccess	: Label = Label.new ()
var Node_Sidebar_QuickAccess		: ItemList = ItemList.new ()
##侧边栏_卷,获取所有卷(硬盘分区)
var Node_SidebarText_Volume			: Label = Label.new ()
var Node_Sidebar_Volume				: ItemList = ItemList.new ()
##侧边栏_最近打开
var Node_SidebarText_RecentFolders	: Label = Label.new ()
var Node_Sidebar_RecentFolders		: ItemList = ItemList.new ()


##文件名
var Node_FileName	: LineEdit = LineEdit.new ()
##文件路径
var Node_FilePath	: LineEdit = LineEdit.new ()


##上一个文件夹
var Node_btn_Previous			: Button = Button.new ()
##下一个文件夹
var Node_btn_Next				: Button = Button.new ()
##父级文件夹
var Node_btn_ParentDirectory	: Button = Button.new ()
##刷新
var Node_btn_Refresh			: Button = Button.new ()
##新建文件夹
var Node_btn_NewFolder			: Button = Button.new ()

var Node_DisplayPanel : Panel = Panel.new ()
#endregion

var old_FilePath : Array[String] = [] :
	set (list) :
		var Paths : Array[String] = []

		for i in list.size () :
			var temp_str : String = list[i]

			var j = 0
			while true :
				if j >= Paths.size () :
					break

				if Paths[j].to_lower () == temp_str.to_lower () :
					Paths.remove_at (j)
					j -= 1

				j += 1

			Paths.append (temp_str)

		while Paths.size () > 32 :
			Paths.remove_at (0)

		old_FilePath = Paths

var List_Volume : Array[String] = []

enum ExplorerEnum_DisplayMode {
	List ,	## 列表
	Icon ,	## 图标
}

#region 编辑器面板 文件资源管理器 Explorer
@export_group ("文件资源管理器", "Explorer_")

@export var Explorer_Translation : Dictionary = {
	"SidebarText-Bookmark"		: "书签 :" ,
	"SidebarText-QuickAccess"	: "快速访问 :" ,
	"SidebarText-Volume"		: "卷 :" ,
	"SidebarText-RecentFolders"	: "最近打开 :"} :
	set (dictionary) :
		Explorer_Translation = dictionary
		Set_Node_Explorer ("Sidebar")

@export var Explorer_DisplayMode : ExplorerEnum_DisplayMode = 0 as ExplorerEnum_DisplayMode

##显示面板_内容边距
@export var Explorer_DisplayPanel_Margin : float = 8 :
	set (value) :
		value = max (0 , value)
		Explorer_DisplayPanel_Margin = value
		Set_Node_Explorer ("DisplayPanel")
#endregion

#region 编辑器面板 侧边栏 Sidebar
@export_group ("侧边栏", "Sidebar_")
##侧边栏_宽度
@export var Sidebar_Width : float = 160 :
	set (value) :
		value = max (0 , value)
		Sidebar_Width = value
		Set_Node_Explorer ("Sidebar")
		Set_Node_Explorer ("Toolbar")
##侧边栏_内容边距
@export var Sidebar_Margin : float = 8 :
	set (value) :
		value = max (0 , value)
		Sidebar_Margin = value
		Set_Node_Explorer ("Sidebar")

##侧边栏_文本高度
@export var Sidebar_LabelHeight	: float = 24
##侧边栏_书签_内容高度
@export var Sidebar_BookmarkHeight		: float = 32 :
	set (value) :
		value = max (0 , value)
		Sidebar_BookmarkHeight = value
		SetSidebar_NodeHeight (0)
##侧边栏_快速访问_内容高度
@export var Sidebar_QuickAccessHeight	: float = 32 :
	set (value) :
		value = max (0 , value)
		Sidebar_QuickAccessHeight = value
		SetSidebar_NodeHeight (1)
##侧边栏_卷_内容高度
@export var Sidebar_VolumeHeight		: float = 32 :
	set (value) :
		value = max (0 , value)
		Sidebar_VolumeHeight = value
		SetSidebar_NodeHeight (2)
##侧边栏_最近打开_内容高度
@export var Sidebar_RecentFoldersHeight	: float = 32 :
	set (value) :
		value = max (0 , value)
		Sidebar_RecentFoldersHeight = value
		SetSidebar_NodeHeight (3)

var _bool_Editing_SidebarNodeHeight = false
func SetSidebar_NodeHeight (Number : int) :
	if _bool_Editing_SidebarNodeHeight :
		return

	_bool_Editing_SidebarNodeHeight = true
	var temp_list = [Sidebar_BookmarkHeight , Sidebar_QuickAccessHeight , Sidebar_VolumeHeight , Sidebar_RecentFoldersHeight]
	var temp_float = 0.0
	for i in temp_list.size () :
		if i == Number : continue
		temp_float += temp_list[i]

	temp_float = self.size.y - temp_float - Sidebar_Margin * 2 - Sidebar_LabelHeight * 4
	temp_list[Number] = min (temp_list[Number] , max (0 , temp_float) )

	match Number :
		0 :
			Sidebar_BookmarkHeight = temp_list[Number]
		1 :
			Sidebar_QuickAccessHeight = temp_list[Number]
		2 :
			Sidebar_VolumeHeight = temp_list[Number]
		3 :
			Sidebar_RecentFoldersHeight = temp_list[Number]

	_bool_Editing_SidebarNodeHeight = false
	Set_Node_Explorer ("Sidebar")
#endregion

#region 编辑器面板 工具栏 Toolbar
@export_group ("工具栏", "Toolbar_")
##工具栏_高度
@export var Toolbar_Height : float = 48 :
	set (value) :
		value = max (0 , value)
		Toolbar_Height = value
		Set_Node_Explorer ("Toolbar")
##工具栏_内容边距
@export var Toolbar_Margin : float = 8 :
	set (value) :
		value = max (0 , value)
		Toolbar_Margin = value
		Set_Node_Explorer ("Toolbar")

##工具栏_按钮大小
@export var Toolbar_ButtonSize : Vector2 = Vector2 (24 , 24) :
	set (value) :
		Toolbar_ButtonSize = value
		Set_Node_Explorer ("Toolbar")
##工具栏_按钮距离
@export var Toolbar_ButtonDistance : float = 2 :
	set (value) :
		Toolbar_ButtonDistance = value
		Set_Node_Explorer ("Toolbar")

##工具栏_路径输入框位置
@export var Toolbar_FilePath_Position : float = 4 :
	set (value) :
		Toolbar_FilePath_Position = value
		Set_Node_Explorer ("Toolbar")
#endregion

@export_tool_button ("重置Explorer") var ResetExplorer_Btn = ResetExplorer
func ResetExplorer () :
	for node in [
		Node_SidebarText_Bookmark , Node_SidebarText_QuickAccess , Node_SidebarText_Volume , Node_SidebarText_RecentFolders ,
		Node_Sidebar_Bookmark , Node_Sidebar_QuickAccess , Node_Sidebar_Volume , Node_Sidebar_RecentFolders ,
		Node_btn_Previous , Node_btn_Next , Node_btn_ParentDirectory , Node_btn_Refresh , Node_btn_NewFolder , Node_FilePath ,
		Node_DisplayPanel
		] :
		if node and node.is_inside_tree () :
			node.queue_free ()

	#region 重置node变量
	Node_SidebarText_Bookmark		= Label.new ()
	Node_SidebarText_QuickAccess	= Label.new ()
	Node_SidebarText_Volume			= Label.new ()
	Node_SidebarText_RecentFolders	= Label.new ()

	Node_Sidebar_Bookmark		= ItemList.new ()
	Node_Sidebar_QuickAccess	= ItemList.new ()
	Node_Sidebar_Volume			= ItemList.new ()
	Node_Sidebar_RecentFolders	= ItemList.new ()

	Node_btn_Previous			= Button.new ()
	Node_btn_Next				= Button.new ()
	Node_btn_ParentDirectory	= Button.new ()
	Node_btn_Refresh			= Button.new ()
	Node_btn_NewFolder			= Button.new ()

	Node_FilePath	= LineEdit.new ()

	Node_DisplayPanel	= Panel.new ()
	#endregion

	old_FilePath = []

	Initialization_Explorer ()


#region 初始化
var _AddedToScene_Explorer = false
func _notification (what : int) :
	if what == NOTIFICATION_POST_ENTER_TREE and not _AddedToScene_Explorer :
		_AddedToScene_Explorer = true
		Initialization_Explorer ()

	if what == NOTIFICATION_RESIZED :
		Set_Node_Explorer ()

func Initialization_Explorer () :
	#region 初始化_实例化node
	add_child (Node_SidebarText_Bookmark)
	add_child (Node_SidebarText_QuickAccess)
	add_child (Node_SidebarText_Volume)
	add_child (Node_SidebarText_RecentFolders)
	add_child (Node_Sidebar_Bookmark)
	add_child (Node_Sidebar_QuickAccess)
	add_child (Node_Sidebar_Volume)
	add_child (Node_Sidebar_RecentFolders)

	add_child (Node_btn_Previous)
	add_child (Node_btn_Next)
	add_child (Node_btn_ParentDirectory)
	add_child (Node_btn_Refresh)
	add_child (Node_btn_NewFolder)

	add_child (Node_FilePath)

	add_child (Node_DisplayPanel)
	#设置属性
	Node_SidebarText_Bookmark.		name = "Sidebar Bookmark Label"
	Node_SidebarText_QuickAccess.	name = "Sidebar QuickAccess Label"
	Node_SidebarText_Volume.		name = "Sidebar Volume Label"
	Node_SidebarText_RecentFolders.	name = "Sidebar RecentFolders Label"
	Node_Sidebar_Bookmark.		name = "Sidebar Bookmark"
	Node_Sidebar_QuickAccess.	name = "Sidebar QuickAccess"
	Node_Sidebar_Volume.		name = "Sidebar Volume"
	Node_Sidebar_RecentFolders.	name = "Sidebar RecentFolders"


	Node_btn_Previous.			name = "Previous Btn"
	Node_btn_Next.				name = "Next Btn"
	Node_btn_ParentDirectory.	name = "ParentDirectory Btn"
	Node_btn_Refresh.			name = "Refresh Btn"
	Node_btn_NewFolder.			name = "NewFolder Btn"

	Node_FilePath.name = "FilePath"

	Node_DisplayPanel.name = "DisplayPanel"
	#绑定函数
	Node_Sidebar_Volume.item_selected.connect (Sidebar_SwitchPath.bind ("volume") )

	Node_FilePath.text_submitted.connect (FilePath_InputComplete)
	Node_FilePath.focus_exited.connect (FilePath_InputComplete)
	#endregion

	Set_Node_Explorer ()
	RefreshDisplay ()
#endregion

func _ready () -> void :
	FilePath_InputComplete ()
	RefreshDisplay ()

##编辑路径
func FilePath_InputComplete (_new_text : String = "") -> void :
	var FilePath = HandlePath.StandardizedPath (Node_FilePath.text)

	if old_FilePath.size () >= 1 and FilePath.to_lower () == old_FilePath[old_FilePath.size () - 1].to_lower () :
		return

	if not DirAccess.dir_exists_absolute (FilePath) :
		if old_FilePath.size () < 1 :
			FilePath = OS.get_system_dir (OS.SYSTEM_DIR_DOCUMENTS)
		else :
			var old_Path = old_FilePath[old_FilePath.size () - 1]
			if not DirAccess.dir_exists_absolute (old_Path) :
				old_Path = OS.get_system_dir (OS.SYSTEM_DIR_DOCUMENTS)
				old_FilePath.remove_at (old_FilePath.size () - 1)

			FilePath = old_Path

	Node_FilePath.text = FilePath
	old_FilePath.append (FilePath)
	RefreshDisplay ()


func Set_Node_Explorer (Type : String = "All") :
	match Type :
		#重绘
		"All" :
			Set_Node_Explorer ("Sidebar")
			Set_Node_Explorer ("Toolbar")
			Set_Node_Explorer ("DisplayPanel")

		#侧边栏
		"Sidebar" :
			var temp_List : Array = [
				{"Node" : Node_SidebarText_Bookmark			, "Height" : Sidebar_LabelHeight	, "Text" : Explorer_Translation["SidebarText-Bookmark"]} ,
				{"Node" : Node_Sidebar_Bookmark				, "Height" : Sidebar_BookmarkHeight} ,

				{"Node" : Node_SidebarText_QuickAccess		, "Height" : Sidebar_LabelHeight	, "Text" : Explorer_Translation["SidebarText-QuickAccess"]} ,
				{"Node" : Node_Sidebar_QuickAccess			, "Height" : Sidebar_QuickAccessHeight} ,

				{"Node" : Node_SidebarText_Volume			, "Height" : Sidebar_LabelHeight	, "Text" : Explorer_Translation["SidebarText-Volume"]} ,
				{"Node" : Node_Sidebar_Volume				, "Height" : Sidebar_VolumeHeight} ,

				{"Node" : Node_SidebarText_RecentFolders	, "Height" : Sidebar_LabelHeight	, "Text" : Explorer_Translation["SidebarText-RecentFolders"]} ,
				{"Node" : Node_Sidebar_RecentFolders		, "Height" : Sidebar_RecentFoldersHeight}
				]

			var temp_float = 0
			for temp_Dictionary : Dictionary in temp_List :
				var node : Control = temp_Dictionary["Node"]
				var Height : float = temp_Dictionary["Height"]
				node.size.x = Sidebar_Width - Sidebar_Margin * 2
				node.size.y = Height
				node.position.x = Sidebar_Margin
				node.position.y = Sidebar_Margin + temp_float
				if temp_Dictionary.has ("Text") :
					node.text = temp_Dictionary["Text"]
				temp_float += Height

		#工具栏
		"Toolbar" :
			var temp_Vec2 = Vector2 (Sidebar_Width + Toolbar_Margin , Toolbar_Margin)
			var temp_Int_0 = Toolbar_Height - Toolbar_Margin * 2
			for node : Button in [Node_btn_Previous , Node_btn_Next , Node_btn_ParentDirectory , Node_btn_Refresh , Node_btn_NewFolder] :
				if node :
					node.position = temp_Vec2
					node.position.y += (temp_Int_0 - Toolbar_ButtonSize.y) / 2
					node.size = Toolbar_ButtonSize
				temp_Vec2.x += Toolbar_ButtonSize.x + Toolbar_ButtonDistance
			temp_Vec2.x -= Toolbar_ButtonDistance

			if Node_FilePath and Node_FilePath.is_inside_tree () :
				Node_FilePath.position = temp_Vec2 + Vector2 (Toolbar_FilePath_Position , 0)
				Node_FilePath.size.x = self.size.x - Node_FilePath.position.x - Toolbar_Margin
				Node_FilePath.size.y = temp_Int_0

		#面板
		"DisplayPanel" :
			Node_DisplayPanel.position.x = Sidebar_Width + Explorer_DisplayPanel_Margin
			Node_DisplayPanel.position.y = Toolbar_Height + Explorer_DisplayPanel_Margin
			Node_DisplayPanel.size = self.size - Node_DisplayPanel.position - Vector2 (Explorer_DisplayPanel_Margin , Explorer_DisplayPanel_Margin)


var Files_and_Dirs = []

##刷新
func RefreshDisplay () :
	#region 侧边栏
	#侧边栏_卷
	Node_Sidebar_Volume.clear ()
	List_Volume.clear ()
	var drive_count = DirAccess.get_drive_count ()
	for i in drive_count :
		var drive_name = DirAccess.get_drive_name (i)
		Node_Sidebar_Volume.add_item (drive_name + "/")
		List_Volume.append (drive_name + "/")
	#endregion

	#region 面板
	for child in Node_DisplayPanel.get_children () :
		child.queue_free ()

	var dir = DirAccess.open (Node_FilePath.text)

	var files = []
	var directories = []
	dir.list_dir_begin ()
	var item = dir.get_next ()
	while item != "" :
		if item != "." and item != ".." :
			if dir.current_is_dir () :
				directories.append (item)
			else:
				files.append (item)
		item = dir.get_next ()
	dir.list_dir_end()

	Files_and_Dirs = []
	for temp_dir in directories :
		Files_and_Dirs.append ({"Name" : temp_dir , "Type" : "Dir"})
	for temp_file in files :
		Files_and_Dirs.append ({"Name" : temp_file , "Type" : "File"})

	match Explorer_DisplayMode :
		0 :
			var temp_List = ItemList.new ()
			temp_List.fixed_icon_size = Vector2 (24 , 24)
			temp_List.size = Node_DisplayPanel.size
			temp_List.select_mode = ItemList.SELECT_MULTI

			for temp_item : String in directories :
					temp_List.add_item (temp_item , load ("res://Demo Theme/Explorer/icon_directory.svg"))

			for temp_item : String in files :
				var temp_icon = null
				match temp_item.get_extension ().to_lower () :
					"png" , "jpg" , "jpeg" , "gif" , "webp" , "bmp" , "pcx" , "ico" :
						temp_icon = load ("res://Demo Theme/Explorer/icon_texture.svg")

					"txt" , "ini" , "odt" , "xlsx" , "json" :
						temp_icon = load ("res://Demo Theme/Explorer/icon_document.svg")

					"7z" , "zip" , "rar" :
						temp_icon = load ("res://Demo Theme/Explorer/icon_compressed.svg")

					_ :
						match temp_item.get_basename ().get_extension ().to_lower () :
							"7z" , "zip" , "rar" :
								temp_icon = load ("res://Demo Theme/Explorer/icon_compressed.svg")

							_ :
								temp_icon = load ("res://Demo Theme/Explorer/icon_file.svg")

				temp_List.add_item (temp_item , temp_icon)

			temp_List.item_activated.connect (DoubleClick_FileOrDir)
			Node_DisplayPanel.add_child (temp_List)
	#endregion

func Sidebar_SwitchPath (Index : int , Type : String) :
	match Type :
		"volume" :
			Node_FilePath.text = List_Volume[Index]
			FilePath_InputComplete ()


func DoubleClick_FileOrDir (Index : int) :
	if Files_and_Dirs[Index].Type == "Dir" :
		Node_FilePath.text += "/" + Files_and_Dirs[Index].Name
		FilePath_InputComplete ()
