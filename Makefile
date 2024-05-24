#
# Copyright (C) 2024  Appvia Ltd <info@appvia.io>
#  
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
AUTHOR_EMAIL=info@appvia.io

.PHONY: all security lint format documentation documentation-examples validate-all validate validate-examples init

default: all

all: 
	$(MAKE) init
	$(MAKE) validate
	$(MAKE) lint
	$(MAKE) security
	$(MAKE) format
	$(MAKE) documentation

examples:
	$(MAKE) validate-examples
	$(MAKE) lint-examples
	$(MAKE) lint
	$(MAKE) security
	$(MAKE) format
	$(MAKE) documentation

documentation: 
	@echo "--> Generating documentation"
	@terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .
	$(MAKE) documentation-modules
	$(MAKE) documentation-examples

documentation-modules:
	@echo "--> Generating documentation for modules"
	@if [ -d modules ]; then \
		find modules -type d -mindepth 1 -maxdepth 1 -exec terraform-docs markdown table --output-file README.md --output-mode inject {} \; ; \
	fi

documentation-examples:
	@echo "--> Generating documentation examples"
	@find examples -type d -mindepth 1 -maxdepth 1 -exec terraform-docs markdown table --output-file README.md --output-mode inject {} \;

init: 
	@echo "--> Running terraform init"
	@terraform init -backend=false

security: 
	@echo "--> Running Security checks"
	@tfsec .
	$(MAKE) security-modules
	$(MAKE) security-examples

security-modules:
	@echo "--> Running Security checks on modules"
	@if [ -d modules ]; then \
		find modules -type d -mindepth 1 -maxdepth 1 | while read -r dir; do \
			echo "--> Validating $$dir"; \
			tfsec $$dir; \
		done; \
	fi

security-examples:
	@echo "--> Running Security checks on examples"
	@if [ -d examples ]; then \
		find examples -type d -mindepth 1 -maxdepth 1 | while read -r dir; do \
			echo "--> Validating $$dir"; \
			tfsec $$dir; \
		done; \
	fi

validate:
	@echo "--> Running terraform validate"
	@terraform init -backend=false
	@terraform validate
	$(MAKE) validate-modules
	$(MAKE) validate-examples

validate-modules:
	@echo "--> Running terraform validate on modules"
	@if [ -d modules ]; then \
		find modules -type d -mindepth 1 -maxdepth 1 | while read -r dir; do \
			echo "--> Validating $$dir"; \
			terraform -chdir=$$dir init -backend=false; \
			terraform -chdir=$$dir validate; \
		done; \
	fi

validate-examples:
	@echo "--> Running terraform validate on examples"
	@if [ -d examples ]; then \
		find examples -type d -mindepth 1 -maxdepth 1 | while read -r dir; do \
			echo "--> Validating $$dir"; \
			terraform -chdir=$$dir init -backend=false; \
			terraform -chdir=$$dir validate; \
		done; \
	fi

lint:
	@echo "--> Running tflint"
	@tflint --init 
	@tflint -f compact
	$(MAKE) lint-modules
	$(MAKE) lint-examples

lint-modules:
	@echo "--> Running tflint on modules"
	@if [ -d modules ]; then \
		find modules -type d -mindepth 1 -maxdepth 1 | while read -r dir; do \
			echo "--> Linting $$dir"; \
			tflint --chdir=$$dir --init; \
			tflint --chdir=$$dir -f compact; \
		done; \
	fi

lint-examples:
	@echo "--> Running tflint on examples"
	@if [ -d examples ]; then \
		find examples -type d -mindepth 1 -maxdepth 1 | while read -r dir; do \
			echo "--> Linting $$dir"; \
			tflint --chdir=$$dir --init; \
			tflint --chdir=$$dir -f compact; \
		done; \
	fi

format: 
	@echo "--> Running terraform fmt"
	@terraform fmt -recursive -write=true

clean:
	@echo "--> Cleaning up"
	@find . -type d -name ".terraform" | while read -r dir; do \
		echo "--> Removing $$dir"; \
		rm -rf $$dir; \
	done
