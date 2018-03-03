.PHONY: reproduce clean notebooks
default:

clean:
	rm -rf output
	mkdir output

notebooks:
	cd notebooks && find . -type f -maxdepth 1 -exec jupyter nbconvert \
		--ExecutePreprocessor.timeout=-1 \
		--ExecutePreprocessor.kernel_name=python3 \
		--to notebook \
		--output {} \
		--execute {} \;

reproduce: clean notebooks
