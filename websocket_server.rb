require "socketify"

Socketify::App.new()
.get("/", lambda {|response, request| response.end("Hello World socketify from Ruby!")})
.listen(8081, lambda {|config| puts "Listening on port #{config.port}" })
.run()