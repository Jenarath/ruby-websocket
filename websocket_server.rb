require 'socket'
require 'websocket'

class WebSocketServer
  def initialize(port)
    @server = TCPServer.new(port)
    @clients = []
  end

  def start
    loop do
      socket = @server.accept
      Thread.new(socket) do |client|
        handshake = WebSocket::Handshake::Server.new
        frame = WebSocket::Frame::Incoming::Server.new

        while (data = client.gets)
          handshake << data
          puts "Received handshake data: #{data}"  # Log handshake data
          if handshake.finished?
            client.write handshake.to_s
            puts "Handshake finished, upgrading to WebSocket"
            break
          end
        end

        @clients << client

        while (data = client.gets)
          frame << data
          while (message = frame.next)
            puts "Received message: #{message}"
            broadcast(message)
          end
        end

        @clients.delete(client)
        client.close
      end
    end
  end

  def broadcast(message)
    @clients.each do |client|
      frame = WebSocket::Frame::Outgoing::Server.new(data: message, type: :text)
      client.write frame.to_s
    end
  end
end

# Start the WebSocket server
server = WebSocketServer.new(8081)
server.start