require 'faye/websocket'
require 'eventmachine'

class WebSocketServer
  def self.start
    EM.run do
      @clients = []

      # Start the server
      EM.start_server('0.0.0.0', 8081) do |connection|
        ws = Faye::WebSocket.new(connection)  # Use this to create a WebSocket

        # Handle open connection
        ws.on :open do |event|
          puts 'Client connected'
          @clients << ws
        end

        # Handle received message
        ws.on :message do |event|
          puts "Received message: #{event.data}"
          # Broadcast the message to all connected clients
          @clients.each { |client| client.send(event.data) }
        end

        # Handle close connection
        ws.on :close do |event|
          puts 'Client disconnected'
          @clients.delete(ws)
        end
      end
    end
  end
end

# Start the WebSocket server
WebSocketServer.start
