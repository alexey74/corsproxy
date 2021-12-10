# Copyright (C) 2013 Mark Blakeney. This program is distributed under
# the terms of the GNU General Public License.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or any
# later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License at <http://www.gnu.org/licenses/> for more
# details.

NAME = $(shell basename $(CURDIR))

dev-up:
	pipenv run python corsproxy

up: build
	docker run -v ~/.config/corsproxy:/root/.config/corsproxy \
		-p 9000:9000 -p 9031:9031 \
		--add-host host.docker.internal:host-gateway \
		--restart always -d --name $(NAME) $(NAME)

build:
	docker build -t $(NAME) .

check:
	flake8 $(NAME)
	shellcheck *.sh
	vermin -i -q --no-tips $(NAME)

docker:
	./docker.sh

clean:
	rm -rf *.pyc  __pycache__
	
down:
	docker update --restart no ${NAME}
	docker kill ${NAME}
	docker rm ${NAME}
	
log:
	docker logs $(NAME) -f

