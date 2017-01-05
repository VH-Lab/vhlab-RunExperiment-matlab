function y=thresholdlinear( x )
%THRESHOLDLINEAR returns x if x>0, otherwise 0
%
%  Y=THRESHOLDLINEAR( X )
%
%   see 'help geneticstimuli' for general information
%   2003, Alexander Heimel
%

y=x;
y(find(x<0))=0;
