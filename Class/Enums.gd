# ============================================
# Enums 通用枚举定义
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
# V1.1
# ============================================

@tool
class_name Enums
extends Resource

## 控件位置模式[br]
## @deprecated: 新的控件不要再继续此枚举[br]应该使用 [member PositionMode_Horizontal] 和 [member PositionMode_Vertical][br]
enum PositionMode {
	EXTERNAL_RIGHT ,	## 外部右侧，以 父级物体 右上方 为0点
	INTERNAL_RIGHT ,	## 内部右侧，以 父级物体 右上方 减去 自己的宽度 为0点
	EXTERNAL_LEFT ,		## 外部左侧，以 父级物体 左上方 减去 自己的宽度 为0点
	INTERNAL_LEFT ,		## 内部左侧，以 父级物体 左上方 为0点 (再坐标系是左上到右下的情况下，和自由位置效果相同)
	FREE ,				## 自由位置，直接设置position
}

## 控件位置模式 水平
enum PositionMode_Horizontal {
	Left_External ,		## 外部左侧
	Left ,				## 左侧 , 和Godot默认一致
	Central ,			## 正中
	Right ,				## 右侧
	Right_External ,	## 外部右侧
}

## 控件位置模式 垂直
enum PositionMode_Vertical {
	Up_External ,		## 外部上侧
	Up ,				## 上侧 , 和Godot默认一致
	Central ,			## 正中
	Down ,				## 下侧
	Down_External ,		## 外部下侧
}

## @deprecated: 新的控件不要再继续此函数[br]应该使用 [method PositionMode_Application][br]或者单独对 水平 和 垂直 使用 [method PositionMode_Application_Horizontal] 和 [method PositionMode_Application_Vertical]
static func Application_PositionMode (Position_Mode : PositionMode , Parent_Size : Vector2 , Size : Vector2 , Position : Vector2) -> Vector2 :
	var retrun_Position : Vector2

	if Position_Mode == 0 :
		retrun_Position = Vector2 (Parent_Size.x , 0) + Position
	elif Position_Mode == 1 :
		retrun_Position = Vector2 (Parent_Size.x - Size.x , 0) + Position

	elif Position_Mode == 2 :
		retrun_Position = Vector2 (0 - Size.x , 0) + Position
	elif Position_Mode == 3 :
		retrun_Position = Position

	else :
		retrun_Position = Position

	return retrun_Position

static func PositionMode_Application (Horizontal : PositionMode_Horizontal , Vertical : PositionMode_Vertical , Parent_Size : Vector2 , Size : Vector2 , Position : Vector2) -> Vector2 :
	return Vector2 (
		PositionMode_Application_Horizontal (Horizontal , Parent_Size.x , Size.x , Position.x) ,
		PositionMode_Application_Vertical (Vertical , Parent_Size.y , Size.y , Position.y)
	)

static func PositionMode_Application_Horizontal (Horizontal : PositionMode_Horizontal , Parent_Size_X : float , Size_X : float , Position_X : float) -> float :
	var return_Position : float

	match Horizontal :
		PositionMode_Horizontal.Left_External :
			return_Position = Position_X - Size_X

		PositionMode_Horizontal.Left :
			return_Position = Position_X

		PositionMode_Horizontal.Central :
			return_Position = Position_X + (Parent_Size_X - Size_X) / 2

		PositionMode_Horizontal.Right :
			return_Position = Position_X + Parent_Size_X - Size_X

		PositionMode_Horizontal.Right_External :
			return_Position = Position_X + Parent_Size_X

	return return_Position

static func PositionMode_Application_Vertical (Vertical : PositionMode_Vertical , Parent_Size_Y : float , Size_Y : float , Position_Y : float) -> float :
	var return_Position : float

	match Vertical :
		PositionMode_Vertical.Up_External :
			return_Position = Position_Y - Size_Y

		PositionMode_Vertical.Up :
			return_Position = Position_Y

		PositionMode_Vertical.Central :
			return_Position = Position_Y + (Parent_Size_Y - Size_Y) / 2

		PositionMode_Vertical.Down :
			return_Position = Position_Y + Parent_Size_Y - Size_Y

		PositionMode_Vertical.Down_External :
			return_Position = Position_Y + Parent_Size_Y

	return return_Position
