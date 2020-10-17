FROM alpine:3.9 as builder

RUN set -eux \
	&& apk add --no-cache \
		bc \
		gcc \
		libffi-dev \
		make \
		musl-dev \
		openssl-dev \
		python3 \
		python3-dev

ARG VERSION
RUN set -eux \
	&& if [ "${VERSION}" = "latest" ]; then \
		pip3 install --no-cache-dir --no-compile ansible docker; \
	else \
		pip3 install --no-cache-dir --no-compile "ansible>=${VERSION},<$(echo "${VERSION}+0.1" | bc)" docker; \
	fi \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf


FROM alpine:3.9 as production
ARG VERSION
RUN set -eux \
	&& apk add --no-cache python3 openssh\
	&& ln -sf /usr/bin/python3 /usr/bin/python \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf
COPY --from=builder /usr/lib/python3.6/site-packages/ /usr/lib/python3.6/site-packages/
COPY --from=builder /usr/bin/ansible /usr/bin/ansible
COPY --from=builder /usr/bin/ansible-connection /usr/bin/ansible-connection
COPY --from=builder /usr/bin/ansible-config /usr/bin/ansible-config
COPY --from=builder /usr/bin/ansible-console /usr/bin/ansible-console
COPY --from=builder /usr/bin/ansible-doc /usr/bin/ansible-doc
COPY --from=builder /usr/bin/ansible-galaxy /usr/bin/ansible-galaxy
COPY --from=builder /usr/bin/ansible-inventory /usr/bin/ansible-inventory
COPY --from=builder /usr/bin/ansible-playbook /usr/bin/ansible-playbook
COPY --from=builder /usr/bin/ansible-pull /usr/bin/ansible-pull
COPY --from=builder /usr/bin/ansible-test /usr/bin/ansible-test
COPY --from=builder /usr/bin/ansible-vault /usr/bin/ansible-vault
WORKDIR /data
CMD ["/usr/bin/ansible"]
