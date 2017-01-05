function [tunescript, lengthwidth]=makelengthwidthoverlaytuning(base, directions, lengths, widths)

%  MAKELENGTHWIDTHOVERLAYTUNING - Makes length and/or width gratings plus holey gratings
%
%   [TUNESCRIPT,DIRLENGTHWIDTH] = MAKELENGTHWIDTHOVERLAYTUNING(BASE, DIRECTIONS, LENGTHS, WIDTHS)
%
%  Creates a STIMSCRIPT with PERIODICSTIM elements for measuring orientation in the
%  surround of a receptive field.  BASE is a PERIODICSTIM that provides all parameter
%  values except length or width and the direction of the outer stimulus.  DIRECTIONS is a list
%  of the desired directions to examine,  LENGTH is a list of desired lengths
%  (in pixels), and  WIDTH is a list of desired widths (in pixels).
%
%  TUNESCRIPT will be a stimscript that has all combinations of the
%  elements in DIRECTIONS (for the surround), LENGTH and WIDTH.  The Nth row of the matrix DIRLENGTHWIDTH
%  contains the direction, length, and width used in the Nth stimulus in TUNESCRIPT.
%

p = getparameters(base);
p_master = p;

x_ = mean(p.rect([1 3])); y_ = mean(p.rect([2 4]));

tunescript = stimscript(0);

lengthwidth = [];

[maxlength,maxlengthposition] = max(lengths);
maxwidth = max(widths);

if maxwidth==-1,
	maxwidth = maxlength;
end;

for d=1:length(directions),
	for i=1:length(lengths),
		for j=1:length(widths),
			mywidth = widths(j);
			surroundstimp = p_master;
			if mywidth==-1, mywidth = lengths(i); end;
			p.rect=round([(x_-lengths(i)/2) y_-mywidth/2 x_+lengths(i)/2 y_+mywidth/2]);
			p.length = lengths(i);
			p.width = mywidth;
			p.angle = p_master.angle;
			p.windowShape = 3;
			surroundstimp.angle = directions(d);
			surroundstimp.ps_overlay = periodicstim(p);
			surroundstimp.surroundangle = directions(d);
			tunescript = append(tunescript,periodicstim(surroundstimp));
			lengthwidth(end+1,1:3) = [directions(d) lengths(i) mywidth];
		end;
	end;
end;

