.PHONY: format
format:
	lua-format --config=lua-format.config --in-place --verbose *.lua
