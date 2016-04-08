FROM ruby:2.3

RUN mkdir -p /parti/auth-api 
WORKDIR /parti/auth-api

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test --deployment --jobs 20 --retry 5

COPY . ./

COPY deploy/docker-cmd.sh /

EXPOSE 3030
CMD ["/docker-cmd.sh"]
