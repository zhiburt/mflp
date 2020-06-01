# mflp - my first lua program

The shell is a weekend expedition of lua and shell specifics.

## Requirements

To use the shell there should be installed [luaposix](https://github.com/luaposix/luaposix). It can be installed by luarocks.

```
luarocks install luaposix
```

## Usage

The shell can be started by running the script.

```bash
./shell.lua
```

## Customization

You can create a `config.lua` file in the directory beside the shell.

```lua
SHELL = {
    ident_line = function() return os.date() .. " " end,
    prompt = function()
        -- http://www.patorjk.com/software/taag/#p=display&h=1&f=Star%20Wars&t=MFLP
        return [[

    .___  ___.  _______  __      .______   
    |   \/   | |   ____||  |     |   _  \  
    |  \  /  | |  |__   |  |     |  |_)  | 
    |  |\/|  | |   __|  |  |     |   ___/  
    |  |  |  | |  |     |  `----.|  |      
    |__|  |__| |__|     |_______|| _|             

]]
    end
}

return SHELL
```

## References

- https://brennan.io/2015/01/16/write-a-shell-in-c/ — I was lucky to have read it before the outset
- https://github.com/danistefanovic/build-your-own-x#build-your-own-shell — There was discovered the list of other tutorials here