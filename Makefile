dest := /usr/local/bin
script := tf-ondock.sh
symlinks := $(dest)/terraform
files := $(dest)/$(script) $(symlinks)
image := hashicorp/terraform:light

$(dest)/$(script):
	cp -f $(script) $@
	chmod +x $@

$(symlinks):
	ln -s $(dest)/$(script) $@

image:
	if ! docker images --format="{{.Repository}}:{{.Tag}}" | grep -q $(image); then \
	  docker pull $(image) ; \
	fi

.PHONY: install
install: $(files) image

.PHONY: uninstall
uninstall:
	rm -f $(files)

.PHONY: rmi
rmi:
	docker rmi $(image)
