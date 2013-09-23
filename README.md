#WebKat

A simple webkit shell.
WebKat does NOT have:

    address bar
    scroll bars
    tool bars
    menus
    status bars

##Install

Requires valac v0.18

```bash
$ git clone git@github.com:darkoverlordofdata/webkat.git
$ cd webkat
$ make all
$ sudo make install
```

##Usage

webkat <url> <options>

    -H --height     height in pixels
    -W --width      width in pixels
    -t --title      title bar
    -d --debug      enable chrome developer tools



##Example

Initialize an express server


```coffeescript
{exec} = require('child_process')
express = require('express')
app = express()
```


Start up server and view outut in webkat.
Wait for webkat to end and close the server.

```coffeescript
app.listen 3000, ->

    console.log 'Listening on port 3000'
    exec "webkat http://localhost:3000", (err, stdout, stderr) ->
        console.log stderr if stderr?
        console.log stdout if stdout?
        process.exit()
```

##Trouble?
if you get this error:
error: Package `webkitgtk-3.0' not found in specified Vala API directories or GObject-Introspection GIR directories

```bash
$ cd /usr/share/vala-0.18/vapi
$ sudo cp webkit-1.0.deps webkitgtk-3.0.deps
$ sudo cp webkit-1.0.vapi webkitgtk-3.0.vapi
$ gksudo gedit webkitgtk-3.0.deps
```
Then:
change gdk-2.0 to gdk-3.0
change gtk+-2.0 to gtk+-3.0
save and quit



## License

(The MIT License)

Copyright (c) 2012 - 2013 Bruce Davidson &lt;darkoverlordofdata@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
