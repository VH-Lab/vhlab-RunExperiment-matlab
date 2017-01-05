function S = Draw(S_in, arg2, arg3)

% DRAW - Draws sheetlet object
%
%   S_OUT = DRAW(S, UPPERLEFT, VISIBLE)
%
%  Draw the graphics objects that are associated with the
%  sheetlet; the upper left coordinate is specified in 
%  UPPERLEFT as [left_pixel top_pixel], and 
%
%   S_OUT = DRAW(S, UPPERLEFTSHIFT)
%
%   Shifts the locations of graphics objects that comprise the
%   sheetlet, and updates the drawing.
%
%   S_OUT = DRAW(S)  
%
%   Updates the drawing of the sheetlet, moving and showing/hiding
%   controls / subsheetlets as necessary
%
%   See also: BUILD

S = S_in;

if nargin==3,
	S.params.drawing.upperleft = arg2;
	S.params.drawing.visible = arg3;
	SaveParameters(S);
	S = Draw(S);
	return;
elseif nargin==2,
	S.params.drawing.upperleft_shift = arg2;
	SaveParameters(S);
	S = Draw(S);
	return;
end;

 %   loop through the control, drawing or moving guys as needed

P = GetParameters(S);
controllist = GetControl(S);

for i=1:length(controllist),
	vis = controllist(i).canbevisible&(P.drawing.visible==1); % 0/1 value
	pos = P.drawing.upperleft(1)*[1 0 1 0]+...
		P.drawing.upperleft_shift(2)*[0 1 0 1] + ...
		P.drawing.upperleft_shift(1)*[1 0 1 0] + ...
		P.drawing.upperleft_shift(2)*[0 1 0 1] + ...
		controllist(i).position;
	ctl = findobj('Tag',controllist(i).name);
	if isempty(ctl), % have to build it
		[S,ctl] = Build(S,controllist(i).name);
	end;
	if length(ctl)>1,
		error(['Found 2 occurrences of the tag ' controllist(i).name ...
				'; not sure how it happened']);
	else, % possibly have to move it, show/hide it
		set(ctl,'position',pos,'visible',onoff(vis));
	end;
end;

subsheetlets = GetSubSheetlet(S);

for i=1:length(subsheetlets),
	pos = P.drawing.upperleft+P.drawing.upperleft_shift+subsheetlets(i).position;
	vis = subsheetlets(i).canbevisible&(P.drawing.visible==1);
	%classname = subsheetlet(i).type;
	%mys = eval([classname '(controllist(i).name);']);
	Draw(sheetlet(subsheetlets(i).name),pos,vis);
	% you might ask, why don't we grab the object that is returned by Draw above? the answer is
	% we don't have to, as long as we subsequently reference it by its name

end;
