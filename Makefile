# type 'make -s list' to see list of targets.
checkout-project:
	git checkout develop
	git submodule update --init --recursive

setup-project:
	make checkout-project
	cd presentation && npm install
	cd presentation-stubulator && npm install

test-app-ci:
	make checkout-project
	cd presentation-functional && make test-app-ci

ide-idea-clean:
	rm -rf *iml
	rm -rf .idea*

.PHONY: no_targets__ list
no_targets__:
list:
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort"
