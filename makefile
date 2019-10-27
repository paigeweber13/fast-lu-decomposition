CXX=g++
CXXFLAGS=-g -Wall -std=c++1y -march=native -mtune=native -fopenmp -O3
CXXASSEMBLYFLAGS=-S -g -fverbose-asm
SOURCES=$(wildcard src/*.cpp)
OBJS=$(SOURCES:.cpp=.o)
EXEC=lu-decomp

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@

$(OBJS): $(SOURCES)

assembly: $(FILES)
	$(CXX) $(CXXFLAGS) $(CXXASSEMBLYFLAGS) $(FILES)

clean:
	rm -f $(EXEC) $(OBJS)

test: $(EXEC)
	./lu-decomp
