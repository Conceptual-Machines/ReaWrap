# ReaWrap Test Runner - REAPER in Docker
#
# Build:   docker build -t reawrap-test tests/docker/
# Run:     docker run --rm -p 8080:8080 reawrap-test
#
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    xvfb \
    libgtk-3-0 \
    libasound2 \
    libgl1-mesa-glx \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install REAPER (Linux x86_64)
WORKDIR /tmp
RUN wget -q https://www.reaper.fm/files/7.x/reaper757_linux_x86_64.tar.xz \
    && tar xf reaper757_linux_x86_64.tar.xz \
    && ./reaper_linux_x86_64/install-reaper.sh --install /opt/reaper --integrate-desktop \
    && rm -rf /tmp/*

# Create portable config directory
RUN mkdir -p /opt/reaper-config

# Copy portable reaper.ini with web interface enabled
COPY reaper.ini /opt/reaper-config/reaper.ini

# Copy ReaWrap library
COPY lua/ /opt/reawrap/lua/

# Copy test scripts
COPY integration/ /opt/reawrap/tests/

# Set working directory
WORKDIR /opt/reawrap

# Expose web interface port
EXPOSE 8080

# Entry script
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
