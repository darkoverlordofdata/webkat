all:
	valac --pkg gtk+-3.0 --pkg webkitgtk-3.0 --thread src/webview.vala --output=bin/webview

clean:
	rm -rf bin/*.o 	

install:
	cp -f bin/webview /usr/bin

uninstall:
	rm -f /usr/bin/webview
