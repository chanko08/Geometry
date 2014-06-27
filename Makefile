build:
	find . -name "*.moon" | xargs moonc

clean:
	find . -name "*.lua" -not -path "./lib/*" -not -path "./assets/*" -not -path "./lvls/*" | xargs rm
