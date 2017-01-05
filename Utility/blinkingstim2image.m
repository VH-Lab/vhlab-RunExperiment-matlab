function blinkingstim2image(gridloc, screensize)
% BLINKINGSTIM2IMAGE - Convert a grid location of a blinkingstim to an image
%
%   BLINKINGSTIM2IMAGE(GRIDLOC, SCREENSIZE)
%
%   Prompts the user to open a 'stims.mat' file for which the 'saveScript' field
%   contains only a blinkingstim.
%
%   Creates an image that is all black except for white at GRIDLOC.  The image
%   is put on a screen with size SCREENSIZE, which should be [width height]
%
%   Then the user is prompted for a location at which to save the file.

[filename,pathname] = uigetfile('*.mat','Open a stims.mat file...');

g = load([pathname filesep filename],'-mat');

bl = get(g.saveScript,1);

if ~isa(bl,'blinkingstim'),
	error(['Stimulus is not a blinkingstim']);
end;

img = grid2screenimage(bl,gridloc,screensize);

[outfilename,outfilepath] = uiputfile('*.tif');

img = uint8(img*255);

imwrite(img,[outfilepath filesep outfilename],'tif');
