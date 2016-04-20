FROM dialonce/sensu

MAINTAINER Julien Kernec'h <docker@dial-once.com>

# Install sensu plugins
RUN gem install \
  sensu-plugins-memory-checks \
  sensu-plugins-cpu-checks \
  sensu-plugins-disk-checks \
  sensu-plugins-rabbitmq \
  sensu-plugins-redis \
  # Install sensu-plugins-docker from github
  && apk add --no-cache git perl \
  && gem install specific_install \
  && gem specific_install https://github.com/sensu-plugins/sensu-plugins-docker.git \
  && gem uninstall specific_install \
  && apk del git perl

COPY conf.d /etc/sensu/conf.d

CMD dockerize \
  -template /etc/sensu/conf.d/config.tmpl:/etc/sensu/conf.d/config.json \
  -template /etc/sensu/conf.d/checks/docker.tmpl:/etc/sensu/conf.d/checks/docker.json \
  -template /etc/sensu/conf.d/checks/rabbitmq.tmpl:/etc/sensu/conf.d/checks/rabbitmq.json \
  -template /etc/sensu/conf.d/checks/redis.tmpl:/etc/sensu/conf.d/checks/redis.json \
  sensu-client -d /etc/sensu/conf.d
