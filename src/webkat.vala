
/*
+--------------------------------------------------------------------+
| Webkat
+--------------------------------------------------------------------+
| Copyright DarkOverlordOfData (c) 2013 - 2016
+--------------------------------------------------------------------+
|
| This file is a part of Webkat
|
| Webkat is free software; you can copy, modify, and distribute
| it under the terms of the MIT License
|
+--------------------------------------------------------------------+
*
* @copyright	DarkOverlordOfData (c) 2013 - 2106
* @author		BruceDavidson@darkoverlordofdata.com
*
* "Yu Mo Gui Gwai Fai Di Zao" -- Uncle
*
* Class Webkat
*
*   A WebKit client to preview the local server output
*   Use for local debugging & design
*   Serving locally hosted web apps 
*   Controlled via command line
*
*/

using Gtk;
using WebKit;

public class Webkat : Window {

  private const string TITLE = "WebKat";
  private const int WIDTH = 1280;
  private const int HEIGHT = 1024;

  public bool use_inspector = false;

  private WebView webView;

  /**
   * Constructor
   */
  public Webkat(bool debug, bool webgl, string url, string title, int width, int height) {


    try {
        icon = new Gdk.Pixbuf.from_file("/usr/local/share/icons/webkat.png");
    }
    catch (Error e) {
        icon = null;
        stdout.printf("Error: %s\n", e.message);
    }
    if (icon == null) {
        try {
            icon = new Gdk.Pixbuf.from_file("./.local/share/icons/webkat.png");
        }
        catch (Error e) {
            icon = null;
            stdout.printf("Error: %s\n", e.message);
        }

    }
    this.title = title;
    use_inspector = debug;
    set_default_size(width, height);

    //  Make the client window
    webView = new WebView();
    var scrolledWindow = new ScrolledWindow(null, null);
    scrolledWindow.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
    scrolledWindow.add(webView);

    // Assemble the gui components
    var vbox = new VBox(false, 0);
    vbox.add(scrolledWindow);
    add(vbox);

    // Add inspector to the context menu
    WebSettings settings = webView.get_settings();
    settings.enable_developer_extras = true;
	settings.enable_webgl = webgl;

    // Wire up the events
    destroy.connect(Gtk.main_quit);
    webView.title_changed.connect(titleChanged);
    webView.web_inspector.inspect_web_view.connect(inspectWebView);

    // Display
    show_all();
    webView.open(url);
    webView.set_zoom_level((float)1.1);
    webView.zoom_in();

  }

  /**
   * titleChanged
   *
   * Set title from the html <title>...</title> tags
   *
   * @param source
   * @param frame
   * @param title
   * @return void
   *
   */
  public void titleChanged(Object source, Object frame, string title) {

    this.title = title ?? Webkat.TITLE;
  }

  /**
   * inspectWebView
   *
   * Display the Inspector
   *
   * @param WebView
   * @return uncounted ref
   *
   */
  public unowned WebView inspectWebView(WebView v) {

    unowned WebView result = null;

    if (use_inspector) {
        result = (new Inspector(this)).webView;
    }
    return result;
  }

  /**
   * Main - start the application
   *
   * @param array<string>  args command line args
   * @return int  0 Success!
   *
   */
  public static int main(string[] args) {

    string url = "http://localhost";
    string title = "WebKat";
    string width = "1280";
    string height = "1024";
	string name = "";
	string icon = "";
	string comment = "";
    bool mode = false;
    bool set_title = false;
    bool set_width = false;
    bool set_height = false;
    bool set_name = false;
    bool set_icon = false;
    bool set_comment = false;
	bool webgl = false;
	bool desktop = false;
	string usage = """
webkat <url> <options>

    -H --height     height in pixels
    -W --width      width in pixels
    -t --title      title bar
    -d --debug      enable chrome developer tools
	--webg			enable WebGL
	--desktop NAME  write a NAME.desktop file 
	--icon LOCATION
	--comment "Comment"

""";
	string template = """[Desktop Entry]
Comment=%s
Terminal=false
Name=%s
Exec=webkat %s
Type=Application
Icon=%s
""";

	if (args.length == 1) {
		print(usage);
		return 0;
	}

    foreach (string arg in args) {

        if (set_title) {
            title = arg;
            set_title = false;
            continue;
        }
        if (set_width) {
            width = arg;
            set_width = false;
            continue;
        }
        if (set_height) {
            height = arg;
            set_height = false;
            continue;
        }
        if (set_name) {
            name = arg;
            set_name = false;
            continue;
        }
        if (set_icon) {
            icon = arg;
            set_icon = false;
            continue;
        }
        if (set_comment) {
            comment = arg;
            set_comment = false;
            continue;
        }

        if (arg == "-d" ) {
            mode = true;
        }
        else if (arg == "--debug") {
            mode = true;
        }
        else if (arg == "--webgl") {
            webgl = true;
        }
        else if (arg == "-t") {
            set_title = true;
        }
        else if (arg == "--title") {
            set_title = true;
        }
        else if (arg == "-W") {
            set_width = true;
        }
        else if (arg == "--width") {
            set_width = true;
        }
        else if (arg == "-H") {
            set_height = true;
        }
        else if (arg == "--height") {
            set_height = true;
        }
        else if (arg.index_of("http://") == 0) {
            url = arg;
        }
        else if (arg.index_of("https://") == 0) {
            url = arg;
        }
		else if (arg == "--desktop") {
			desktop = true;
		}
		else if (arg == "--name") {
			set_name = true;
		}
		else if (arg == "--icon") {
			set_icon = true;
		}
		else if (arg == "--comment") {
			set_comment = true;
		}

    }
	if (desktop) {
		MainLoop loop = new MainLoop ();
		try {
			
			string user = Environment.get_variable("USER");
			string path = "/home/%s/Desktop/%s.desktop".printf(user, name);
			string webgl_flag = webgl ? "--webgl" : "";
			
			string cmd = "%s --title %s --width %s --height %s %s".printf(url, title, width, height, webgl_flag);
			
			var file = File.new_for_path(path);
			{
				var file_stream = file.create(FileCreateFlags.NONE);
				var data_stream = new DataOutputStream(file_stream);
				data_stream.put_string(template.printf(comment, name, cmd, icon));
			}
			
			string[] spawn_args = {"chmod", "+x", path};
			string[] spawn_env = Environ.get();
			Pid child_pid;
			
			Process.spawn_async (null,
				spawn_args,
				spawn_env,
				SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
				null,
				out child_pid);

			ChildWatch.add (child_pid, (pid, status) => {
				// Triggered when the child indicated by child_pid exits
				Process.close_pid (pid);
				loop.quit ();
			});

			loop.run ();
			
		} catch (Error e) {
		    stderr.printf ("Error: %s\n", e.message);
		    return 1;
		}		
	}
	else {
		Gtk.init(ref args);
		var client = new Webkat(mode, webgl, url, title, int.parse(width), int.parse(height));
		Gtk.main();
	}
    return 0;
  }
  /**
   *
   * Class Inspector
   *
   * Wrap the web_inspector in it's own window
   *
   */
  class Inspector : Window {

    public WebView webView;

    /**
     *  Display the web_inspector
     */
    public Inspector(Window parent) {

      icon = parent.icon;
      title = "Developer Tools - " + (parent.title ?? Webkat.TITLE);
      set_default_size(Webkat.WIDTH, Webkat.HEIGHT);

      //  Make the client window
      webView = new WebView();
      var scrolledWindow = new ScrolledWindow(null, null);
      scrolledWindow.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
      scrolledWindow.add(webView);
      add(scrolledWindow);

      show_all();
    }

    /**
     *  Teardown
     */
    ~Inspector() {
      webView.web_inspector.close();
    }
  }
}


