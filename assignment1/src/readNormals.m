function [normals] = readNormals(cloudName)
    normals = readCloud([cloudName '_normal']);
end
