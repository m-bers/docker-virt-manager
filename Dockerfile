FROM mber5/broadway-baseimage:latest

ENV FAVICON_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV APP_TITLE='Virtual Machine Manager'
ENV CORNER_IMAGE_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV HOSTS="[]"

RUN apt-get update
RUN apt-get install -y --no-install-recommends virt-manager dbus-x11 libglib2.0-bin gir1.2-spiceclientgtk-3.0 ssh wget
RUN apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*
RUN wget -O /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)"
RUN chmod +x /usr/bin/ttyd

RUN mkdir -p /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

COPY startapp.sh /usr/local/bin/startapp

CMD ["/usr/local/bin/startapp"]
