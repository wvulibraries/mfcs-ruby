FROM ruby:2.7.2

RUN mkdir -p /home/mfcs
WORKDIR /home/mfcs
ADD ./ /home/mfcs

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
RUN apt-get install -y graphicsmagick ghostscript ffmpeg libgs-dev 
# -------------------------------------------------------------------------------------------------

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn
		
RUN \
  gem update --system --quiet && \
  gem install bundler && \
  gem install rails  && \
  bundle install

RUN yarn install && yarn upgrade