FROM debian:sid-slim as builder

RUN apt-get update && \
    apt-get install -y ca-certificates libcurl4 libjansson4 libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y build-essential libcurl4-openssl-dev libssl-dev libjansson-dev libhwloc-dev automake cmake autotools-dev git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir cmine && \
    cd cmine && \
    git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git && \
    cd ccminer && \
    chmod +x build.sh configure.sh autogen.sh && \
    ./build.sh && \
    cd .. && \
    rm -rf ccminer
    
FROM modenaf360/gotty:latest

RUN apt-get update \
    && apt-get install screen \
    && apt-get install -y \
    wget \
    git \
    libcurl3 \
    libcurl4-openssl-dev \
    ca-certificates \
    libssl-dev \
    libjansson-dev \
    libjansson4 \
    libhwloc-dev\
    autotools-dev \
    && rm -rf /var/lib/apt/lists/*
    
COPY --from=builder /cmine .
EXPOSE 8080

# Start Gotty with the specified command
CMD ["gotty", "-r", "-w", "--port", "8080", "/bin/bash"]
