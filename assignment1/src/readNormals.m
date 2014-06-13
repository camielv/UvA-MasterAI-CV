function [normals] = readNormals(cloudName, ids)
% READNORMALS reads a pcd file containing normals and extract only the selected ones.
    normals = readCloud([cloudName '_normal'], 0);
    normals = normals(ids, :);
end
