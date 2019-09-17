FROM ruby:2.5.1

COPY . /application

WORKDIR /application
RUN bundle install \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

CMD rails server
