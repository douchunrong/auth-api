FROM ruby:2.3

RUN mkdir -p /parti/auth-api 
WORKDIR /parti/auth-api

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test --deployment --jobs 20 --retry 5

COPY . ./

EXPOSE 3030

CMD (test -f /volume/shared/is_leader && bin/rake db:migrate); bin/rails server -p 3030 -b 0.0.0.0
