function [posscript, positions] = makegratingposition(base, x, y, stepsize)

%  MAKEGRATINGPOSITION - Create a position-tuning stimscript with gratings
%
%    [POSSCRIPT, POSITIONS] = MAKEGRATINGPOSITION(BASE, X, Y, STEPSIZE)
%
%  Creates a stimscript POSSCRIPT appropriate for assessing receptive field
%  tuning.  The script consists of periodicstims at different positions in a grid. 
%  
%  BASE is a periodicstim that is used for all other parameters except 
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

center = [mean(p.rect([1 3])) mean(p.rect([2 4]))];

numSteps = x*y;

posscript = stimscript(0);
stimnum = 1;
for r=0:(x-1),
	for c=0:(y-1),
		dx = - round ((x-1)/2)*stepsize + stepsize*r;
		dy = - round ((y-1)/2)*stepsize + stepsize*c;
		p_.rect = p.rect + [dx dy dx dy];
		p_.xposition = [mean(p_.rect([1 3]))];
		p_.yposition = [mean(p_.rect([2 4]))];
		p_.stimnum = stimnum;
		stimnum = stimnum + 1;
		positions(r*y+c+1,1:2) = [mean(p_.rect([1 3])) mean(p_.rect([2 4]))];
		posscript = append(posscript,periodicstim(p_));
	end;
end;
