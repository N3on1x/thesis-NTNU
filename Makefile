
SRCS=\
	$(wildcard appendices/*) \
	$(wildcard chapters/*) \
	$(wildcard csvtables/*) \
	$(wildcard figures/*) \
	$(wildcard listings/*) \
	$(wildcard papers/*) \
	ntnuthesis.cls \
	thesis.bib \
	glossary.tex \
	thesis.tex

LATEX_FLAGS=-shell-escape -file-line-error
BIBER_FLAGS=

DOCKER_MOUNT_SOURCE = $(CURDIR)
DOCKER_MOUNT_TARGET = /home/thesis-NTNU
DOCKER_CONTAINER_NAME = thesis_ntnu

mkdir = @mkdir -p $(@D)

thesis.pdf: $(SRCS)
	$(mkdir)
	pdflatex $(LATEX_FLAGS) thesis
	biber $(BIBER_FLAGS) thesis
	makeglossaries thesis
	pdflatex $(LATEX_FLAGS) thesis
	pdflatex $(LATEX_FLAGS) thesis

clean:
	-@$(RM) \
		$(wildcard thesis-gnuplottex*) \
		$(addprefix thesis,.gnuploterrors .aux .bbl .bcf .blg .lof .log .lol .lot .out .pdf .run.xml .toc .acn .glo .ist .acr .alg .glg .gls .fdb_latexmk .fls .synctex.gz)
.PHONY: clean

.PHONY: auto-compile
auto-compile: $(SRCS)
	latexmk \
		-silent -pdf -pvc -view=none \
		-r "conf/glossaries.latexmk" \
		-pdflatex="pdflatex -interaction=nonstopmode -synctex=1 $(LATEX_FLAGS)" \
		thesis

.PHONY: docker-build
docker-build: docker/Dockerfile
	docker build -t thesis-ntnu -	< docker/Dockerfile

.PHONY: docker-run
docker-run:
	docker run --rm -it \
		--name $(DOCKER_CONTAINER_NAME) \
		--mount type=bind,source="$(DOCKER_MOUNT_SOURCE)",target=$(DOCKER_MOUNT_TARGET) \
		thesis-ntnu

.PHONY: docker-stop
docker-stop:
	docker stop $(DOCKER_CONTAINER_NAME)
