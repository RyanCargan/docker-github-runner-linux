# Dockerfile for apt-cacher-ng
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y apt-cacher-ng

# Modify the apt-cacher-ng configuration to allow HTTPS bypass
RUN echo "PassThroughPattern: .*" >> /etc/apt-cacher-ng/acng.conf

EXPOSE 3142

CMD ["apt-cacher-ng", "-c", "/etc/apt-cacher-ng", "ForeGround=1"]
