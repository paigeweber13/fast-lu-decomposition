include build/conanbuildinfo.mak

CXX=g++
CXXFLAGS=-g -Wall -std=c++1y -march=native -mtune=native -fopenmp -O3
CXXASSEMBLYFLAGS=-S -g -fverbose-asm
SOURCES=$(wildcard src/*.cpp)
OBJS=$(SOURCES:.cpp=.o)
EXEC=lu-decomp

# conan
CFLAGS          += $(CONAN_CFLAGS)
CXXFLAGS        += $(CONAN_CXXFLAGS)
CPPFLAGS        += $(addprefix -I, $(CONAN_INCLUDE_DIRS))
CPPFLAGS        += $(addprefix -D, $(CONAN_DEFINES))

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@

$(OBJS): $(SOURCES)

assembly: $(FILES)
	$(CXX) $(CXXFLAGS) $(CXXASSEMBLYFLAGS) $(FILES)

clean:
	rm -f $(EXEC) $(OBJS) build

test: $(EXEC)
	./lu-decomp
