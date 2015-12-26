prefix=/usr/local

.PHONY: install install-links
install: mcss mcssd
	install -m 0755 mcss $(prefix)/bin
	install -m 0755 mcssd $(prefix)/bin

	install -m 0644 mcss.conf /etc
	mkdir -p /etc/mcss.d
	install -m 0644 default.conf.example /etc/mcss.d

	install -m 0644 mcss.systemd /lib/systemd/system/mcss.service

	mkdir -p $(prefix)/share/mcss $(prefix)/share/doc/mcss
	install -m 0644 settings.mcss.example $(prefix)/share/mcss
	install -m 0644 LICENSE $(prefix)/share/doc/mcss

install-links: install
	ln -sf $(PWD)/mcss $(prefix)/bin/mcss
	ln -sf $(PWD)/mcssd $(prefix)/bin/mcssd

	#ln -sf $(PWD)/mcss.systemd /lib/systemd/system/mcss.service

.PHONY: uninstall
uninstall:
	rm $(prefix)/bin/{mcss,mcssd}

	rm /etc/mcss.conf
	rm -r /etc/mcss.d

	rm /lib/systemd/system/mcss.service
	
	rm -r $(prefix)/share/mcss $(prefix)/share/doc/mcss
