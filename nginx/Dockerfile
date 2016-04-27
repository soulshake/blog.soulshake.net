FROM nginx:latest
MAINTAINER AJ Bowen <aj@soulshake.net>
COPY nginx.conf /etc/nginx/nginx.conf
COPY www /etc/www
# Add hugo to /etc/hosts before testing nginx config; it should just be temporary
#RUN echo "127.0.0.1 hugo" >> /etc/hosts && cat /etc/hosts && nginx -t && head -n -1 > /etc/hosts
