prefix=/usr/local
starup_type=systemd

all: mcss mcssd

.PHONY: install install-links
install: all
	install -m 0755 mcss $(prefix)/bin
	install -m 0755 mcssd $(prefix)/bin

	install -m 0644 mcss.conf /etc
	mkdir -p /etc/mcss.d
	install -m 0644 default.conf.example /etc/mcss.d
ifeq ($(startup_type),openrc)
	install -m 0755 distfiles/openrc/mcss.initd /etc/init.d/mcss
else ifeq ($(startup_type),systemd)
	install -m 0644 distfiles/systemd/mcss.systemd /lib/systemd/system/mcss.service
else ifeq ($(startup_type),sysv)
	install -m 0755 distfiles/sysv/mcss.initd /etc/init.d/mcss
	chkconfig --add mcss
endif

	mkdir -p $(prefix)/share/mcss $(prefix)/share/doc/mcss
	install -m 0644 settings.mcss.example $(prefix)/share/mcss
	install -m 0644 LICENSE $(prefix)/share/doc/mcss

	mkdir -p /var/lib/mcss

install-links: install
	ln -sf $(PWD)/mcss $(prefix)/bin/mcss
	ln -sf $(PWD)/mcssd $(prefix)/bin/mcssd

.PHONY: uninstall
uninstall:
	rm $(prefix)/bin/{mcss,mcssd}

	rm /etc/mcss.conf
	rm -r /etc/mcss.d

ifeq ($(startup_type),openrc)
	rm /etc/init.d/mcss
else ifeq ($(startup_type),systemd)
	rm /lib/systemd/system/mcss.service
else ifeq ($(startup_type),sysv)
	chkconfig --del mcss
	rm /etc/init.d/mcss
endif
	
	rm -r $(prefix)/share/mcss $(prefix)/share/doc/mcss

	rm -r /var/lib/mcss
