all:
	-mkdir bin
	valac --pkg gtk+-3.0 --pkg libsoup-2.4 --vapidir ./vapi --pkg webkitgtk-3.0 --thread test.vala --output=test


# clean:
# 	rm -rf bin/*.o 	

# install:
# 	cp -f bin/webkat /usr/local/bin
# 	-mkdir /usr/local/share/icons
# 	cp -fr src/icon.png /usr/local/share/icons/webkat.png

# uninstall:
# 	rm -f /usr/local/bin/webkat
# 	rm -f /usr/local/share/icons/webkat.png
