function [filenames] = getFilenames(path)
% GETFILENAMES Returns a cell array with all files found at path.
    filenames = dir(path);
    % Remove the . and ..
    filenames = strcat({[path '/']},{filenames(3:end).name});
end
