function dragscript=makedragoiposadapt(base,x, y, stepsize, adapt_time,adapt_angle,isi,topoff,stimdur,repeats)

% MAKEDRAGOIADAPT - Create angle adaptation script based on Dragoi & Sur
%
%  DRAGSCRIPT = MAKEDRAGOIADAPTATION(BASE, X, Y, STEPSIZE,...
%        ADAPT_TIME, ADAPT_ANGLE,ISI, TOPOFF_DURATION,...
%        TESTSTIM_DURATION, REPEATS)
%
% Creates an angle adaptation script based on Dragoi&Sur 2000 (Neuron 28:287-98) 
% except that position is varied as in MAKEGRATINGPOSITION.
%
%
%  BASE is assumed to be a PERIODICSTIM.
%

p = getparameters(base);
p_ = p;

dragscript = stimscript(0);
 % now add the stims
 % long adaptation stim
p.angle = adapt_angle;
p.nCycles = ceil(adapt_time*p.tFrequency);
p.rect = [ 0 0 800 600 ];
p.loops = 11;
p.dispprefs = {};
dragscript = append(dragscript,periodicstim(p));
 % topoff stim
p = p_;
p.rect = [ 0 0 800 600 ];
p.angle = adapt_angle;
p.nCycles = ceil(topoff*p.tFrequency);
p.dispprefs = {'BGpretime',isi};
dragscript = append(dragscript,periodicstim(p));
 % now all the other stims

SS = makegratingposition(base,x,y,stepsize);
for i=1:numStims(SS),
	p=getparameters(get(SS,i));
	p.nCycles = ceil(stimdur*p.tFrequency);
	p.dispprefs = {};
	dragscript = append(dragscript,periodicstim(p));
end;

 % now make display order

do = 1;
for i=1:repeats,
	do = cat(2,do,reshape([2*ones(1,numStims(SS)); 2+randperm(numStims(SS))],...
		1,2*numStims(SS)));
end;

dragscript = setDisplayMethod(dragscript,2,do);
