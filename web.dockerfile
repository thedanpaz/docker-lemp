FROM nginx:1.21.1

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y apache2-utils

ARG WITH_BASIC_AUTH=true

ADD nginx-vhost.conf /etc/nginx/conf.d/default.conf

RUN if [ ${WITH_BASIC_AUTH} = "true" ] ; then \
    htpasswd -cb  /etc/nginx/.htpasswd $USER1 $PASS1; \
    htpasswd -b  /etc/nginx/.htpasswd $USER2 $PASS2; \
    echo "auth_basic 'Buzz Off';" >> /etc/nginx/conf.d/basic-auth.conf; \
    echo "auth_basic_user_file /etc/nginx/.htpasswd;" >> /etc/nginx/conf.d/basic-auth.conf; \
fi ;
