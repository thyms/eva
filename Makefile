# type 'make -s list' to see list of targets.

package-node:
	cd $(applicationName) && npm install
	tar cvf $(projectName)-$(applicationName).tar.gz $(applicationName) > /dev/null 2>&1

deploy-node:
	ssh $(user)@$(serverTarget) "ps -ef | grep -v grep | grep npm | grep $(projectName) | grep $(applicationName) | awk '{print \$$2}' | tr -d '\n' | xargs -0 -I processId kill -- -processId"
	ssh $(user)@$(serverTarget) rm -rf workspace/$(projectName)-$(applicationName)*
	scp $(projectName)-$(applicationName).tar.gz $(user)@$(serverTarget):~/workspace
	ssh $(user)@$(serverTarget) tar xvf workspace/$(projectName)-$(applicationName).tar.gz -C workspace > /dev/null 2>&1
	ssh $(user)@$(serverTarget) mv workspace/$(applicationName) workspace/$(projectName)-$(applicationName)
	ssh $(user)@$(serverTarget) "cd workspace/$(projectName)-$(applicationName) && NODE_ENV=$(environment) PORT=$(serverPort) ~/.nvm/v0.10.0/bin/npm start > log/$(applicationName).log 2>&1" &

setup-project:
	git checkout develop
	git submodule update --init --recursive
	cd presentation && npm install
	cd presentation-stubulator && npm install

ide-idea-clean:
	rm -rf *iml
	rm -rf .idea*

.PHONY: no_targets__ list
no_targets__:
list:
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort"
