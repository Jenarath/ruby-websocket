FROM ruby:2.4.2

# Set working directory
WORKDIR /app

# Install Bundler 2
RUN gem install bundler:2.2.0

# Copy Gemfile and Gemfile.lock
COPY Gemfile ./

# Install gems using Bundler 2
RUN bundle install

# Install additional gems (faye-websocket, eventmachine)
# RUN gem install faye-websocket eventmachine

# Copy the rest of the application
COPY . .

# Expose the port
EXPOSE 8081

# Command to run the websocket server
CMD ["ruby", "websocket_server.rb"]
# CMD ["sh", "-c", "ruby websocket_server.rb & ruby api_server.rb"]
