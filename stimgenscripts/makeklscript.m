function klscript = makeklscript(quicktimebase, grating_base, directions, SFs, repeats)

% 90s natural scence movie, 90s noise, grating presentations, 90s quiet

klscript = stimscript(0); % new script

klscript = append(klscript, quicktimebase);

sgsp = getparameters(stochasticgridstim('default'));

sgsp.BG = [128 128 128];
sgsp.dist = [ 1 1 ]';
sgsp.values = [ [0 0 0]+64 ; [255 255 255]-64];
sgsp.rect = [0 0 800 600];
sgsp.angle=0;
sgsp.pixSize =  [50 50];
sgsp.N =  1350;
sgsp.fps = 15;

klscript = append(klscript,stochasticgridstim(sgsp));

 % co-vary orientation and spatial frequency

qtp = getparameters(quicktimebase);

rect = [0 0 1000 1000];

grating_p = getparameters(grating_base);

grating_p.tFrequency = 4;
grating_p.nCycles = 3;
grating_p.loops = 1;

for i=1:length(directions),
	grating_p.angle = directions(i);
	for j=1:length(SFs),
		grating_p.sFrequency = SFs(j);
		klscript = append(klscript,periodicstim(grating_p));
	end;
end;

num_gratings = length(SFs)*length(directions);

sgsp.values = sgsp.BG*0; sgsp.dist = 1;  % the 'blank'
sgsp.fps = 1/10;
sgsp.N = 9;
klscript = append(klscript,stochasticgridstim(sgsp));

do = [];

for i=1:repeats,
	do = cat(2,do,[1 2 2+randperm(num_gratings) numStims(klscript)]);
end;

klscript = setDisplayMethod(klscript,2,do);

