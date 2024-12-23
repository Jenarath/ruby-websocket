require 'faye/websocket'
require 'eventmachine'

class WebSocketServer
  def self.start
    EM.run do
      @clients = []

      # Start a TCP server
      EM.start_server('0.0.0.0', 8081, nil) do |connection|
        # Initialize the WebSocket
        ws = Faye::WebSocket.new(connection)

        ws.on(:open) do |event|
          puts 'Client connected'
          @clients << ws
        end

        ws.on(:message) do |event|
          puts "Received message: #{event.data}"
          # Broadcast the message to all connected clients
          @clients.each { |client| client.send(event.data) }
        end

        ws.on(:close) do |event|
          puts 'Client disconnected'
          @clients.delete(ws)
          ws = nil
        end
      end
    end
  end
end

# Start the server
WebSocketServer.start
