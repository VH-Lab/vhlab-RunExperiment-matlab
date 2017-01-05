function [tunescript, lengthwidth] = makelengthwidthtuning(base, lengths, widths)

%  MAKELENGTHWIDTHTUNING - Makes length and/or width gratings
%
%   [TUNESCRIPT,LENGTHWIDTH] = MAKELENGTHWIDTHTUNING(BASE, LENGTHS, WIDTHS)
%
%  Creates a STIMSCRIPT with PERIODICSTIM elements for measuring length
%  or width tuning.  BASE is a PERIODICSTIM that provides all parameter
%  values except length or width.  LENGTH is a list of desired lengths
%  (in pixels), and  WIDTH is a list of desired widths (in pixels).
%
%  All periodicstim stimuli will be 'angled rects', regardless of what
%  is set in BASE.
%
%  TUNESCRIPT will be a stimscript that has all combinations of the
%  elements in LENGTH and WIDTH.  The Nth row of the matrix LENGTHWIDTH
%  contains the length and width used in the Nth stimulus in TUNESCRIPT.

p = getparameters(base);

x_ = mean(p.rect([1 3])); y_ = mean(p.rect([2 4]));

tunescript = stimscript(0); lengthwidth = [];

%p.windowShape = 2;  % why impose a window shape?  Someone might want oval, right?

for i=1:length(lengths),
	for j=1:length(widths),
		mywidth = widths(j);
		if mywidth==-1, mywidth = lengths(i); end;
		p.rect=round([(x_-lengths(i)/2) y_-mywidth/2 x_+lengths(i)/2 y_+mywidth/2]);
		tunescript = append(tunescript,periodicstim(p));
		lengthwidth(end+1,1:2) = [lengths(i) mywidth];
	end;
end;


