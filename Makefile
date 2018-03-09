ifdef DEBUG
CXXFLAGS ?= -g -DDEBUG
else
CXXFLAGS ?= -O3
endif

PREFIX  ?= /usr/local
CXX     ?= g++
GZIP    ?= /bin/gzip
ETCDIR	?= ${DESTDIR}/etc
MANDIR  ?= ${DESTDIR}${PREFIX}/share/man
SBINDIR ?= ${DESTDIR}${PREFIX}/sbin
UNITDIR ?= ${DESTDIR}/usr/lib/systemd/system
PKG_CONFIG ?= pkg-config
PKG_VERSION ?= $(shell git describe --tags | cut -f 1 -d-)
RPMBUILD ?= ~/rpmbuild

OBJS     = src/logger.o src/ndppd.o src/iface.o src/proxy.o src/address.o \
           src/rule.o src/session.o src/conf.o src/route.o 

ifdef WITH_ND_NETLINK
  LIBS     = `${PKG_CONFIG} --libs glib-2.0 libnl-3.0 libnl-route-3.0` -pthread
  CPPFLAGS = `${PKG_CONFIG} --cflags glib-2.0 libnl-3.0 libnl-route-3.0`
  OBJ      = ${OBJ} src/nd-netlink.o
endif

all: ndppd ndppd.1.gz ndppd.conf.5.gz

install: all
	mkdir -p ${SBINDIR} ${MANDIR} ${MANDIR}/man1 ${MANDIR}/man5 ${ETCDIR} ${UNITDIR}
	cp ndppd ${SBINDIR}
	chmod +x ${SBINDIR}/ndppd
	cp ndppd.1.gz ${MANDIR}/man1
	cp ndppd.conf.5.gz ${MANDIR}/man5
	cp ndppd.conf-dist ${ETCDIR}/ndppd.conf
	cp ndppd.service ${UNITDIR}

rpm:
	@echo "Package version: ${PKG_VERSION}"
	rpmdev-setuptree
	cd .. && tar zcf ndppd.tgz ndppd --transform 's/ndppd/ndppd-${PKG_VERSION}/' --exclude=.git
	cp ndppd.spec ${RPMBUILD}/SPECS
	cp ../ndppd.tgz ${RPMBUILD}/SOURCES
	rpmbuild -ba --define 'pkg_version ${PKG_VERSION}' ${RPMBUILD}/SPECS/ndppd.spec

rpmclean:
	@echo "Will remove ${RPMBUILD} directory. Press 'Enter' to proceed?"
	@read
	rm -fr ${RPMBUILD}
	
ndppd.1.gz:
	${GZIP} < ndppd.1 > ndppd.1.gz

ndppd.conf.5.gz:
	${GZIP} < ndppd.conf.5 > ndppd.conf.5.gz

ndppd: ${OBJS}
	${CXX} -o ndppd ${LDFLAGS} ${OBJS} ${LIBS}

nd-proxy: nd-proxy.c
	${CXX} -o nd-proxy -Wall -Werror ${LDFLAGS} `${PKG_CONFIG} --cflags glib-2.0` nd-proxy.c `${PKG_CONFIG} --libs glib-2.0`

.cc.o:
	${CXX} -c ${CPPFLAGS} $(CXXFLAGS) -o $@ $<

clean:
	rm -f ndppd ndppd.conf.5.gz ndppd.1.gz ${OBJS} nd-proxy
