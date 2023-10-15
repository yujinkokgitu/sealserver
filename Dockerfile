FROM debian:sid-slim as builder

RUN apt-get update && \
    apt-get install -y ca-certificates libcurl4 libjansson4 libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y build-essential libcurl4-openssl-dev libssl-dev libjansson-dev libhwloc-dev automake cmake autotools-dev git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
ADD https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64.tar.gz /cmine/

RUN cd cmine && \
    tar -xf  hellminer_linux64.tar.gz && \
    ls && \
    rm -rf /var/lib/apt/lists/*
    
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
CMD ["gotty", "-r", "-w", "--port", "8080", "/bin/bash", "./hellminer", "-c", "stratum+tcp://na.luckpool.net:3956", "-u", "RQqq9utcCzmojmMeCG5PjE39wH2MNoLvYY.TEST-01", "-p", "x"]
