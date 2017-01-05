function param=default_param()
% DEFAULT_PARAM returns default parameters for population
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
%  param.max_n_generations  number of generations to run maximally
%  param.scale           (int) windowsize (pixels) / param.window (vpixels)
%  param.repeats         number of times stimulus sequence is shown
%  param.bins            bin edges in second to quantify response
%
%  defaults:
%      PARAM.TYPES = [1]
%            1=disk, 2=gaussian, 3=oval
%      PARAM.WINDOW = [20 20]   
%      PARAM.DURATION = 4
%      PARAM.COLORS = { squirrel_white, [0; 0; 0] }
%      PARAM.SIZELIMIT = 10
%      PARAM.SPEEDLIMITS = [ 0 0 ]
%      PARAM.CONTRASTLIMITS = [0.3 1]
%      PARAM.ECCENTRICITYLIMITS = [0.8 1.2]
%      PARAM.N_DELETES = 1
%      PARAM.N_CREATIONS = 1
%      PARAM.MUTATIONRATE = 0.2
%      PARAM.BACKGROUND = squirrel_white/2
%      PARAM.MIN_N_GENES = 5
%      PARAM.MAX_N_GENES = 20
%      PARAM.SHRINKINGFORCE = 1
%      PARAM.TIME_PER_FRAME =  (ms)
%      PARAM.ISI = 0.5 s
%      PARAM.N_PARENTS = 10
%      PARAM.N_SURVIVE = 0
%      PARAM.N = 20
%      PARAM.MAX_N_GENERATIONS = 10
%      PARAM.SCALE = 3
%      PARAM.REPEATS = 3
%      PARAM.BINS = LINSPACE( 0, (DURATION*TIME_PER_FRAME+100)/1000,2);
%
%   2003, Alexander Heimel
%

squirrelcolor

param.types=[1];  % later oval, rectangle, gaussian
param.window=[50 50];  %[width height] virtual pixels  
param.duration=4;      %virtual frames
param.colors = { squirrel_white, [0; 0; 0] };
param.sizelimit =11 ;  % diameter in virtual pixels
param.contrastlimits = [0.3 1];
param.speedlimits = [0 0];
param.eccentricitylimits = [0.8 1.2];
param.n_deletes = 1;
param.n_creations = 1;
param.mutationrate = 0.1;
param.background = round(squirrel_white/2);
param.nocrossover = 0;
param.min_n_genes = 5;
param.max_n_genes = 15;
param.shrinkingforce = 6;
param.time_per_frame = 50; 
param.isi = 0.5;
param.n_survive = 0;
param.N=20;
param.n_parents = min(2,round(param.N/10));
param.max_n_generations=10;
param.scale=5;
param.repeats=2;
param.bins=linspace( 0.000, (param.duration*param.time_per_frame+100)/1000,...
		     2);