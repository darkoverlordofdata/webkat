all:
	valac --pkg gtk+-3.0 --pkg webkitgtk-3.0 --thread src/webview.vala --output=bin/webview


clean:
	rm -rf bin/*.o 	

install:
	cp -f bin/webview /usr/local/bin
	mkdir /usr/local/share/icons
	cp -fr src/icon.png /usr/local/share/icons/webview.png

uninstall:
	rm -f /usr/local/bin/webview
	rm -f /usr/local/share/icons/webview.png
