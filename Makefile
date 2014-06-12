build:
	find . -name "*.moon" | xargs moonc

clean:
	find . -name "*.lua" | xargs rm
