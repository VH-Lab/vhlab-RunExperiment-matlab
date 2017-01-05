function fitness=compute_fitness(response)
%COMPUTE_FITNESS computes fitness given a response
%
%  FITNESS=COMPUTE_FITNESS(RESPONSE)
%
%   see 'help geneticstimuli' for general information
%   2003, Alexander Heimel
%

if size(response,2)==1  % if only one column
  fitness=response;
else
  fitness=max(response')';
  %fitness=sum(response')';
end
