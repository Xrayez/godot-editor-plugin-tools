# Copyright (C) 2020 Andrii Doroshenko.
# Distributed under the terms of the MIT license.
#
# This is a plugin which aims to enhance and optimize various features of the
# Godot's built-in script editor.
#
# A list of features currently implemented:
# - automatically clear the list of opened scripts and the recently opened
#   documentation pages on Godot exit (plugin exit), meaning that the list is
#   kept during editor lifetime only. This also workarounds a performance issue
#   of scripts being loaded at editor startup in Godot <3.2.2 as described in:
#   -  https://github.com/godotengine/godot/issues/39841
#
tool
extends EditorPlugin

# Configure this to your likings.
var clear_script_list_on_exit = true
var clear_doc_list_on_exit = true


func _notification(what):
	# NOTE: overriding the config on NOTIFICATION_WM_QUIT_REQUEST doesn't work,
	# but might provide some future-proofing.
	if what == NOTIFICATION_EXIT_TREE or what == NOTIFICATION_WM_QUIT_REQUEST:
		clear_opened_list_from_config()


# Clear script list and doc pages on exit.
#
# NOTE: this only works on the configuration side, not run-time, the changes
# will be picked up on editor restart.
#
func clear_opened_list_from_config():
	var interface = get_editor_interface()
	var project_dir = interface.get_editor_settings().get_project_settings_dir()

	var editor_layout = ConfigFile.new()
	var editor_layout_filepath = project_dir.plus_file("editor_layout.cfg")
	var err = editor_layout.load(editor_layout_filepath)
	if err != OK:
		return # Nothing to do.

	if clear_script_list_on_exit:
		if editor_layout.has_section_key("ScriptEditor", "open_scripts"):
			editor_layout.set_value("ScriptEditor", "open_scripts", [])

	if clear_doc_list_on_exit:
		if editor_layout.has_section_key("ScriptEditor", "open_help"):
			editor_layout.set_value("ScriptEditor", "open_help", [])

	if clear_script_list_on_exit or clear_doc_list_on_exit:
		editor_layout.save(editor_layout_filepath)

	# NOTE: ScriptEditor `split_offset` remains unaffected by this.
