[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://docs.google.com/forms/d/e/1FAIpQLSfBEe5B_zo69OBk19l3hzvBmz3cOV6ol1ufjh0ER1q3-xd2Rg/viewform)

# LuaJIT For Windows
LuaJIT For Windows packages LuaJIT, LuaRocks, a Mingw-w64 tool chain, and git for a modern and easy-to-use all-in-one Lua solution that can be distributed as a standard Lua environment for any Lua workflow running on a 64-bit Windows platform.

**Download the full pre-bundled self-extracting package here:**  
https://github.com/ScriptTiger/LuaJIT-For-Windows/releases/latest

**LuaJIT**  
OpenResty's implementation of LuaJIT has been chosen since it's well maintained by a larger active contributor base as an ongoing branch of the original LuaJIT and therefore compatible with LuaJIT scripts and bytecode, compatible with Lua 5.1 scripts, as well as features additionally curated add-ons for an added bonus to keep you on the bleeding edge of Lua development.  
https://github.com/openresty/luajit2

**LuaRocks**  
LuaRocks is a well-known and well-established Lua package manager which makes it easy to search, install, update, and remove Lua packages which are available through Lua repositories. It should be noted that while not all packages are compatible with LuaJIT, most common packages are. So, please refer to the documentation provided by the respective package maintainers for more information about compatibility.  
https://luarocks.org  
https://github.com/luarocks/luarocks

**Mingw-w64**  
For those familiar with cross-platform development, or for those who just love the tool, Mingw-w64 needs no introduction. LLVM MinGW brings the standard Mingw-w64 environment needed to compile various components that may come with LuaRocks packages, so having the MSVC suite installed is not necessary.  
https://github.com/mstorsjo/llvm-mingw

**git**  
Another staple of open source, git provides the LuaJIT For Windows package the necessary functionality of interacting directly with git repositories using the git protocol.  
https://git-scm.com/download/win

# How it Works
LuaJIT for Windows is designed with portability and flexibility in mind. Once the self-extracting package extracts LuaJIT For Windows to the directory of your choosing, you can immediately run it without any installation via the `LuaJIT-For-Windows.cmd`.

The `LuaJIT-For-Windows.cmd` acts as both a Lua script launcher and development environment all in one and allows you to seamlessly run different implementations of Lua all from the same script. In fact, you can even set `LuaJIT-For-Windows.cmd` as the default application to open any file with a `.lua`, `.luac`, or other Lua file extension and it will automatically launch it using your pre-configured settings. At the same time, because of the ability `LuaJIT-For-Windows.cmd` has to read file headers, there is also no longer any need to have multiple file extensions to maintain Lua scripts for specific Lua implementations, which can oftentimes just cause problems when sharing Lua scripts with others who have different file associations from you on their system.

**`LuaJIT-For-Windows.cmd` as a Lua Script Launcher**  
When you first run `LuaJIT-For-Windows.cmd`, the `lj4w.txt` will be created with some default preferences in the `%APPDATA%\LJ4W` directory (i.e. `C:\Users\YourName\AppData\Roaming\LJ4W`). The three pre-configured keys defined are `default.all.interpreter`, `default.lua.interpreter`, and `default.luajit.interpreter`.

While their values can be changed, and further custom key-value pairs entered, these three default keys must always be present. The `default.all.interpreter` is used to determine which Lua implementation to use by default for any script without a header designating which implementation to use. The `default.lua.interpreter` is used to determine which Lua implementation to use when executing Lua bytecode generated from Luac. And `default.luajit.interpreter` is used to determine which LuaJIT implementation to use when executing LuaJIT bytecode. While both the `default.all.interpreter` and `default.luajit.interpreter` start off with the `lj4w` value and associated `lj4w.interpreter` key defining the full path to the `LuaJIT-For-Windows.cmd`, `default.lua.interpreter` is pre-configured with the `lua` value but no associated `lua.interpreter` defining its path. Therefore, you must add the full path of your `lua.exe` to the `lua.interpreter` value, as an example, in order to use this feature. Otherwise, if `lua.interpreter` is left undefined, or whatever value you choose to associate with `default.lua.interpreter` (i.e. `foo` value and associated `foo.interpreter` key), you will encounter an error when attempting to execute Luac bytecode.

Aside from the aforementioned default keys mentioned, any number of further custom key-value pairs can be defined for custom headers, designated by the `--interpreter` header on the first line of a script (i.e. `--interpreter: foo`). So, for example, if you want to use the `foo` implementation of Lua for certain scripts, you can put `--interpreter: foo` on the first line of the script and it will automatically launch that script using the associated `foo.interpreter` as defined in the `lj4w.txt`. So, there is no longer a need to have multiple file extensions, and instead a simple file header can be used.

An important note here is that, by default, if you are running multiple Lua scripts consecutively within the same environment, `LuaJIT-For-Windows.cmd` will attempt to use the same Lua implementation determined for the first script for all subsequent scripts within the same environment session in order to speed up launching subsequent scripts. However, you can set the `LJ4W_MIXED` environmental variable to `true` in order to force `LuaJIT-For-Windows.cmd` to determine which interpreter to use for every script if you are using mixed scripts within the same environment session (i.e. mixing LuaJIT and/or Lua scripts and/or bytecode). Running mixed scripts within the same environment session is not that common, however, since most projects only bundle together scripts that are intended for the same target implementation.

For maximum flexibility, the `LJ4W_INTERPRETER` and/or `LJ4W_INTERPRETER_PATH` environmental variables can also be set, which act in the same way as the key-value pairs in the `lj4w.txt`. This can be useful to further speed up launch times or to specify things that can't be specified otherwise, such as alternative Lua implementations to use for bytecode files other than the defaults listed in the `lj4w.txt`, since custom headers cannot be added to bytecode files. If only the `LJ4W_INTERPRETER` is given, `LuaJIT-For-Windows.cmd` will attempt to set the `LJ4W_INTERPRETER_PATH` automatically by looking up the associated key-value pair in the `lj4w.txt`. Specifying the `LJ4W_INTERPRETER_PATH` explicitly will, alternatively, skip all lookups and go straight to launch the script using the interpreter at the path specified.

**`LuaJIT-For-Windows.cmd` as a Development Environment**  
When launching `LuaJIT-For-Windows.cmd` as a stand-alone script without any arguments, it will open a development environment where you will have access to all of the tools available within the LuaJIT For Windows package. So, whether you want to access LuaRocks to manage packages, access LuaJIT's REPL interface, access gcc or any of the other tools within the LLVM MinGW suite, you can do so immediately all from the same environment.

An important note for the development environment is that the `APPDATA` environmental variable is changed to `%APPDATA%\LJ4W` during a session in order to ensure that LuaRocks and all of its components remain isolated from any pre-existing LuaRocks trees which may be present. This change is only in effect while using the development environment and does not affect scripts which are directly launched via the script launcher functionality.

For more ScriptTiger scripts and goodies, check out ScriptTiger's GitHub Pages website:  
https://scripttiger.github.io/

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MZ4FH4G5XHGZ4)

Donate Monero (XMR): 441LBeQpcSbC1kgangHYkW8Tzo8cunWvtVK4M6QYMcAjdkMmfwe8XzDJr1c4kbLLn3NuZKxzpLTVsgFd7Jh28qipR5rXAjx
