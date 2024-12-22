FROM ruby:2.4.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN gem install faye-websocket eventmachine

COPY . .

EXPOSE 8081

CMD ["ruby", "websocket_server.rb"]