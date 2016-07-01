FROM ruby:2.3.0
MAINTAINER Sebastian Schkudlara "sebastian.schkudlara@vizzuality.com"

RUN apt-get update -qq && apt-get install -y build-essential

RUN mkdir /rw_embed

RUN gem install bundler --no-ri --no-rdoc

WORKDIR /rw_embed
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /rw_embed

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3015

ENTRYPOINT ["./entrypoint.sh"]
