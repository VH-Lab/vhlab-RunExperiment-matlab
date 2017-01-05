function param=genetic_defaults()
%GENETIC_DEFAULTS returns default parameters for population
%
%  PARAM=GENETIC_DEFAULTS()
%
%  param.duration        length of stimulus (virtual frames)
%  param.window          [width height] of stimulus (virtual pxls)
%  param.types           cell-list of genetypes to use
%  param.colors          cell-list of [R G B] colors to use
%  param.sizelimit       maximum diameter virtual pixels
%  param.speedlimits     [speedxlimit speedylimit]
%  param.contrastlimits  [lowest contrast highestcontrast]
%  param.eccentricitylimits  [min max] eccentricity
%  param.n_deletes       number of genes to delete
%  param.n_creations     number of genes to create
%  param.mutationrate    fraction of genes to mutate
%  param.background      background of movie clips
%  param.min_n_genes     minimum number of genes per chromosome
%  param.max_n_genes     maximum number of genes per chromosome
%  param.shrinkingforce  number of vpixels to take away each generation
%  param.time_per_frame  time to show one virtual frame (ms)
%  param.isi             interval between frames (s)
%  param.n_parents       number of parents to pick and produce offspring
%  param.n_survive       number of chromosome to survive from one  generation
%  param.N               number of offspring to produce 
%  param.max_n_generations  maximal number of generations to run
%  param.min_n_generations  minimal number of generations to run
%  param.scale           (int) windowsize (pixels) / param.window (vpixels)
%  param.repeats         number of times stimulus sequence is shown
%  param.bins            bin edges in second to quantify response
%  param.fitness_variation  between (0,1) deviation of responses
%                            to still call them identical
%
%  Type 'genetic_defaults' to see default values
%
%  GENERAL CONSIDERATIONS
%
%  If one keeps more members (N_SURVIVE) from a generation to generation, 
%  this will increase initial convergence rate, but will counteract 
%  the shrinking forces (SHRINKINGFORCE and N_DELETES) and looking 
%  for a `minimal' optimal stimulus.
%
%  Using smaller stimulus elements (set by SIZELIMITS) will more 
%  closely approximate the real receptive field, but the initial 
%  convergence might slow down, because neuron is driven less
%  effectively
%  
%  Using smaller ISI will speed up stimulus showing, but responses
%  may start to interfere, because of adaptation or late responses.
%
%  
%
%   2003, Alexander Heimel (heimel@brandeis.edu)
%

squirrelcolor

param.types=[1];  % later oval, rectangle, gaussian
param.window=[40 40];  %[width height] virtual pixels  
param.duration=4;      %virtual frames
param.colors = { squirrel_white, [0; 0; 0] };
param.sizelimit = 6 ;  % diameter in virtual pixels
param.contrastlimits = [1 1];
param.speedlimits = [0 0];
param.eccentricitylimits = [0.8 1.2];
param.n_deletes = 1;
param.n_creations = 1;
param.mutationrate = 0.1;
param.background = round(squirrel_white/2);
param.nocrossover = 0;
param.min_n_genes = 5;
param.max_n_genes = 15;
param.shrinkingforce = 0;
param.time_per_frame = 50; 
param.isi = 1.0;
param.n_survive = 0;
param.N=20;
param.n_parents = min(2,round(param.N/10));
param.max_n_generations=30;
param.min_n_generations=3;
param.scale=6;
param.repeats=2;
param.bins=linspace( 0.000, (param.duration*param.time_per_frame+100)/1000,...
		     2);
param.fitness_variation=0.05;
