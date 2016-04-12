FROM ruby:2.3

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.2.0.tar.gz

RUN mkdir -p /parti/auth-api 
WORKDIR /parti/auth-api

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test --deployment --jobs 20 --retry 5

COPY . ./

EXPOSE 3030
CMD ["deploy/docker-cmd.sh"]
