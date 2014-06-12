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
    PCLPointCloud2::Ptr cloud_blob (new PCLPointCloud2);
    io::loadPCDFile( argv[1], *cloud_blob );
    PointCloud<PointNormal>::Ptr cloud( new PointCloud<PointNormal>() );
    fromPCLPointCloud2 (*cloud_blob, *cloud);

    // Apply poisson
    Poisson<PointNormal> poisson;
    poisson.setDepth( 10 );
    poisson.setInputCloud( cloud ); 
    PolygonMesh mesh;
    poisson.reconstruct ( mesh );

    pcl::io::savePLYFile(argv[2], mesh);

    // Finish
    return 1;
}
