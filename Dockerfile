FROM ruby:2.7.1
MAINTAINER David J. Davis <ddavisgraphics>

# Install capybara-webkit deps
RUN apt update \
    && apt-get install -y xvfb git qt5-default libqt5webkit5-dev \
                          gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

# Use JEMALLOC instead
# JEMalloc is a faster garbage collection for Ruby.
# -------------------------------------------------------------------------------------------------
RUN apt-get install -y libjemalloc2 libjemalloc-dev
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so
# -------------------------------------------------------------------------------------------------

# FFMPEG CODECS Uncomment if you need to install them. 
# ------------------------------------------------------------------------------------
# RUN apt-get coreutils freetype-dev lame-dev libogg-dev libass libass-dev libvpx-dev libvorbis-dev libwebp-dev libtheora-dev 
# -------------------------------------------------------------------------------------------------

# Tesseract
# -------------------------------------------------------------------------------------------------
RUN apt-get install -y libleptonica-dev libtesseract-dev tesseract-ocr
# ------------------------------------------------------------------------------------------------- 

# ImageMagic Conversions and FFMPEG Conversions
# -------------------------------------------------------------------------------------------------
RUN apt-get install -y imagemagick ghostscript ffmpeg 
# -------------------------------------------------------------------------------------------------

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