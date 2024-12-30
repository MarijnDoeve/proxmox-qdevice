FROM debian:bullseye-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    supervisor \
    openssh-server \
    corosync-qnetd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY set_root_password.sh /usr/local/bin/set_root_password.sh
RUN chown root.root /usr/local/bin/set_root_password.sh \
    && chmod 755 /usr/local/bin/set_root_password.sh

RUN mkdir -p /run/sshd

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 22
EXPOSE 5403

CMD ["/usr/bin/supervisord"]
