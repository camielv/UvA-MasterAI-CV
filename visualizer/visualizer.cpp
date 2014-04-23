#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/visualization/cloud_viewer.h>

int main (int argc, char** argv)
{
    if ( argc < 2 ) {
        std::cout << "Usage: " << argv[0] << " pcd_filename\n";
        return 0;
    }
    // Read pcd
    typedef pcl::PointCloud<pcl::PointXYZ> CloudType;
    boost::shared_ptr<CloudType> cloud(new CloudType());

    if (pcl::io::loadPCDFile<pcl::PointXYZ> (argv[1], *cloud) == -1) //* load the file
    {
        PCL_ERROR ("Couldn't read file test_pcd.pcd \n");
        return (-1);
    }

    // Visualize PointCloud
    pcl::visualization::CloudViewer viewer("Eugenio Viewer");
    viewer.showCloud(cloud, "Test");
    while (!viewer.wasStopped())
    {
    }

    return (0);
}
