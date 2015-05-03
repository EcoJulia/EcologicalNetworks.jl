JEXEC=julia

.PHONY: clean CONTRIBUTING.md ALL

ALL: test doc clean

test: src/*jl test/*jl
	$(JEXEC) --code-coverage -e 'Pkg.test(pwd(), coverage=true)'

clean:
	- rm src/*.cov

coverage/coverage.json: test jsoncoverage.py
	mkdir -p coverage
	chmod +x jsoncoverage.py
	./jsoncoverage.py

doc: src/*jl CONTRIBUTING.md
	cp README.md doc/index.md
	cp CONTRIBUTING.md doc/contr.md
	$(JEXEC) ./test/makedoc.jl

CONTRIBUTING.md:
	wget -O $@ https://raw.githubusercontent.com/PoisotLab/PLCG/master/README.md
