# Copyright © 2019 Andrii Doroshenko and contributors
# Distributed under the terms of the MIT license.
#
# Upstream repo: https://github.com/Xrayez/godot-editor-plugin-tools
#
# Usage: var utils = preload('editor_plugin_utils.gd').new(self) # EditorPlugin
#
# Uncomment to be available globally:
# class_name EditorPluginUtils

var plugin = null setget set_editor_plugin

var editor = null
var filesystem = null

#==============================================================================
# Initialization
#==============================================================================
func _init(p_plugin):
	set_editor_plugin(p_plugin)

func set_editor_plugin(p_plugin):
	assert(p_plugin is EditorPlugin)
	plugin = p_plugin

	editor = plugin.get_editor_interface().get_base_control()
	filesystem = plugin.get_editor_interface().get_resource_filesystem()

#==============================================================================
# Editor Icons
#==============================================================================
# Note: use the following methods if the theme is overridden per control or
#       operating within an editor plugin itself. Use control's respective
#       methods regarding theme where possible.

# Fetches existing icon texture from Godot's own theme
func get_editor_icon(p_name):
	return editor.theme.get_icon(p_name, 'EditorIcons')

# Retrieves a list of all available Godot icons!
func get_editor_icons_list():
	return editor.theme.get_icon_list('EditorIcons')

#==============================================================================
# Editor Filesystem
#==============================================================================
const INCLUDE_DEFAULT = ["*"]

# Returns a list of all files at specified path, matching optional filter
func get_files(p_path, p_abs_paths = true, p_include = INCLUDE_DEFAULT):
	var files = []
	var dir = filesystem.get_filesystem_path(p_path)
	if not dir:
		return files

	for i in dir.get_file_count():
		var file = dir.get_file(i)

		var matched = _name_filter_match(file, p_include)
		if matched:
			if p_abs_paths:
				files.append(dir.get_file_path(i))
			else:
				files.append(file)
	return files

# Returns a list of all directories at specified path, matching optional filter
func get_directories(p_path, p_abs_paths = true, p_include = INCLUDE_DEFAULT):
	var dirs = []
	var dir = filesystem.get_filesystem_path(p_path)
	if not dir:
		return dirs

	for i in dir.get_subdir_count():
		var subdir = dir.get_subdir(i)
		var name = subdir.get_name()

		var matched = _name_filter_match(name, p_include)
		if matched:
			if p_abs_paths:
				dirs.append(subdir.get_path())
			else:
				dirs.append(name)
	return dirs

# Returns a list of all files at specified path matching filter
# by traversing all directories and subdirectories.
#
# Note: only absolute filepaths are constructed.
#
# Usage:
#    # Get all resource paths in the project
#    get_files_recursive("res://", ["*.tres", "*.res"])

func get_files_recursive(p_path, p_include = INCLUDE_DEFAULT):
	var files = []

	var to_visit = []
	to_visit.push_back(p_path)

	while not to_visit.empty():
		var cur_dir = to_visit.pop_back()

		for file in get_files(cur_dir, true, p_include):
			files.append(file)

		for dir in get_directories(cur_dir, true):
			to_visit.push_front(dir)

	return files

# Filter logic goes here
func _name_filter_match(p_name, p_include):
	var matched = false

	for pattern in p_include:
		if p_name.match(pattern):
			matched = true
			break

	return matched
