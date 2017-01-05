function [tunescript, lengthwidth]=makelengthwidthaperturetuning(base, lengths, widths)

%  MAKELENGTHWIDTHAPERTURETUNING - Makes length and/or width gratings plus holey gratings
%
%   [TUNESCRIPT,LENGTHWIDTH] = MAKELENGTHWIDTHAPERTURETUNING(BASE, LENGTHS, WIDTHS)
%
%  Creates a STIMSCRIPT with PERIODICSTIM elements for measuring length
%  or width tuning.  BASE is a PERIODICSTIM that provides all parameter
%  values except length or width.  LENGTH is a list of desired lengths
%  (in pixels), and  WIDTH is a list of desired widths (in pixels).
%
%  TUNESCRIPT will be a stimscript that has all combinations of the
%  elements in LENGTH and WIDTH.  The Nth row of the matrix LENGTHWIDTH
%  contains the length and width used in the Nth stimulus in TUNESCRIPT.
%
%  LENGTH and WIDTH will be imaginary values when it is the 'hole' version
%  (a grating with maximum length and width, with a gray hole the size of each length of
%  width).

p = getparameters(base);

x_ = mean(p.rect([1 3])); y_ = mean(p.rect([2 4]));

tunescript = stimscript(0);

lengthwidth = [];

[maxlength,maxlengthposition] = max(lengths);
maxwidth = max(widths);

if maxwidth==-1,
	maxwidth = maxlength;
end;

for i=1:length(lengths),
	for j=1:length(widths),
		mywidth = widths(j);
		if mywidth==-1, mywidth = lengths(i); end;
		p.rect=round([(x_-lengths(i)/2) y_-mywidth/2 x_+lengths(i)/2 y_+mywidth/2]);
		p.length = lengths(i);
		p.width = mywidth;
		tunescript = append(tunescript,periodicstim(p));
		lengthwidth(end+1,1:2) = [lengths(i) mywidth];
	end;
end;


for i=1:length(lengths),
	for j=1:length(widths),
		mywidth = widths(j);
		if mywidth==-1, mywidth = lengths(i); end;
		p.rect=round([(x_-maxlength/2) y_-maxwidth/2 x_+maxlength/2 y_+maxwidth/2]);
		if mod(p.windowShape,2) == 0,
			p.windowShape = 6; % rectangle
		else,
			p.windowShape = 7; % oval
		end;
		p.aperture = [lengths(i) mywidth];
		p.length = sqrt(-1)*lengths(i);
		p.width = sqrt(-1)*mywidth;
		tunescript = append(tunescript,periodicstim(p));
		lengthwidth(end+1,1:2) = [lengths(i) mywidth];
	end;
end;

