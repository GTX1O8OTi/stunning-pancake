hi

do
```lua
run("command","params")
```

and it'll work :)

how to make a command:

go to `cmds` folder -> make file with .lua extension -> make it return at least a func like
```lua
return {func = function(hi) print('hi mom') end}
```
 -> edit commands file and add it to the list (just look how i did with the other 2)
 
 "name link true/false"

 the last one the true or false part is so the run function will pass the player specified on the argument so less manual work :)