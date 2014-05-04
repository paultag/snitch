# Base image
#
# VERSION   0.1
FROM        paultag/uwsgi:latest
MAINTAINER  Paul R. Tagliamonte <paultag@debian.org>

RUN mkdir -p /opt/hylang/snitch/
RUN apt-get update && apt-get install -y \
    node-less \
    inkscape \
    pngcrush \
    git \
    python2.7 python-pip \
    uwsgi uwsgi-plugin-python \
    python-all-dev

ADD . /opt/hylang/snitch
RUN cd /opt/hylang/; git clone git://github.com/hylang/hy.git
RUN cd /opt/hylang/hy; python2.7 /usr/bin/pip install -e .

RUN cd /opt/hylang/snitch; python2.7 /usr/bin/pip install pymongo
RUN cd /opt/hylang/snitch; python2.7 /usr/bin/pip install -r requirements-site.txt
RUN cd /opt/hylang/snitch; python2.7 /usr/bin/pip install -e .
RUN make -C /opt/hylang/snitch/web static

RUN adduser --system snitch

ADD uwsgi.ini /etc/uwsgi/apps-enabled/
CMD ["uwsgi", "--ini", "/etc/uwsgi/apps-enabled/uwsgi.ini"]
