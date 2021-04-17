FROM ruby:3.0.0

#Update system
RUN apt-get -y update && apt-get -y upgrade

#Install packeges
RUN apt-get install -y nodejs postgresql yarn

#Move needs files
COPY ./start.sh /
RUN chmod +x start.sh

# Set working directory
WORKDIR /tabletennis
COPY ./tabletennis /tabletennis

RUN rm -rf ./tabletennis/tmp/pids/server.pid

# install rails
RUN gem update --system
RUN gem install rails
RUN gem install rails bundler

#Install all gems
RUN bundle install

CMD start.sh

