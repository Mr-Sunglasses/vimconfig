return {
  -- C-specific key mappings and configurations
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- C-specific snippets
      ls.add_snippets("c", {
        s("main", {
          t({"#include <stdio.h>", "", "int main() {", "    "}),
          i(1, "// your code here"),
          t({"", "    return 0;", "}"})
        }),
        s("printf", {
          t("printf(\""),
          i(1, "format"),
          t("\""),
          i(2),
          t(");")
        }),
        s("for", {
          t("for (int "),
          i(1, "i"),
          t(" = 0; "),
          f(function(args) return args[1][1] end, {1}),
          t(" < "),
          i(2, "n"),
          t("; "),
          f(function(args) return args[1][1] end, {1}),
          t("++) {"),
          t({"", "    "}),
          i(3),
          t({"", "}"})
        }),
        s("if", {
          t("if ("),
          i(1, "condition"),
          t(") {"),
          t({"", "    "}),
          i(2),
          t({"", "}"})
        }),
        s("func", {
          i(1, "return_type"),
          t(" "),
          i(2, "function_name"),
          t("("),
          i(3, "parameters"),
          t(") {"),
          t({"", "    "}),
          i(4),
          t({"", "}"})
        }),
      })
    end,
    ft = "c",
  },
}