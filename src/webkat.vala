/** 
+--------------------------------------------------------------------+
| Webkat.vala
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
* Class Webkat
*
*
*/

using Gtk;
using WebKit;
using Soup;

public class Webkat : Object {

    /**
     * Defaults
     */
    public const string TITLE = "WebKat";
    public const int WIDTH = 1280;
    public const int HEIGHT = 1024;
    public const string URL = "http://localhost";
    

    /**
     * Args
     */
    static int height = 0;
    static int width = 0;
    static string? title = null;
    static bool debug = false;
    static bool webgl = false;
    static bool version = false;
    static string? name = null;
    static string? iconPath = null;
    static string? comment = null;
    [CCode (array_length = false, array_null_terminated = true)]
    static string[] urls;
    static string url;
    static bool desktop = false;

    /**
     * command line options
     */
    const OptionEntry[] options =
    {
            { "height", 'h', 0, OptionArg.INT, ref height, "height in pixels", null },
            { "width", 'w', 0, OptionArg.INT, ref width, "width in pixels", null },
            { "title", 't', 0, OptionArg.STRING, ref title, "title bar text", null },
            { "debug", 'd', 0, OptionArg.NONE, ref debug, "debug mode?", null },
            { "webgl", 'g', 0, OptionArg.NONE, ref webgl, "enable webgl", null },
            { "version", 'v', 0, OptionArg.NONE, ref version, "debug mode?", null },
            { "name", 'n', 0, OptionArg.STRING, ref name, "desktop file name", null },
            { "icon", 'i', 0, OptionArg.STRING, ref iconPath, "desktop icon", null },
            { "comment", 'c', 0, OptionArg.STRING, ref comment, "desktop comment", null },		
            { "", 0, 0, OptionArg.FILENAME_ARRAY, ref urls, null, "FILE..." },
            { null }
    };

    /**
     * entry point
     */
    public static int main(string[] args) {

        try 
        {
            var opt_context = new OptionContext ("- WebKat");
            opt_context.set_help_enabled (true);
            opt_context.add_main_entries (options, null);
            if (opt_context.parse (ref args) != true) 
            {
                    print("Error parsing args...\n");
                    return 0;                        
            }
        } 
        catch (OptionError e) 
        {
            print("error: %s\n", e.message);
            print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
            return 0;
        }

        if (version) 
        {
            print("WebKat Beta 0.0.3\n");
            return 0;
        }

        url = urls.length > 0 ? urls[0] : URL;
        title = title == null ? TITLE : title;
        width = width == 0 ? WIDTH : width;
        height = height == 0 ? HEIGHT : height;
            
        if (desktop) 
        {
            MainLoop loop = new MainLoop ();
            string template = """[Desktop Entry]
Comment=%s
Terminal=false
Name=%s
Exec=webkat %s
Type=Application
Icon=%s
""";
            try 
            {
                
                string user = Environment.get_variable("USER");
                string path = "/home/%s/Desktop/%s.desktop".printf(user, name);
                string webgl_flag = webgl ? "--webgl" : "";
                
                string cmd = "%s --title %s --width %d --height %d %s".printf(url, title, width, height, webgl_flag);
                
                var file = File.new_for_path(path);
                {
                    var file_stream = file.create(FileCreateFlags.NONE);
                    var data_stream = new DataOutputStream(file_stream);
                    data_stream.put_string(template.printf(comment, name, cmd, iconPath));
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
                
            } 
            catch (Error e) 
            {
                    stderr.printf ("Error: %s\n", e.message);
                    return 1;
            }		
        }
        else 
        {
            Gtk.init(ref args);
            var client = new Browser(debug, webgl, url, title, width, height);
            Gtk.main();
        }

        return 0;
    }        
}

