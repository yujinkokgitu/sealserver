FROM ubuntu:latest
RUN mkdir -p /mining && chmod 777 /mining && apt-get update -y && apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential vim wget git -y && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/ && git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git && mv ccminer /mining && cd /mining/ccminer && bash build.sh
COPY start-mining /bin/start-mining
CMD start-mining
