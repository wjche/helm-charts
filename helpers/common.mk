default: test

.ONESHELL:

lint:
	grep 'charts/' ./.helmignore || echo 'charts/' >> ./.helmignore
	helm lint --strict ./

template:
	helm template ./

build:
	cd ../helpers/helm-tester && \
	docker build -t helm-tester .

pytest:
	pytest -sv --color=yes

deps:
	sed --in-place '/charts\//d' ./.helmignore
	helm dependency update

test-all: lint deps template pytest

test: build
	docker run --rm -i --user "$$(id -u):$$(id -g)" -v $$(pwd)/../:/app -w /app/$$(basename $$(pwd)) helm-tester make test-all

helm:
	kubectl get cs
	kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default || true
	helm init --wait --upgrade
