
/*
+--------------------------------------------------------------------+
| Webkat
+--------------------------------------------------------------------+
| Copyright DarkOverlordOfData (c) 2013
+--------------------------------------------------------------------+
|
| This file is a part of Exspresso
|
| Exspresso is free software; you can copy, modify, and distribute
| it under the terms of the MIT License
|
+--------------------------------------------------------------------+
*
* @copyright	DarkOverlordOfData (c) 2013
* @author		BruceDavidson@darkoverlordofdata.com
*
* "Yu Mo Gui Gwai Fai Di Zao" -- Uncle
*
* Class Webkat
*
*   A WebKit client to preview the local server output
*   Use for local debugging & design
*
*/

using Gtk;
using WebKit;

public class Webkat : Window {

  private const string TITLE = "WebKat";
  private const int WIDTH = 1280;
  private const int HEIGHT = 1024;

  private WebView webView;

  /**
   * Constructor
   */
  public Webkat(bool debug, string url, string title, int width, int height) {


    try {
        icon = new Gdk.Pixbuf.from_file("/usr/local/share/icons/webkat.png");
    }
    catch (Error e) {
        icon = null;
        stdout.printf("Error: %s\n", e.message);
    }
    if (icon == null) {
        try {
            icon = new Gdk.Pixbuf.from_file("../share/icons/webkat.png");
        }
        catch (Error e) {
            icon = null;
            stdout.printf("Error: %s\n", e.message);
        }

    }
    this.title = title;
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

    unowned WebView result = (new Inspector(this)).webView;
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

    string url = "http://www.google.com";
    string title = "WebView";
    string width = "1280";
    string height = "1024";
    bool mode = false;
    bool set_title = false;
    bool set_width = false;
    bool set_height = false;

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

        if (arg == "-d" ) {
            mode = true;
        }
        else if (arg == "--debug") {
            mode = true;
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

    }

    Gtk.init(ref args);
    var client = new Webkat(mode, url, title, int.parse(width), int.parse(height));
    Gtk.main();
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


