CC=g++
NVCC=nvcc

# Use pkg-config to get OpenCV flags
OPENCV_CFLAGS=$(shell pkg-config --cflags opencv4)
OPENCV_LIBS=$(shell pkg-config --libs opencv4)

# CUDA runtime library
CUDA_LIBS=-lcudart

# Define C++ standard and any other compiler flags
CXXFLAGS=-std=c++17

# NVCC flags: specify the host compiler and pass the necessary OpenCV compiler flags
NVCCFLAGS=-ccbin $(CC) $(OPENCV_CFLAGS) -Xcompiler "$(CXXFLAGS)" -gencode arch=compute_75,code=sm_75

# Linker flags: Link both CUDA and OpenCV libraries
LDFLAGS=$(CUDA_LIBS) $(OPENCV_LIBS) -L/usr/local/cuda/lib64

TARGET=app
CUDA_SRC=c2gs.cu
CPP_SRC=main.cpp
OBJ_FILES=c2gs.o main.o

# Default target
all: $(TARGET)

# Target for the application
$(TARGET): $(OBJ_FILES)
	$(CC) -o $(TARGET) $(OBJ_FILES) $(LDFLAGS)

# Compiling the CUDA source file
c2gs.o: $(CUDA_SRC)
	$(NVCC) -c $(CUDA_SRC) -o $@ $(NVCCFLAGS)

# Compiling the C++ source file
main.o: $(CPP_SRC)
	$(CC) $(CXXFLAGS) $(OPENCV_CFLAGS) -c $(CPP_SRC) -o $@

clean:
	rm -f $(TARGET) $(OBJ_FILES)
