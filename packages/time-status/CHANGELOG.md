## 1.0.0 - Initial Release

## 1.0.1 - Replace deprecated call
This release is replacing the a deprecated call to 'atom.workspaceView' with the recommended 'document.querySelector("status-bar")'.

This is a first step in becoming fully compliant with the new status-bar API and removes the deprecation warning.

## 1.0.2 - Fix deprecation issues
This release changes the 'stylesheets' directories name to 'styles' and replaces a deprecated call.
This is done to comply with the Atom API and will remove the deprecation warnings for this package.  

## 1.1.0 - Use locale instead of hardcoded 24-hour clock
Thanks to [Bertrand Marron](https://github.com/JoeFyhrCeesay/time-status/pull/1).

## 1.1.1 - Fix time display in atom v1.4.0
Thanks to [gera2ld](https://github.com/JoeFyhrCeesay/time-status/pull/4).

## 1.1.2 - Fix activation and deactivation
Thanks to [gera2ld](https://github.com/JoeFyhrCeesay/time-status/pull/5).
