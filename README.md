#WebView


A webkit shell for viewing localhost output.


##Example

Initialize an express server

'''coffeescript
{exec} = require('child_process')
express = require('express')
app = express()
'''


Start up server and view outut in webview.
Wait for webview to end and close the server.

'''coffeescript
app.listen 3000, ->

    console.log 'Listening on port 3000'
    exec "#{FCPATH}bin/desktop http://localhost:3000", (err, stdout, stderr) ->
        console.log stderr if stderr?
        console.log stdout if stdout?
'''

