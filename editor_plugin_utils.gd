# Copyright � 2019 Andrii Doroshenko and contributors
# Distributed under the terms of the MIT license.
#
# Upstream repo: https://github.com/Xrayez/godot-editor-plugin-tools

class_name EditorPluginUtils

var plugin = null setget set_editor_plugin
var godot_editor = null

#==============================================================================
# Initialization
#==============================================================================
func _init(p_plugin):
	set_editor_plugin(p_plugin)

func set_editor_plugin(p_plugin):
	assert(p_plugin is EditorPlugin)
	plugin = p_plugin
	godot_editor = plugin.get_editor_interface().get_base_control()

#==============================================================================
# Godot editor icons
#==============================================================================

# Fetches existing icon texture from Godot's own theme
func get_editor_icon(p_name):
	return godot_editor.theme.get_icon(p_name, 'EditorIcons')

# Retrieves a list of all available Godot icons!
func get_editor_icons_list():
	return godot_editor.theme.get_icon_list('EditorIcons')