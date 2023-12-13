# Dockerfile for apt-cacher-ng
FROM ubuntu:20.04

RUN apt-get update && \
	apt-get install -y apt-cacher-ng

EXPOSE 3142

CMD ["apt-cacher-ng", "-c", "/etc/apt-cacher-ng", "ForeGround=1"]
