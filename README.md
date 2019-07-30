# Godot Editor Plugin Tools

This is a collection of useful editor plugin utility methods and tools.

Godot 3.1+ compatible.

## Usage

```gdscript
var utils = EditorPluginUtils.new(self) 
# or:
var utils = preload('editor_plugin_utils.gd').new(self)
```

where `self` is an `EditorPlugin`.

## Examples
```
button.icon = utils.get_editor_icon('Add')
```

## License

The utility class and all other files of this repository are distributed under 
the MIT license (see the [LICENSE.md](LICENSE.md) file).
