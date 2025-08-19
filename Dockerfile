FROM debian:stable-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      ca-certificates \
      build-essential \
      autoconf \
      automake \
      libtool \
      libsndfile-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Clone the repository
RUN cd /opt && git clone https://github.com/lucat/leqm-nrt.git

WORKDIR /opt/leqm-nrt

# Prepare for building (if needed)
RUN if [ -f "./autogen.sh" ]; then \
      ./autogen.sh; \
    else \
      echo "No autogen.sh found; assuming configure is present."; \
    fi

# Configure, build, and install
RUN autoreconf -f -i && \
    chmod +x configure && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install

ENTRYPOINT ["leqm-nrt"]
CMD ["--help"]

