function [stimuli,param] = import_population( generation, path, testname, cellname)
%IMPORT_POPULATION imports population of genetic stimuli from experiment
%  
%      [STIMULI,PARAM] = IMPORT_POPULATION( GENERATION, PATH, TESTNAME, CELLNAME )
%          e.g. PATH = '/home/data/2003-02-17', TEST = 't00012'  
%  
%      [STIMULI,PARAM] = IMPORT_POPULATION( GENERATION, PATH, TESTNAME )
%          prompts for cellname if more than one cell found
%
%      [STIMULI,PARAM] = IMPORT_POPULATION( GENERATION, CELLNAME )
%          gets path and testname from RunExperiment panel
%
%      [STIMULI,PARAM] = IMPORT_POPULATION( GENERATION )
%          prompts for cellname if more than one cell found
%   
%   see 'help geneticstimuli' for general information
%   2003, Alexander Heimel (heimel@brandeis.edu)
%

if nargin<3  %no path and date given
  cksds = getcksds;
  if isempty(cksds), 
    errordlg(['No existing data---make sure you hit '...
	      'return after directory in RunExperiment window']);
    return;
  end; 
  testname = get(findobj(geteditor('RunExperiment'),'Tag','SaveDirEdit'),...
		 'String');
else
  cksds=cksdirstruct(path);
end

if nargin==1 | nargin==3
  cellname=getcellname(cksds);
end


[savescript,mti]=getstimscript(cksds,testname);

sms=get(savescript);

% get parameters
p=getparameters(sms{1});
param=genetic_defaults;
param.bg=p.BG';
param.window=(p.rect(3)-p.rect(1))/p.scale;
param.window=(p.rect(4)-p.rect(2))/p.scale;
param.scale=p.scale;
param.time_per_frame=1000/p.fps;
param.duration=p.N;
param.isi=p.isi;

% get chromosomes
m=getshapemovies(sms{1});
chromosomes=getshapemovies(sms{1});

responses=calculate_responses(cksds,testname,cellname,param.bins,param.repeats);
fitnesses = compute_fitness( responses );

stimuli(1)=struct('chromosome',[],'response',[],'fitness',[],'generation',0);
stimuli(1)=[];
stimuli = insert_in_population( stimuli, chromosomes, responses, ...
				fitnesses, generation);


