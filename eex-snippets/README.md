# These are code snippetes for acquaintance with the embedded elixir (EEx)


```sh
iex
```
```elixir
iex> string = "Hello <%= @person %>"
"Hello <%= @person %>"

iex> EEx.eval_string(string, assigns: [person: "World"])
"Hello World"


iex> string = "Hello <%= String.downcase(@person) %>"
"Hello <%= String.downcase(@person) %>"

iex> EEx.eval_string(string, assigns: [person: "World"])
"Hello world"
```

```sh
echo 'Hello <%= String.capitalize(@person) %>' > message.eex
```

```elixir
iex> EEx.eval_file("message.eex", assigns: [person: "world"])
"Hello World"
```


./function_body.eex
```eex
<% IO.puts("This function was called with #{a} and #{b}") %>
<%= a + b %>
```

./module_a.ex
```elixir
defmodule ModuleA do
  require EEx
  EEx.function_from_file(:def, :fun_a, "function_body.eex", [:a, :b])
end
```

```elixir
iex> Code.require_file("module_a.ex")
[ {ModuleA, <<70, 79, 82, 49, 0, 0, ... >>} ]

iex> return_value = ModuleA.fun_a(1, 2)
This function was called with 1 and 2
"\n3\n"

iex> return_value
"\n3\n"
```

./ast.eex
```eex
"<%= a %> <%= b %>"
```

```elixir
iex> ast = EEx.compile_file("ast.eex")
# nested tuple of AST ...

iex> {output, _} = Code.eval_quoted(ast, a: "Hello", b: "World")
{"Hello World\n",
 [
   {:b, "World"},
   {{:arg1, EEx.Engine}, "World"},
   {{:arg0, EEx.Engine}, "Hello"},
   {:a, "Hi"}
 ]}

iex> output
"\"Hello World\"\n"
```



> EEx.SmartEngine


./assigns.eex
```eex
<%= @a %> <%= @b %>
```

./module_b.ex
```elixir
defmodule ModuleB do
  require EEx
  EEx.function_from_file(:def, :fun_b, "assigns.eex", [:assigns])
end
```


```elixir
iex> Code.require_file("module_b.ex")
[ {ModuleB, <<70, 79, 82, 49, 0, 0, ..>>} ]

iex> ModuleB.fun_b(a: "Hello", b: "World")
"Hello World\n"

iex> ModuleB.fun_b(a: "Hola", b: "World")
"Hola World\n"
```


### CustomEngine


./custom_ast.eex
```eex
<%| a + b %>
<%= a %> <%= b %>
```

```elixir
iex> EEx.eval_file("custom_ast.eex", [a: 1, b: 2])

** (EEx.SyntaxError) unsupported EEx syntax <%| %> (the syntax is valid but not supported by the current EEx engine)
    lib/eex/engine.ex:211: EEx.Engine.handle_expr/3
    lib/eex/compiler.ex:346: EEx.Compiler.generate_buffer/4
    lib/eex.ex:303: EEx.eval_file/3
    iex:1: (file)
```


```elixir
iex> Code.require_file("custom_engine.ex")
[ {CustomEngine, <<70, 79, ... >>} ]

iex> val = EEx.eval_file("custom_ast.eex", [a: 1, b: 2], engine: CustomEngine)

3
"\n1 2\n"

iex> val
"\n1 2\n"
```


