FROM ruby:2.3

RUN mkdir -p /parti/auth-api 
WORKDIR /parti/auth-api

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test --deployment --jobs 20 --retry 5

COPY . ./

EXPOSE 3030
CMD ["bin/docker-cmd.sh"]
