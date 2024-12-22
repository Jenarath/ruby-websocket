require 'faye/websocket'
require 'eventmachine'

class WebSocketServer
  def self.start
    EM.run do
      @clients = []

      EM.start_server('0.0.0.0', 8081) do |connection|
        driver = Faye::WebSocket::Driver.server(connection)

        driver.on(:open) do
          puts 'Client connected'
          @clients << driver
        end

        driver.on(:message) do |event|
          puts "Received message: #{event.data}"
          @clients.each { |client| client.text(event.data) }
        end

        driver.on(:close) do
          puts 'Client disconnected'
          @clients.delete(driver)
        end

        connection.on(:data) { |data| driver.parse(data) }
        connection.on(:close) { driver.emit(:close) }
      end
    end
  end
end

# Start the server
WebSocketServer.start
