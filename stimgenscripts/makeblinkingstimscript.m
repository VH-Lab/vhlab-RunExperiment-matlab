function bls_script = makeblinkingstimscript(base, display_durations, pause_durations, reps_stimulus, reps_overall,ISI)
% MAKEBLINKINGSTIMSCRIPT - Make a STIMSCRIPT of BLINKINGSTIM objects
%
%  BLS_SCRIPT = MAKEBLINKINGSTIM2SCRIPT(BASE,DISPLAY_DURATIONS,...
%                  PAUSE_DURATIONS,REPS_TRAIN, REPS_OVERALL, ISI)
%
%  Takes a list of frame display durations and pause durations and creates a 
%  STIMSCRIPT of BLINKINGSTIM objects with those properties. The DISPLAY_DURATIONS is 
%  a vector of display durations (in seconds), and PAUSE_DURATIONS is a vector of
%  pause durations (in seconds).  REPS_STIMULUS is the number of times each sequence of 
%  display and pauses should be repeated during an individual stimulus run, and
%  REPS_OVERALL is the number of times each stimulus should be repeated (randomly interleaved).
%  BASE is a BLINKINGSTIM object that has the base parameters to be used. ISI is the time
%  to pause between stimuli.
%

bls_script = stimscript(0);

p = getparameters(base);

for i=1:length(display_durations),
	for j=1:length(pause_durations),
		p.dispprefs = cat(2,p.dispprefs,{'BGposttime',ISI});
		p.fps = -1;
		p.bgpause = [display_durations(i) pause_durations(j)];
		p.repeat = reps_stimulus;
		bls_script = append(bls_script,blinkingstim(p));
	end;
end;

bls_script = setDisplayMethod(bls_script,1,reps_overall);
