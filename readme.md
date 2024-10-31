# color2grayCuda  
nvidia CUDA kernel implementation color to gray image conversion
make and cmake compile and link

### first way to compile:  
mkdir build  
cd build  
cmake ..  
make  

### second way to compile:  
just use Makefile,  
make  

edit CMakelists.txt or Makefile to set correct GPU architecture to avoid core dump message at runtime  


