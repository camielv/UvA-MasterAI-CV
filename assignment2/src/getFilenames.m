% TODO write documentation

function [filenames] = getFilenames(path)
    filenames = dir(path);
    % Remove the . and ..
    filenames = strcat({[path '/']},{filenames(3:end).name});
end