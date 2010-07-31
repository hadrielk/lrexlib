-- See Copyright Notice in the file LICENSE

-- This file should contain only test sets that behave identically
-- when being run with pcre or posix regex libraries.

local luatest = require "luatest"
local N = luatest.NT

local function norm(a) return a==nil and N or a end

local function set_f_gmatch (lib, flg)
  -- gmatch (s, p, [cf], [ef])
  local function test_gmatch (subj, patt)
    local out, guard = {}, 10
    for a, b in lib.gmatch (subj, patt, nil, nil, nil, "EMACS") do
      table.insert (out, { norm(a), norm(b) })
      guard = guard - 1
      if guard == 0 then break end
    end
    return unpack (out)
  end
  return {
    Name = "Function gmatch",
    Func = test_gmatch,
  --{  subj             patt         results }
    { {("abcd"):rep(3), "\\(.\\)b.\\(d\\)"}, {{"a","d"},{"a","d"},{"a","d"}} },
  }
end

local function set_f_split (lib, flg)
  -- split (s, p, [cf], [ef])
  local function test_split (subj, patt)
    local out, guard = {}, 10
    for a, b, c in lib.split (subj, patt, nil, nil, nil, "EMACS") do
      table.insert (out, { norm(a), norm(b), norm(c) })
      guard = guard - 1
      if guard == 0 then break end
    end
    return unpack (out)
  end
  return {
    Name = "Function split",
    Func = test_split,
  --{  subj             patt      results }
    { {"ab<78>c", "<\\(.\\)\\(.\\)>"},    {{"ab","7","8"}, {"c",N,N},            } },
  }
end

return function (libname)
  local lib = require (libname)
  return {
    set_f_gmatch    (lib),
    set_f_split     (lib),
  }
end