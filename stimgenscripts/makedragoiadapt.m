function dragscript=makedragoiadapt(base,adapt_time,adapt_angle,isi,topoff,stimdur,testangles,repeats)

% MAKEDRAGOIADAPT - Create angle adaptation script based on Dragoi & Sur
%
%  DRAGSCRIPT = MAKEDRAGOIADAPTATION(BASE, ADAPT_TIME, ADAPT_ANGLE,...
%        ISI, TOPOFF_DURATION, TESTSTIM_DURATION, TESTANGLES, REPEATS)
%
% Creates an angle adaptation script based on Dragoi&Sur 2000 (Neuron 28:287-98).
%
% The first stimulus in the script is the base stimulus with angle 
% ADAPT_ANGLE presented for ADAPT_TIME seconds.  Then, there is an interstimulus
% interval of duration ISI seconds, followed by ADAPT_ANGLE again for
% TOPOFF_DURATION seconds and then immediately followed by one of the
% TESTANGLES for TESTSTIM_DURATION seconds.  This second stimulus type
% (ISI followed by ADAPT_ANGLE followed by a TESTANGLE) is repeated until
% all TESTANGLES have been shown in random order.  Then, the whole stimulus
% sequence is repeated REPEATS times.  A new random order for the TESTANGLES
% is chosen for each repeat.
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
p.dispprefs = {};
p.loops = 11;
dragscript = append(dragscript,periodicstim(p));
 % topoff stim
p = p_;
p.nCycles = ceil(topoff*p.tFrequency);
p.dispprefs = {'BGpretime',isi};
p.angle = adapt_angle;
dragscript = append(dragscript,periodicstim(p));
 % now all the testangles
p = p_; 
p.nCycles = ceil(stimdur*p.tFrequency);
p.dispprefs = {};
for i=1:length(testangles),
	p.angle = testangles(i);
	dragscript = append(dragscript,periodicstim(p));
end;

 % now make display order

do = [1];
for i=1:repeats,
	do = cat(2,do,reshape([2*ones(1,length(testangles)); 2+randperm(length(testangles))],...
		1,2*length(testangles)));
end;

dragscript = setDisplayMethod(dragscript,2,do);
