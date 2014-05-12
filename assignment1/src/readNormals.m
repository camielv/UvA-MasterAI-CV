function [normals] = readNormals(cloudName, ids)
    normals = readCloud([cloudName '_normal'], 0);
    normals = normals(ids, :);
end
