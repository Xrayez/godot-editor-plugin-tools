# Godot Editor Plugin Tools

This is a collection of useful editor plugin utility methods and tools, which
help developing the plugins themselves. Some more sophisticated editor
enhancements and optimizations are implemented as dedicated plugins here under
`addons/` folder.

## Compatibility

Godot 3.1+ compatible.

## EditorPluginUtils

### Usage

```gdscript
var utils = EditorPluginUtils.new(self) 
# or:
var utils = preload('editor_plugin_utils.gd').new(self)
```

where `self` is an `EditorPlugin`.

### Examples
```
button.icon = utils.get_editor_icon('Add')
```

## License

Unless otherwise specified, the files in this repository are distributed under
the MIT license (see the [LICENSE.md](LICENSE.md) file).
