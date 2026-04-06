@tool
extends Tree

var update_timer: float = 0.0
var ignore_path: NodePath = NodePath("/root/Control/Insignificant")
var collapsed_state: Dictionary = {}
var visible_icon: Texture2D
var hidden_icon: Texture2D

func _ready() -> void:
	columns = 3
	set_column_title(0, "节点")      # 原来是 "可见"
	set_column_title(1, "类型")      # 原来是 "节点"
	set_column_title(2, "可见")      # 原来是 "类型"
	column_titles_visible = true
	
	set_column_custom_minimum_width(2, 24)  # 可见列固定宽度
	set_column_expand(2, false)
	
	hide_root = true
	
	_create_icons()
	refresh_tree()

func _create_icons() -> void:
	# 可见图标：实心白色圆角正方形
	visible_icon = _create_rounded_rect_icon(16, Color.WHITE, true)
	
	# 隐藏图标：空心白色圆角正方形
	hidden_icon = _create_rounded_rect_icon(16, Color.WHITE, false)

func _create_rounded_rect_icon(size: int, color: Color, filled: bool) -> Texture2D:
	var img = Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	
	var radius = size / 4  # 圆角半径
	var rect_min = radius
	var rect_max = size - radius - 1
	
	for x in range(size):
		for y in range(size):
			# 计算到四个角的距离
			var dx = 0.0
			var dy = 0.0
			var in_corner = false
			
			# 左上角
			if x < radius and y < radius:
				dx = x - radius
				dy = y - radius
				in_corner = true
			# 右上角
			elif x >= size - radius and y < radius:
				dx = x - (size - radius - 1)
				dy = y - radius
				in_corner = true
			# 左下角
			elif x < radius and y >= size - radius:
				dx = x - radius
				dy = y - (size - radius - 1)
				in_corner = true
			# 右下角
			elif x >= size - radius and y >= size - radius:
				dx = x - (size - radius - 1)
				dy = y - (size - radius - 1)
				in_corner = true
			
			if in_corner:
				# 在圆角区域
				if dx*dx + dy*dy <= radius*radius:
					if filled:
						img.set_pixel(x, y, color)
					else:
						img.set_pixel(x, y, color)
				else:
					# 圆角外部保持透明
					pass
			else:
				# 在矩形主体区域
				if x >= rect_min and x <= rect_max and y >= rect_min and y <= rect_max:
					if filled:
						img.set_pixel(x, y, color)
					else:
						# 空心：只画边框
						if x == rect_min or x == rect_max or y == rect_min or y == rect_max:
							img.set_pixel(x, y, color)
						else :
							img.set_pixel(x, y, Color.BLACK)
	
	return ImageTexture.create_from_image(img)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		update_timer += delta
		if update_timer >= 0.5:
			update_timer = 0.0
			refresh_tree()

func refresh_tree() -> void:
	var current_root = get_root()
	if current_root:
		var first_child = current_root.get_first_child()
		if first_child:
			_save_collapsed_state(first_child)
	
	clear()
	
	var scene_root = get_tree().root
	_add_node_to_tree(null, scene_root)
	
	var new_root = get_root()
	if new_root:
		var first_child = new_root.get_first_child()
		if first_child:
			_restore_collapsed_state(first_child)

func _save_collapsed_state(item: TreeItem) -> void:
	if not item:
		return
	
	var node_path = item.get_metadata(0)
	if node_path is String:
		collapsed_state[node_path] = item.is_collapsed()
	
	_save_collapsed_state(item.get_first_child())
	_save_collapsed_state(item.get_next())

func _restore_collapsed_state(item: TreeItem) -> void:
	if not item:
		return
	
	var node_path = item.get_metadata(0)
	if node_path is String and collapsed_state.has(node_path):
		item.set_collapsed(collapsed_state[node_path])
	
	_restore_collapsed_state(item.get_first_child())
	_restore_collapsed_state(item.get_next())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# 获取鼠标在 Tree 控件内的局部坐标
			var local_pos = get_local_mouse_position()
			
			# 检查是否在 Tree 范围内
			if local_pos.x < 0 or local_pos.x > size.x or local_pos.y < 0 or local_pos.y > size.y:
				return
			
			# 获取点击位置的 TreeItem 和列
			var item = get_item_at_position(local_pos)
			if not item:
				print("[Tree] 没有点击到任何 TreeItem")
				return
			
			var column = get_column_at_position(local_pos)
			print("[Tree] 点击列: ", column, " 节点名称: ", item.get_text(0))  # 节点名称在第0列
			
			# 只有点击第2列（图标列）才处理
			if column == 2:
				var node_path_str = item.get_metadata(0)
				if not node_path_str is String:
					print("[Tree] metadata 不是字符串: ", node_path_str)
					return
				
				print("[Tree] 目标路径: ", node_path_str)
				
				# 通过路径获取实际节点
				var target_node = _get_node_from_path(node_path_str)
				if not target_node or not is_instance_valid(target_node):
					print("[Tree] 无法获取节点: ", node_path_str)
					return
				
				print("[Tree] 实际节点: ", target_node.name, " (类型: ", target_node.get_class(), ")")
				
				if event.shift_pressed:
					# Shift+点击：切换节点及所有子节点
					print("[Tree] Shift+点击，切换节点及子节点: ", target_node.name)
					_toggle_node_and_children(target_node)
				else:
					# 普通点击：只切换当前节点
					print("[Tree] 点击，切换节点: ", target_node.name, " -> ", "可见" if not target_node.visible else "隐藏")
					target_node.visible = !target_node.visible
				
				# 刷新整个树以更新图标
				refresh_tree()

func _get_node_from_path(path_str: String) -> Node:
	var node_path = NodePath(path_str)
	return get_tree().root.get_node_or_null(node_path)

func _toggle_node_and_children(node: Node) -> void:
	# 切换当前节点
	node.visible = !node.visible
	
	# 递归切换所有子节点
	for child in node.get_children():
		if not _should_ignore(child):
			_toggle_node_and_children(child)

func _update_item_icon(item: TreeItem, node: Node) -> void:
	if not is_instance_valid(node):
		return
	if node.visible:
		item.set_icon(2, visible_icon)
	else:
		item.set_icon(2, hidden_icon)

func _should_ignore(node: Node) -> bool:
	var node_path = node.get_path()
	var path_str = str(node_path)
	var ignore_str = str(ignore_path)
	
	if path_str == ignore_str or path_str.begins_with(ignore_str + "/"):
		return true
	return false

func _add_node_to_tree(parent_item: TreeItem, node: Node) -> void:
	if _should_ignore(node):
		return
	
	var tree_item: TreeItem
	if parent_item == null:
		tree_item = create_item()
	else:
		tree_item = create_item(parent_item)
	
	tree_item.set_metadata(0, str(node.get_path()))
	
	# 第0列：节点名称
	tree_item.set_text(0, node.name)
	
	# 第1列：节点类型
	var display_type = _get_display_type(node)
	tree_item.set_text(1, display_type)
	
	# 第2列：可见性图标
	_update_item_icon(tree_item, node)
	
	# 颜色应用到第0列（节点名称）
	match node.get_class():
		"Control":
			tree_item.set_custom_color(0, Color(0.6, 0.8, 1.0))
		"Node2D":
			tree_item.set_custom_color(0, Color(0.6, 1.0, 0.6))
		"Window":
			tree_item.set_custom_color(0, Color(1.0, 0.8, 0.6))
		"Button":
			tree_item.set_custom_color(0, Color(1.0, 0.6, 0.8))
	
	for child in node.get_children():
		_add_node_to_tree(tree_item, child)

func _get_display_type(node: Node) -> String:
	var script = node.get_script()
	if script:
		var classname = _extract_class_name_from_script(script.resource_path)
		if classname:
			return classname
	return node.get_class()

func _extract_class_name_from_script(script_path: String) -> String:
	var file = FileAccess.open(script_path, FileAccess.READ)
	if not file:
		return ""
	for i in range(30):
		if file.eof_reached():
			break
		var line = file.get_line()
		if line.contains("class_name"):
			var parts = line.split(" ")
			for j in range(parts.size()):
				if parts[j] == "class_name" and j + 1 < parts.size():
					var classname = parts[j + 1].strip_edges()
					if classname.contains("#"):
						classname = classname.split("#")[0].strip_edges()
					return classname
	return ""
