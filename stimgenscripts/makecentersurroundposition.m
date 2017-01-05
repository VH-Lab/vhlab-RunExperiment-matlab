function [posscript, positions] = makecentersurroundposition(base, x, y, stepsize)

%  MAKECENTERSURROUNDPOSITION - Create a position-tuning stimscript with gratings
%
%  [POSSCRIPT, POSITIONS] = MAKECENTERSURROUNDPOSITION(BASE, X, Y, STEPSIZE)
%
%  Creates a stimscript POSSCRIPT appropriate for assessing receptive field
%  tuning.  The script consists of CENTERSURROUNDSTIMs at different positions in a grid. 
%  
%  BASE is a CENTERSURROUNDSTIM that is used for all other parameters except 
%  center position.  X and Y are the number of total steps to make horizontally
%  and vertically, respectively.  STEPSIZE is the size of each step, in pixels.
%
%  Parameter fields called 'xposition' and 'yposition' will be added to the 
%  stimuli; these can be used by tuning curve functions.
%
%  POSITIONS is a NUMSTEPS x 2 matrix with the locations of each stimulus
%  center position.
%

p = getparameters(base);
p_ = p;

numSteps = x*y;

posscript = stimscript(0);
stimnum = 1;
for r=0:(x-1),
	for c=0:(y-1),
		dx = - round ((x-1)/2)*stepsize + stepsize*r,
		dy = - round ((y-1)/2)*stepsize + stepsize*c;
		p_.center = p.center + [dx dy];
		p_.xposition = p_.center(1);
		p_.yposition = p_.center(2);
		p_.stimnum = stimnum;
		stimnum = stimnum + 1;
		positions(r*y+c+1,1:2) = p_.center;
		posscript = append(posscript,centersurroundstim(p_));
	end;
end;
