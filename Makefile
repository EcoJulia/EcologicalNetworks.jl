JEXEC=julia

.PHONY: clean CONTRIBUTING.md ALL

ALL: test doc clean

test: src/*jl test/*jl
	# $(JEXEC) --code-coverage ./test/runtests.jl
	cd test; $(JEXEC) --code-coverage -e 'include("runtests.jl")'

clean:
	- rm src/*.cov

doc: src/*jl
	cp README.md doc/index.md
	cp CONTRIBUTING.md doc/contr.md
	$(JEXEC) ./test/makedoc.jl

CONTRIBUTING.md:
	wget -O $@ https://raw.githubusercontent.com/PoisotLab/PLCG/master/README.md
