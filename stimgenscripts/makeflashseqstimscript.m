function thescript = makeflashseqstimscript(base, dirname, numreps, isi, randomize)
% MAKEFLASHSEQSTIMSCRIPT - Make a stimscript of FLASHSEQSTIM from a set of directories
%
%  THESCRIPT = MAKEFLASHSEQSTIMSCRIPT(BASE, DIRNAME, NUMREPS, ISI, RANDOMIZE)
%
%  Creates a STIMSCRIPT comprised of FLASHSEQSTIMs. Each stimulus will show the
%  image files that are present in subdirectories of the full path directory name
%  DIRNAME. The stimuli will be repeated NUMREPS times. If RANDOMIZE is 1, then
%  the presentation order will be psuedo-randomized.
%
%  See also: STIMSCRIPT, FLASHSEQSTIMS
% 

error('this is untested');

p = getparameters(base);

thescript = stimscript(0);

D = dir(dirname);
dirnumbers=find([D.isdir]);
dirlist = {D(dirnumbers).name};
dirlist = dirlist_trimdots(dirlist);  % trim the dots

p_ = p;

for i=1:length(dirlist),
	p_.dispprefs = {'BGposttime',isi};
	p_.dirname = [dirname filesep dirlist];
	thescript = append(thescript,frameseqstim(p_));
end;

thescript = setDisplayMethod(thescript,numreps,randomize);
