#!/usr/bin/lua

local cfg = require 'config';
local cfg = {
    indent_line = cfg.ident_line or function() return "> " end,
    prompt = cfg.prompt or function() return "" end
}

local unistd = require 'posix.unistd'
local posix = require 'posix'
local wait = require 'posix.sys.wait'
local signal = require "posix.signal"
local stdlib = require "posix.stdlib"

signal.signal(signal.SIGINT, function(signum)
    io.write("\n")
    os.exit(128 + signum)
end)

local buildin = {
    exit = function() os.exit(0) end,
    cd = function(path)
        if path == nil then return "cd: there's no given parameter" end

        unistd.chdir(path)
    end
}

local STATUS = 0;

local function prep(line)
    return string.gsub(line, "%$([%w_?]+)", function(symbol)
        if symbol == '?' then
            return STATUS
        else
            return stdlib.getenv(symbol) or ""
        end
    end)
end

local function start(program, ...)
    local child, err = unistd.fork()
    if child < 0 then
        return -1, err
    elseif child == 0 then
        local code = ({unistd.execp(program, ...)})[3]
        os.exit(code)
    else
        local code = ({wait.wait(child)})[3]
        return code
    end
end

local function split_line(line)
    local program = ""
    local params = {}
    for w in string.gmatch(line, "[^%s]+") do
        if w ~= nil then
            if program == "" then
                program = w;
            else
                table.insert(params, w)
            end
        end
    end

    return program, params
end

io.write(cfg.prompt())

repeat
    io.write(cfg.indent_line())

    local line = io.read("l")
    if line == nil then break end

    line = prep(line)
    local program, params = split_line(line)
    local util = buildin[program];
    if util ~= nil then
        local err = util(table.unpack(params))
        if err ~= nil then print(err) end
    else
        local code, err = start(program, params)
        if err ~= nil then
            print("shell: " .. err)
            os.exit(-1)
        elseif code ~= 0 then
            local err = posix.errno(code)
            err = string.gsub(err, "%d+$", "")
            print(err)
        end

        STATUS = code
    end
until false
