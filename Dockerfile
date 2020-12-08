FROM ubuntu

ENV GDK_BACKEND=broadway
ENV BROADWAY_DISPLAY=:5

RUN apt-get update
RUN apt-get install -y --no-install-recommends libgtk-3-0 libgtk-3-bin nginx gettext-base virt-manager dbus-x11 libglib2.0-bin gir1.2-spiceclientgtk-3.0 ssh 
RUN apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

COPY start.sh /usr/local/bin/start
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8185

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/usr/local/bin/start"]
