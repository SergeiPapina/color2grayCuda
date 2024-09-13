#include <opencv2/core.hpp>


__global__ void colorToGrayscaleKernel(unsigned char* colorImg, unsigned char* grayImg, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < width && y < height) {
        int grayOffset = y * width + x;
        int colorOffset = grayOffset * 3;

        unsigned char r = colorImg[colorOffset + 2];
        unsigned char g = colorImg[colorOffset + 1];
        unsigned char b = colorImg[colorOffset];

        grayImg[grayOffset] = static_cast<unsigned char>(0.299f * r + 0.587f * g + 0.114f * b);
    }
}

void colorToGrayscale(cv::Mat& colorImg, cv::Mat& grayImg) {
    unsigned char *d_colorImg, *d_grayImg;

    int sizeColor = colorImg.step * colorImg.rows;
    int sizeGray = grayImg.step * grayImg.rows;

    cudaMalloc<unsigned char>(&d_colorImg, sizeColor);
    cudaMalloc<unsigned char>(&d_grayImg, sizeGray);

    cudaMemcpy(d_colorImg, colorImg.ptr(), sizeColor, cudaMemcpyHostToDevice);

    dim3 blockSize(16, 16);
    dim3 gridSize((colorImg.cols + blockSize.x - 1) / blockSize.x,
                  (colorImg.rows + blockSize.y - 1) / blockSize.y);

    colorToGrayscaleKernel<<<gridSize, blockSize>>>(d_colorImg, d_grayImg, colorImg.cols, colorImg.rows);

    cudaMemcpy(grayImg.ptr(), d_grayImg, sizeGray, cudaMemcpyDeviceToHost);

    cudaFree(d_colorImg);
    cudaFree(d_grayImg);
}
