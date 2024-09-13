#include <opencv2/opencv.hpp>
#include "c2gs.cuh"

int main() {
    cv::Mat h_colorImg = cv::imread("../1.jpg", cv::IMREAD_COLOR);
    if (h_colorImg.empty()) {
        std::cerr << "Failed to load image." << std::endl;
        return -1;
    }

    cv::Mat h_grayImg(h_colorImg.rows, h_colorImg.cols, CV_8UC1);

    colorToGrayscale(h_colorImg, h_grayImg);

    cv::imshow("Original", h_colorImg);
    cv::imshow("Grayscale", h_grayImg);
    cv::waitKey(0);

    return 0;
}
