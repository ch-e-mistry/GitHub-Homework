FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
CMD [ "/bin/sh" ]