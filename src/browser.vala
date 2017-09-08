/** 
+--------------------------------------------------------------------+
| Browser.vala
+--------------------------------------------------------------------+
| Copyright DarkOverlordOfData (c) 2013 - 2017
+--------------------------------------------------------------------+
|
| This file is a part of Webkat
|
| Webkat is free software; you can copy, modify, and distribute
| it under the terms of the MIT License
|
+--------------------------------------------------------------------+
*
* @copyright	DarkOverlordOfData (c) 2013 - 2017
* @author		BruceDavidson@darkoverlordofdata.com
*
* "Yu Mo Gui Gwai Fai Di Zao" -- Uncle
*
* Class Browser
*
*
*/
using Gtk;
using WebKit;
using Soup;

public class Browser : Window 
{
    public bool use_inspector = false;
    public string url = "";
    public string width = "";
    public string height = "";
    public string name = "";
    public string iconPath = "";
    public string comment = "";
    public bool version = false;
    public bool debug = false;
    public bool webgl = false;
    public bool desktop = false;
    private WebView webView;
        /**
     * Constructor
     */
    public Browser(bool debug, bool webgl, string url, string title, int width, int height) 
    {

        try 
        {
            icon = new Gdk.Pixbuf.from_file("/usr/local/share/icons/webkat.png");
        }
        catch (Error e) 
        {
            icon = null;
            print("Error: %s\n", e.message);
        }
        if (icon == null) 
        {
            try 
            {
                var share = GLib.Environment.get_user_data_dir();
                icon = new Gdk.Pixbuf.from_file(@"$share/icons/webkat.png");
            }
            catch (Error e) 
            {
                icon = null;
                print("Error: %s\n", e.message);
            }

        }
        this.title = title;
        use_inspector = debug;
        set_default_size(width, height);

        //    Make the client window
        webView = new WebView();

        string user = Environment.get_variable("USER");
        var session = get_default_session();
        var config = GLib.Environment.get_user_config_dir();
        var cookiejar = new CookieJarText(@"$config/webkat.cookies", false);
        session.add_feature(cookiejar);

        var scrolledWindow = new ScrolledWindow(null, null);
        scrolledWindow.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scrolledWindow.add(webView);

        // Assemble the gui components
        var vbox = new VBox(false, 0);
        vbox.add(scrolledWindow);
        add(vbox);

        // Add inspector to the context menu
        WebSettings settings = webView.get_settings();
        settings.enable_developer_extras = debug;
        settings.enable_webgl = webgl;
        settings.javascript_can_open_windows_automatically = true;

        // Wire up the events
        destroy.connect(Gtk.main_quit);
        webView.title_changed.connect(titleChanged);
        webView.web_inspector.inspect_web_view.connect(inspectWebView);

        // Display
        show_all();
        webView.open(url);
        //webView.set_zoom_level((float)1.1);
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
    public void titleChanged(Object source, Object frame, string title) 
    {
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
    public unowned WebView inspectWebView(WebView v) 
    {
        unowned WebView result = null;

        if (use_inspector) 
        {
            result = (new Inspector(this)).webView;
        }
        return result;
    }

}
