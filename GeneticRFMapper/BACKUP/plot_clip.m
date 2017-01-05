function plot_clip( clip , h1)
%PLOT_CLIP plots clip 
%   
%  PLOT_CLIP( CLIP , H1 )
%    CLIP cell array of arrays to plot, one cell for each time frame
%    H1 (optional) figure handle to plot in
%
%   see 'help geneticstimuli' for general information
%   2003, Alexander Heimel
%

if nargin==1
  figure;
else
  figure(h1);
end

duration=length(clip);
colormap(hot);

for t=1:duration
  subplot(1,duration,t);
  pcolor(clip{t}(:,:,2));
  caxis([0 1]);
  shading interp;
  hold on;
  %contour(clip{t}(:,:,2));
end
