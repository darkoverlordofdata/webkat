        __        __   _     _  __     _   
        \ \      / /__| |__ | |/ /__ _| |_ 
         \ \ /\ / / _ \ '_ \| ' // _` | __|
          \ V  V /  __/ |_) | . \ (_| | |_ 
           \_/\_/ \___|_.__/|_|\_\__,_|\__|
                                            
                the browser that does nothing...

WebKat does NOT have:

    address bar
    scroll bars
    tool bars
    menus
    status bars

What does webkat do?

    display url from command line and create a shortcut
    optionally set window size
    optionally allow web inspector dev tools
    and just sit there (like my cat)

    Use it to connect single page webapps to your menu

## Usage

    Usage:
    webkat [OPTION...] - WebKat

    Help Options:
    -?, --help               Show help options

    Application Options:
    -h, --height             height in pixels
    -w, --width              width in pixels
    -t, --title              title bar text
    -d, --debug              debug mode?
    -g, --webgl              enable webgl
    -v, --version            debug mode?
    -n, --name               desktop file name
    -i, --icon=DIRECTORY     desktop icon
    -c, --comment            desktop comment

## Example
```bash
$ webkat http://localhost/shmupwarz --webgl --debug --desktop --name ShmupWarz --icon /home/bruce/Pictures/d16a.icon.png --comment "Give Me Those Shmup Wars"

$ webkat --webgl https://www.facebook.com 

```

## Install

Requires valac v0.18 or greater

```bash
$ git clone git@github.com:darkoverlordofdata/webkat.git
$ cd webkat
$ make all
$ sudo make install
```


## Trouble?
Note - this *should* not longer be necessary, I'm now using a local copy of the vapi to compile.

	if you get this error:
	error: Package `webkitgtk-3.0' not found in specified Vala API directories or GObject-Introspection GIR directories

	```bash
	$ cd /usr/share/vala-0.nn/vapi
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

Copyright (c) 2012 - 2016 Bruce Davidson &lt;darkoverlordofdata@gmail.com&gt;

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
