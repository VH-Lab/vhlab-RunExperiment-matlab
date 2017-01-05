function [tunescript, lengthwidth] = makeaperaturetuning(base, lengths, widths)

%  MAKELENGTHWIDTHTUNING - Makes length and/or width gratings
%
%   [TUNESCRIPT,LENGTHWIDTH] = MAKEAPERATURETUNING(BASE, LENGTHS, WIDTHS)
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

p.windowShape = 2;

for i=1:length(lengths),
		p.aperature=[lengths(i) lengths(i)];
        p.aperaturelength = lengths(i);
        p.windowShape = 7;
		p.rect=round([(x_-max(lengths)/2) y_-max(widths)/2 x_+max(lengths)/2 y_+max(widths)]);        
		tunescript = append(tunescript,periodicstim(p));
		lengthwidth(end+1,1:2) = [lengths(i) widths(1)];
end;


