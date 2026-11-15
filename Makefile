BUILDDIR = build
APPNAME  = demo
.PHONY: cmake cmake-debug cmake-clean cmake-run cmake-init

# cmake builds
cmake:
	cmake -S . -B $(BUILDDIR) -G Ninja -DCMAKE_BUILD_TYPE=Release
	cmake --build $(BUILDDIR)

# Debug-Build (-O0 -g3), Binary unter build/demo.
cmake-debug:
	cmake -S . -B $(BUILDDIR) -G Ninja -DCMAKE_BUILD_TYPE=Debug
	cmake --build $(BUILDDIR)

cmake-clean:
	rm -rf $(BUILDDIR)

cmake-run: cmake
	./$(BUILDDIR)/$(APPNAME)

cmake-init:
	cmake -S . -B $(BUILDDIR) -G Ninja
