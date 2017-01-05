function gratingrcstim = makegratingreversecorr(base, dur, orientations, spatialfreq, spatialphases, randomize, reps, nomask)
% MAKEGRATINGREVERSECORR - Make a grating reverse correlation stimulus *depricated*
%
%  GRATINGRCSTIM = MAKEGRATINGREVERSECORR(BASE, FLASHDURATION, ...
%		ORIENTATIONS, SPATIALFREQS, SPATIALPHASES, RANDOMIZE, REPS, NOMASK)
%
%  Makes a reverse correlation type stimulus of flashed gratings (that is, stimuli
%  of type PERIODICSTIM).
%
%  The image type is taken from the PERIODICSTIM BASE. The animation type is chosen to
%  be fixed, and the time of each flashed grating is determined by the FLASHDURATION, 
%  expressed in seconds (which will be matched as close as possible subject to the
%  monitor's refresh rate).
%
%  One frame will be used for each entry in the arrays ORIENTATIONS,
%  SPATIALFREQS, and SPATIALPHASES.
%
%  If RANDOMIZE is 1, then the order will be randomized.
%  The number of repetitions of each flashed grating is given in REPS.
%
%  If NOMASK is 1, then the gratings will be created without gray masks 
%  (that is, the will be shown as a rotated rectangle regardless of the
%  windowshape parameter in the BASE.)
%
%  *depricated: this function works okay for small numbers of gratings; it would 
%  *be a good example to read to make a series of gratings that play briefly
%  *one right after the other; however, the loading time of this stimulus
%  *gets unreasonably long when large numbers of gratings are used with a large
%  *number of repetitions.
%  *The better solution for large numbers of flashed gratings is
%  *to use a stimulus of type RCGRATINGSTIM
%
%
%  The output stimulus type of GRATINGRCSTIM is COMBINEDMOVIESTIM.
%  
 
p = getparameters(base);

p.animType = 0;
p.flickerType = 0;
p.tFrequency = 1/dur;
p.nCycles = 1;
if nomask, p.windowShape = -1; end;

ps = stimscript(0);

for o=1:length(orientations),
	for sf=1:length(spatialfreq),
		for sp=1:length(spatialphases),
			p.angle = orientations(o);
			p.sFrequency = spatialfreq(sf);
			p.sPhaseShift = spatialphases(sp);
			ps = append(ps, periodicstim(p));
		end;
	end;
end;

if randomize,
	ps = setDisplayMethod(ps,randomize,reps);
end;

cmsp.script = ps;
gratingrcstim = combinemoviestim(cmsp);
