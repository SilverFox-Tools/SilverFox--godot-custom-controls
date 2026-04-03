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
# V0.1
# ============================================

@tool
class_name Enums
extends Resource

## 控件位置模式
enum PositionMode {
	EXTERNAL_RIGHT ,	## 外部右侧，以 父级物体 右上方 为0点
	INTERNAL_RIGHT ,	## 内部右侧，以 父级物体 右上方 减去 自己的宽度 为0点
	EXTERNAL_LEFT ,		## 外部左侧，以 父级物体 左上方 减去 自己的宽度 为0点
	INTERNAL_LEFT ,		## 内部左侧，以 父级物体 左上方 为0点 (再坐标系是左上到右下的情况下，和自由位置效果相同)
	FREE ,				## 自由位置，直接设置position
}
