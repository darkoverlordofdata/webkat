
/*
+--------------------------------------------------------------------+
| Webview
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
* Class Webview
*
*   A WebKit client to preview the local server output
*   Use for local debugging
*
*/

using Gtk;
using WebKit;

public class Webview : Window {

  private const string TITLE = "Webview";
  private const int WIDTH = 1280;
  private const int HEIGHT = 1024;

  private WebView webView;

  /**
   * Constructor
   */
  public Webview(bool debug, string url) {


    try {
        icon = new Gdk.Pixbuf.from_file("/usr/local/share/icons/webview.png");
    }
    catch (Error e) {
        icon = null;
        stdout.printf("Error: %s\n", e.message);
    }
    if (icon == null) {
        try {
            icon = new Gdk.Pixbuf.from_file("../share/icons/webview.png");
        }
        catch (Error e) {
            icon = null;
            stdout.printf("Error: %s\n", e.message);
        }

    }
    title = Webview.TITLE;
    set_default_size(Webview.WIDTH, Webview.HEIGHT);

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

    this.title = title ?? Webview.TITLE;
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

    string url = "http://localhost:53610";
    bool mode = false;

    foreach (string arg in args) {

        if (arg[0:2] == "-d" ) {
            mode = true;
        }
        else if (arg[0:7] == "--debug") {
            mode = true;
        }
        else if (arg[0:7] == "http://") {
            url = arg;
        }
        else if (arg[0:8] == "https://") {
            url = arg;
        }

    }

    Gtk.init(ref args);
    var client = new Webview(mode, url);
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
      title = "Developer Tools - " + (parent.title ?? Webview.TITLE);
      set_default_size(Webview.WIDTH, Webview.HEIGHT);

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


