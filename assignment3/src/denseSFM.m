% The sfm function applies the structure from motion algorithm on a dense 
% set of given measurements.
%
% Arguments:
% xadasdadasdsadsa - dsadsdkjashdkj
%
% Returns:
% result           - 3d structure

function [S,M] = denseSFM(D)

% Apply singular value decomposition on the D matrix.
[U W Vt] = svd(D);

% Transpose Vt to V
V = Vt';

% Truncate matrices
U
U3 = U(:,1:3);
W3 = W(1:3,1:3);
V3 = V(:,1:3);

% Create motion and shape matrices
M = U3 * (W3 ^ 0.5);
S = (W3 ^ 0.5) * V3';
% M = U3;
% S = W3 * V3';

% Normalize rotation of M
Ri = [1 0 0] / M(1, :);
Rj = [0 1 0] / M(2, :);

M(1:2:end, :) = Ri * M(1:2:end, :);
M(2:2:end, :) = Rj * M(2:2:end, :);

% Eliminate affine ambiguity
% M' QQ' M = 1;
% M(1:2:end, :)' QQ' M(2:2:end, :) = 0;

%L = ???
% C = chol(L);

% Update M and S matrices
% M = M*C;
% S = C\S; % Equal to "S = inv(C)*S", but faster.



end