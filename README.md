# SilverFox Godot Custom Controls

这是一个为Godot引擎开发的自定义控件库，提供了一系列增强的UI控件，帮助开发者快速构建美观且功能丰富的用户界面�?

## 功能特�?

- **自定义控�?*：包括下拉菜单、文件浏览器、窗口控件等
- **易于集成**：直接添加到Godot项目中，无需复杂配置
- **开源免�?*：遵循开源许可证，自由使用和修改

## 控件列表

### DropDown
自定义下拉菜单控件，支持选项列表和自定义样式�?

### Explorer
文件浏览器控件，用于导航和选择文件/文件夹�?

### Window
自定义窗口控件�?

### WindowTitle
窗口标题栏控件，支持拖拽，与Window控件配合使用�?

## 项目结构

<details>
<summary>点击展开项目结构</summary>

```
SilverFox--godot-custom-controls/
├── LICENSE
├── Class/
�?  ├── Enums.gd
�?  ├── Enums.gd.uid
�?  ├── HandlePath.gd
�?  ├── HandlePath.gd.uid
�?  ├── HandleTheme.gd
�?  └── HandleTheme.gd.uid
└── Controls/
    ├── DropDown/
    �?  ├── DropDown.gd
    �?  ├── DropDown.gd.uid
    �?  ├── OptionItem.gd
    �?  └── OptionItem.gd.uid
    ├── Explorer/
    �?  ├── Explorer.gd
    �?  └── Explorer.gd.uid
    ├── Window/
    �?  ├── Window.gd
    �?  └── Window.gd.uid
    └── WindowTitle/
        ├── WindowTitle.gd
        └── WindowTitle.gd.uid
```

</details>

## 安装使用

1. 下载或克隆此仓库到本地�?
2. 将`Controls/`文件夹复制到你的Godot项目中�?
3. 在Godot编辑器中，将相应�?gd脚本附加到你的场景节点上�?
4. 根据需要调整控件的属性和主题�?

## 类库

- **Enums.gd**：定义了项目中使用的枚举类型�?
- **HandlePath.gd**：路径处理工具类�?
- **HandleTheme.gd**：主题处理工具类�?

## 许可�?

本项目采用[LICENSE](LICENSE)文件中指定的许可证�?

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 联系

如有问题或建议，请通过GitHub Issues联系�