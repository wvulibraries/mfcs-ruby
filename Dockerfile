FROM ruby:2.6.3
MAINTAINER David J. Davis <ddavisgraphics>

# Install capybara-webkit deps
RUN apt-get update \
    && apt-get install -y xvfb git qt5-default libqt5webkit5-dev \
                          gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

# Use JEMALLOC instead
RUN apt-get install libjemalloc1 && rm -rf /var/lib/apt/lists/*
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.1

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn
		
# Install our dependencies and rails
RUN gem install bundler \
	&& gem install rails \
	&& mkdir -p /home/mfcs

# ENV RAILS_ENV development
# ENV RACK_ENV development

WORKDIR /home/mfcs
COPY ./ /home/mfcs
RUN bundle install --jobs=4 --retry=3 
RUN yarn install && yarn upgrade