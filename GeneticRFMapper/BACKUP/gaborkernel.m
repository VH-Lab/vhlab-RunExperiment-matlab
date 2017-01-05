function kernel=gaborkernel( window, duration, neuron )
%GABORKERNEL creates a kernel array of a gabor neuron
%
% KERNEL=GABORKERNEL( WINDOW, DURATION, NEURON )
%
%   NEURON.TYPE      'gabor'
%   NEURON.CENTER    centerlocation (x,y,t) (in virtual pixels)
%   NEURON.SIGMA    3d vector with stddevs of gaussians (in
%                   vpixels) (x,y,t)
%   NEURON.ROTATION 3x3 rotation matrix
%   NEURON.FREQ     freq (in 1/vpixels)
%   NEURON.PHASE    phase
%
%   see 'help geneticstimuli' for general information
%   2003, Alexander Heimel
%

par=genetic_defaults;
if nargin<1
  window=par.window;
end
if nargin<2
  duration=par.duration;
end
if nargin<3
  neuron=gaborneuron(window,duration);
end




g=gaussian([window duration],neuron.center,neuron.sigma, ...
	   neuron.rotation);
w=wave([window duration],neuron.center,neuron.freq,neuron.phase, ...
       neuron.rotation);
m=g.*w;
kernel=zeros([window duration 3]); %three colors
for c=1:3  %all colors identically absorbed
  kernel(:,:,:,c)=m;
end  

