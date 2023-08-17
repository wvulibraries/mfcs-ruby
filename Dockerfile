FROM ruby:2.7.8

ENV NODE_VERSION=16
ENV PROJECT_PATH=mfcs

RUN mkdir -p /home/${PROJECT_PATH}
WORKDIR /home/${PROJECT_PATH}
ADD ./${PROJECT_PATH}/Gemfile /home/${PROJECT_PATH}/Gemfile
ADD ./${PROJECT_PATH}/Gemfile.lock /home/${PROJECT_PATH}/Gemfile.lock
ADD ./${PROJECT_PATH}/package.json /home/${PROJECT_PATH}/package.json
ADD ./${PROJECT_PATH}/yarn.lock /home/${PROJECT_PATH}/yarn.lock

# Update all the things
RUN apt-get update

# Generate UTF-8 locale
RUN apt-get install -y locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

# Set UTF-8
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install capybara-webkit deps
# RUN apt update \
#     && apt-get install -y xvfb git qt5-default libqt5webkit5-dev \
#                           gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x                        

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
# -------------------------------------------------------------------------------------------------
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
	&& apt-get -y install nodejs

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