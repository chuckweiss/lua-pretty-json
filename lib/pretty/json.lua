-- Copyright (c) 2018, Souche Inc.

local Constant = require "pretty.json.constant"
local Serializer = require "pretty.json.serializer"
local Parser = require "pretty.json.parser"

local json = {
    _VERSION = "0.1",
    null = Constant.NULL
}

function json.stringify(obj, replacer, space, print_address, sort_table_keys)
    if type(space) ~= "number" then space = 0 end

    return Serializer({
        print_address = print_address,
        sort_table_keys = sort_table_keys,
        stream = {
            fragments = {},
            write = function(self, ...)
                for i = 1, #{...} do
                    self.fragments[#self.fragments + 1] = ({...})[i]
                end
            end,
            toString = function(self)
                return table.concat(self.fragments)
            end
        }
    }):json(obj, replacer, space, space):toString()
end

function json.parse(str, without_null)
    return Parser({ without_null = without_null }):json(str, 1)
end

return json
