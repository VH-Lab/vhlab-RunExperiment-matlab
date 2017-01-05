function orthtrainscript = makeorthogonaltrainingstim(base, directions, screenrect, useorth)
% MAKEORTHOGONALTRAININGSTIM - Make a checkerboard array of orthogonally-moving grating stimuli
%
%  ORTHTRAINSCRIPT = MAKEORTHOGONALTRAININGSTIM(BASE, DIRECTIONS, SCREENRECT, USEORTH)
%
%  Creates a family of stimuli with the following property: each stimulus is a tiled array of
%  grating stimuli with alternating orthogonal orientations (directions offset by 90 degrees,
%  compass coordinates).
%  INPUTS:
%     BASE - The gratings are made in the PERIODICSTIM class and are based on the PERIODICSTIM
%             BASE. 
%     DIRECTIONS - A list of directions to anchor each stimulus (eg. [0:45:360-45])
%     SCREENRECT - The screen rectangle
%     USEORTH - Optional argument. If 1 (default), then the orthogonal stimuli are shown. 
%        If 0, then they are left blank. 
%
%  Spatial phase is randomized for each identical direction
%

if nargin<4, useorth = 1; end;

varyposition = 1;

if varyposition,
	gridx = 0:300:900;
	gridy = 0:300:600;
	positionsx = [-150 0]; %[-200:100:0];
	positionsy = [-150 0]; %[-200:100:0];
else,
	gridx = 0:300:600;
	gridy = 0:300:300;
	positionsx = 0;
	positionsy = 0;
end;


xsz = 200;
ysz = 200;

orthtrainscript = stimscript(0);
p = getparameters(base);

for d = 1:length(directions),
	for posx = 1:length(positionsx),
	for posy = 1:length(positionsy),
		msp.rect = screenrect;
		msp.dispprefs = {};
		ms = multistim(msp);
		ox = 1;
		for x=1:length(gridx),
			oy = ox;
			for y=1:length(gridy),
				p_ = p;
				p_.rect = [gridx(x)+positionsx(posx) gridy(y)+positionsy(posy) gridx(x)+positionsx(posx)+xsz gridy(y)+positionsy(posy)+ysz];
				% if o is 1, use directions(d); if it is 0, use 90+that quantity
				p_.angle = directions(d) + (1-oy)*90;
				if ~useorth & ((1-oy)), p_.contrast = 0; end;
				p_.sPhaseShift = 2*pi * rand;
				p_.windowShape = 1; % oval
				
				ms = append(ms,periodicstim(p_));
	
				oy = 1-oy; % flip it
			end;
			ox = 1-ox; % flip it
		end;
		orthtrainscript = append(orthtrainscript, ms);
	end; % positionsy
	end; % positionsx
end;



