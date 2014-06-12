#include <iostream>
#include <pcl/common/common.h>
#include <pcl/io/pcd_io.h>
#include <pcl/io/vtk_io.h>
#include <pcl/io/ply_io.h>
#include <pcl/search/kdtree.h>
#include <pcl/features/normal_3d_omp.h>
#include <pcl/point_types.h>
#include <pcl/surface/mls.h>
#include <pcl/surface/poisson.h>
#include <pcl/filters/passthrough.h>
#include <pcl/PCLPointCloud2.h>

using namespace pcl;
using namespace std;

int main (int argc, char** argv) {
    if ( argc < 3 ) {
        std::cout << "Usage: " << argv[0] << " input.pcd output.vtk\n";
        return 0;
    }

    // Read point cloud and normals
    pcl::PCLPointCloud2::Ptr cloud_blob( new pcl::PCLPointCloud2 );
    pcl::io::loadPCDFile( argv[1], *cloud_blob );
    pcl::PointCloud<pcl::PointNormal>::Ptr cloud( new pcl::PointCloud<pcl::PointNormal>() );
    pcl::fromPCLPointCloud2( *cloud_blob, *cloud );

    // Setup poisson
    pcl::Poisson<pcl::PointNormal> poisson;

    // Setting the parameters
    poisson.setDepth( 12 );
    poisson.setSolverDivide( 8 );
    poisson.setIsoDivide( 8 );
    poisson.setPointWeight( 4.0f ); 
    poisson.setScale( 1.25 );
    poisson.setInputCloud( cloud ); 

    // Perform reconstruction
    pcl::PolygonMesh mesh;
    poisson.performReconstruction ( mesh );

    pcl::io::saveVTKFile(argv[2], mesh);

    // Finish
    return 1;
}
