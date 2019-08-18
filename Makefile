dest := /usr/local/bin
scripts := $(dest)/terraform-ondock.sh $(dest)/tflint-ondock.sh
symlinks := $(dest)/terraform $(dest)/tflint
files := $(scripts) $(symlinks)
images := hashicorp/terraform:light wata727/tflint

$(scripts):
	cp -f $$(basename $@) $@
	chmod +x $@

$(symlinks):
	ln -s $(dest)/$$(basename $@)-ondock.sh $@

images:
	for image in $(images); do \
	  if ! docker images --format="{{.Repository}}:{{.Tag}}" | grep -q $$image; then \
	    docker pull $$image ; \
	  fi \
	done

.PHONY: install
install: $(files) images

.PHONY: uninstall
uninstall:
	rm -f $(files)

.PHONY: rmi
rmi:
	for image in $(images); do \
	  docker rmi $$image ; \
	done
