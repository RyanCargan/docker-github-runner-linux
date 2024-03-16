FROM ubuntu:20.04

RUN apt-get update && apt-get install -y squid-deb-proxy

# Optional: Basic Access Control List (replace with your network)
RUN echo 'acl localnet src 192.168.0.0/16' >> /etc/squid-deb-proxy/mirror-dstdomain.acl
# RUN echo 'http_access allow localnet' >> /etc/squid-deb-proxy/access.conf
RUN echo 'http_access allow all' >> /etc/squid-deb-proxy/access.conf

EXPOSE 3142

CMD ["squid-deb-proxy", "-f", "/etc/squid-deb-proxy/squid-deb-proxy.conf"] 
