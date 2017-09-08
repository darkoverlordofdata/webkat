/** 
+--------------------------------------------------------------------+
| Inspector.vala
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
* Class Inspector
*
*
*/
using Gtk;
using WebKit;
using Soup;

/**
 *
 * Class Inspector
 *
 * Wrap the web_inspector in it's own window
 *
 */
class Inspector : Window 
{

    public WebView webView;

    /**
     *    Display the web_inspector
     */
    public Inspector(Window parent) 
    {

        icon = parent.icon;
        title = "Developer Tools - " + (parent.title ?? Webkat.TITLE);
        set_default_size(Webkat.WIDTH, Webkat.HEIGHT);

        //    Make the client window
        webView = new WebView();
        var scrolledWindow = new ScrolledWindow(null, null);
        scrolledWindow.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scrolledWindow.add(webView);
        add(scrolledWindow);

        show_all();
    }

    /**
     *    Teardown
     */
    ~Inspector() 
    {
        webView.web_inspector.close();
    }
}


