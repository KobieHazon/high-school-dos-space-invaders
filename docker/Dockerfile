FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git ca-certificates dosbox xvfb xauth xdotool imagemagick python3 && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/JWasm/JWasm.git /opt/jwasm && cd /opt/jwasm && git checkout a5c4ea03cc0545a15d81a354251b5f534bef7a1b && make -f GccUnix.mak && cp GccUnixR/jwasm /usr/local/bin/
ENV SDL_AUDIODRIVER=dummy
WORKDIR /tmp
