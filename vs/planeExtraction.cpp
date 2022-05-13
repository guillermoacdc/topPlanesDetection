//source: https://pcl.readthedocs.io/en/latest/extract_indices.html#extract-indices

#define   _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <fstream>  
#include <string>
#include <pcl/ModelCoefficients.h>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/sample_consensus/method_types.h>
#include <pcl/sample_consensus/model_types.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/io/ply_io.h>


using namespace std;

void myWriteParameters(int i, pcl::ModelCoefficients::Ptr coefficients);
void myWriteIndex(int i, pcl::PointIndices::Ptr inliers);

//pcl::ModelCoefficients::Ptr coefficients(new pcl::ModelCoefficients());
//pcl::PointIndices::Ptr inliers(new pcl::PointIndices());

int main(int argc, char** argv)
{
    int scene = 5;
    stringstream in_path;
    in_path << "..\\..\\data\\pcSceneFiltered\\";
    in_path << "scene_" << scene << "_camera.pcd";
    //in_path << "scene_" << scene << "_worldPlane.pcd";

    stringstream  out_path, out_path1, out_path2;
    out_path << "..\\..\\data\\topPlane\\scene" << scene << "\\";
    out_path1 << out_path.str();
    out_path2 << out_path.str();
    out_path2 << "inliers_planeModel_";
    


    pcl::PCLPointCloud2::Ptr    cloud_blob(new pcl::PCLPointCloud2);//input point cloud
    pcl::PCLPointCloud2::Ptr    cloud_filtered_blob(new pcl::PCLPointCloud2);//filtered point cloud
    pcl::PointCloud<pcl::PointXYZ>::Ptr     cloud_filtered(new pcl::PointCloud<pcl::PointXYZ>);//templated filtered
    pcl::PointCloud<pcl::PointXYZ>::Ptr     cloud_p(new pcl::PointCloud<pcl::PointXYZ>);
    pcl::PointCloud<pcl::PointXYZ>::Ptr     cloud_f(new pcl::PointCloud<pcl::PointXYZ>);

    // Fill in the cloud data
    pcl::PCDReader reader;
    reader.read(in_path.str(), *cloud_blob);
    std::cerr << "PointCloud before filtering: " << cloud_blob->width * cloud_blob->height << " data points." << std::endl;
    

    // Create the filtering object: downsample the dataset using a leaf size of 1cm
    /*3D voxel grid (think about a voxel grid as a set of tiny 3D boxes in space) over
    the input point cloud data. Then, in each voxel (i.e., 3D box), all the points present
    will be approximated (i.e., downsampled) with their centroid. This approach is a bit slower
    than approximating them with the center of the voxel, but it represents the underlying surface more accurately*/

    pcl::VoxelGrid<pcl::PCLPointCloud2> sor;
    sor.setInputCloud(cloud_blob);
    //sor.setLeafSize(0.005f, 0.005f, 0.005f);
    sor.setLeafSize(0.01f, 0.01f, 0.01f);
    sor.filter(*cloud_filtered_blob);

    // Convert to the templated PointCloud: PointCloud2, 
    /*as a general representation containing a header defining the point cloud structure (e.g., for
            loading, saving or sending as a ROS message)*/
    pcl::fromPCLPointCloud2(*cloud_filtered_blob, *cloud_filtered);
    std::cerr << "PointCloud after filtering: " << cloud_filtered->width * cloud_filtered->height << " data points." << std::endl;

    //pcl::fromPCLPointCloud2(*cloud_blob, *cloud_filtered);//version without filter

    // Write the downsampled version to disk
    pcl::PCDWriter writer;
    
    out_path1 << "downsampledPC.pcd";
    writer.write<pcl::PointXYZ>(out_path1.str(), *cloud_filtered, false);
    
    //Parametric segmentation
            pcl::ModelCoefficients::Ptr coefficients(new pcl::ModelCoefficients());
            pcl::PointIndices::Ptr inliers(new pcl::PointIndices());
            // Create the segmentation object
            pcl::SACSegmentation<pcl::PointXYZ> seg;
            // Optional
            seg.setOptimizeCoefficients(true);
            // Mandatory
            seg.setModelType(pcl::SACMODEL_PLANE);
            seg.setMethodType(pcl::SAC_RANSAC);
            seg.setMaxIterations(1000);
            seg.setDistanceThreshold(0.001);//calcular este parametro por lectura de dato-funcion de la escena, mientras tanto dejar como 0.001 (resolucion asumida para el sensor a la distancia en rango 1.3-1.8mt)
            //seg.setDistanceThreshold(0.003);

    // Create the filtering object
    pcl::ExtractIndices<pcl::PointXYZ> extract;

    int i = 0, nr_points = (int)cloud_filtered->size();
    // While 5% of the original cloud is still there
    while (cloud_filtered->size() > 0.05 * nr_points)
    {
        // Segment the largest planar component from the remaining cloud
        seg.setInputCloud(cloud_filtered);//feed seg with cloud_filtered
        seg.segment(*inliers, *coefficients);//perform segmentation based on plane model
        if (inliers->indices.size() == 0)
        {
            std::cerr << "Could not estimate a planar model for the given dataset." << std::endl;
            break;
        }
        cout << "inliers_"<<i<<": "<<inliers->indices.size()<<endl;
        cout << "coefficients_" << i << ": " << coefficients->values.size() << endl;
        for (int j = 0; j < coefficients->values.size(); j++)
        {
            cout << "\t coeff_" << j << ": " << coefficients->values[j];
        }
        cout << endl;
        myWriteIndex(i, inliers);
        myWriteParameters(i, coefficients);
        // Extract the inliers
        extract.setInputCloud(cloud_filtered);
        extract.setIndices(inliers);
        extract.setNegative(false);
        extract.filter(*cloud_p);
        std::cerr << "PointCloud representing the planar component: " << cloud_p->width * cloud_p->height << " data points." << std::endl;

        //save inliers in model i     
        
        
            //<< i << ".ply";
        pcl::io::savePLYFileBinary(out_path2.str()+to_string(i) +".ply", *cloud_p);
   

        // Create the filtering object
        extract.setNegative(true);
        extract.filter(*cloud_f);
        cloud_filtered.swap(cloud_f);
        i++;
    }

    return (0);
}

void myWriteParameters(int i, pcl::ModelCoefficients::Ptr coefficients) {
    
    string filename1 =  "coeff";
    string filename2= ".txt";
    string filename = filename1 + to_string(i) + filename2;
    ofstream outfile(filename);

    for (int i=0; i< coefficients->values.size();i++)
    {
        outfile << coefficients->values[i] << endl;
    }
    outfile.close();
}

void myWriteIndex(int i, pcl::PointIndices::Ptr inliers) {
    string filename1 = "index";
    string filename2 = ".txt";
    string filename = filename1 + to_string(i) + filename2;
    ofstream outfile(filename);

    for (int i = 0; i < inliers->indices.size(); i++)
    {
        outfile << inliers->indices[i] << endl;
    }
    outfile.close();
}