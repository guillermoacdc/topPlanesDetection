#define   _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <string>
#include <fstream> 


#include <pcl/io/ply_io.h>
#include <pcl/point_types.h>
#include <pcl/registration/icp.h>
#include <pcl/console/time.h>   // TicToc
using namespace std;
typedef pcl::PointXYZ PointT;
typedef pcl::PointCloud<PointT> PointCloudT;
void print4x4Matrix(const Eigen::Matrix4d& matrix, bool printFileFlag);

/*-------------------Defining a rotation matrix and translation vector*/
Eigen::Matrix4d transformation_matrix = Eigen::Matrix4d::Identity();

int scene = 7;
stringstream raw_path;


int main(void)
{
    
    stringstream gt_path, camera_path;
    raw_path << "..\\..\\data\\gtTopPlane\\" << "scene_" << scene;
    gt_path << "..\\..\\data\\gtTopPlane\\" << "scene_" << scene << "_worldFrame.ply";
//    gt_path << "..\\..\\data\\gtTopPlane\\" << "scene_" << scene << "_AllignedPointCloud.ply";
    camera_path << "..\\..\\data\\gtTopPlane\\" << "scene_" << scene << "_cameraFrame.ply";
    



    /*---------- Declaring the point clouds we will be using ------------*/
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_gt(new pcl::PointCloud<pcl::PointXYZ>); // point cloud referenced to world frame
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_kinect(new pcl::PointCloud<pcl::PointXYZ>); // point cloud referenced to camera frame

    PointCloudT::Ptr cloud_icp(new PointCloudT);  // ICP output point cloud

    int iterations = 100;  // number of ICP iterations

    pcl::console::TicToc time;
    time.tic();
    /*---------loading Correspondences-----------*/
    //loading ground truth
    if (pcl::io::loadPLYFile<pcl::PointXYZ>(gt_path.str(), *cloud_gt) == -1) //* load the file from binary
    {
        PCL_ERROR("Couldn't read PLY file  \n");
        return (-1);
    }
    cout << "Loaded PC ground truth from a PLY file, with"
        << "\t Width: " << cloud_gt->width
        << "\t Height: " << cloud_gt->height
        << endl;

    
    
    //loading PC from camera
    if (pcl::io::loadPLYFile<pcl::PointXYZ>(camera_path.str(), *cloud_kinect) == -1) //* load the file from binary
    {
        PCL_ERROR("Couldn't read PLY file  \n");
        return (-1);
    }
    cout << "Loaded PC from kinect; PLY file, with"
        << "\t Width: " << cloud_kinect->width
        << "\t Height: " << cloud_kinect->height
        << endl;

    std::cout << "\nLoaded files  in " << time.toc() << " ms\n" << std::endl;
 
    

    /*----------------------configuring the ICP algorithm from PCL */
    // The Iterative Closest Point algorithm

    time.tic();
    pcl::IterativeClosestPoint<PointT, PointT> icp;

    icp.setMaximumIterations(iterations);
    icp.setInputSource(cloud_gt);
    icp.setInputTarget(cloud_kinect);
    icp.align(*cloud_icp);

    std::cout << "Applied " << iterations << " ICP iteration(s) in " << time.toc() << " ms" << std::endl;

    if (icp.hasConverged())
    {
        std::cout << "\nICP has converged, score is " << icp.getFitnessScore() << std::endl;
        std::cout << "\nICP transformation " << iterations << " : cloud_icp -> cloud_gt" << std::endl;
        transformation_matrix = icp.getFinalTransformation().cast<double>();
        print4x4Matrix(transformation_matrix, true);
    }
    else
    {
        PCL_ERROR("\nICP has not converged.\n");

        string writePath = "outputTransformationMatrix\\OriginalPointCloud.ply";
        pcl::io::savePLYFileBinary(writePath, *cloud_gt);
        cout << "saved ply 1 on disk: " << writePath;
        
        return (-1);
    }


    // ICP aligned point cloud is red
    string writePath = "_AllignedPointCloud.ply";
    pcl::io::savePLYFileBinary(raw_path.str() + writePath, *cloud_icp);
    cout << "saved ply 3 on disk: " << writePath;

    std::stringstream ss;
    ss << iterations;
    std::string iterations_cnt = "ICP iterations = " + ss.str();
   
  
    return (0);
}

void print4x4Matrix(const Eigen::Matrix4d& matrix, bool printFileFlag)
{
    printf("Rotation matrix :\n");
    printf("    | %6.3f %6.3f %6.3f | \n", matrix(0, 0), matrix(0, 1), matrix(0, 2));
    printf("R = | %6.3f %6.3f %6.3f | \n", matrix(1, 0), matrix(1, 1), matrix(1, 2));
    printf("    | %6.3f %6.3f %6.3f | \n", matrix(2, 0), matrix(2, 1), matrix(2, 2));
    printf("Translation vector :\n");
    printf("t = < %6.3f, %6.3f, %6.3f >\n\n", matrix(0, 3), matrix(1, 3), matrix(2, 3));

    
    if (printFileFlag)
    {

        string filename = "_Matrix.txt";
        ofstream outfile(raw_path.str()+filename);
        outfile << "Rotation matrix :\n";
        outfile <<  matrix(0, 0) << "\t"    <<  matrix(0, 1) << "\t" << matrix(0, 2) << endl;
        outfile <<  matrix(1, 0) << "\t"    <<  matrix(1, 1) << "\t" << matrix(1, 2) << endl;
        outfile <<  matrix(2, 0) << "\t"    <<  matrix(2, 1) << "\t" << matrix(2, 2) << endl;
        outfile << "Translation vector :\n";
        outfile <<  matrix(0, 3) << "\t" << matrix(1, 3) << "\t" << matrix(2, 3);

        outfile.close();
    }
}
