function S = labeledEdit_sheetlet(arg1, arg2, arg3)

% SHEETLET - Creates a new labeledEdit_sheetlet object
%
%   SHEETLETs are collections of user interface elements that are related.
%   For example, you might want to draw a static text field that labels an
%   editable text field. 
% 
%   To create a new labeledEdit_sheetlet in the current figure, use
%
%   S = SHEETLET(NAME, UPPER_LEFT, VISIBLE)
%
%   where NAME is the name of your labeledEdit_sheetlet (known to Matlab, but not
%   visible to the user using the window), and UPPER_LEFT is the 
%   coordinate in X, Y (in pixels) of where the drawing should start.
%   VISIBLE is 0 if the labeledEdit_sheetlet should be invisible, 1 if it should
%   be visible.
%
%   After the labeledEdit_sheetlet already exists, an object structure can be
%   created by calling its name:
%
%   S = SHEETLET(NAME_STRING)
%

finish = 0;
firsttime = 0;

if nargin==1, % build from data structures
	% control objects, drawing preferences
	name_string = arg1;
	myparams = get(findobj('Tag',[name_string '_base']),'userdata');
	if isempty(myparams),
		error(['Could not find any labeledEdit_sheetlet ' name_string '.']);
	else,
		params = myparams;
		finish = 1;
	end;
elseif nargin==3, % 
	% creating for the first time
	finish = 1;
	firsttime = 1;
	name = arg1;
	upperleft = arg2;
	visible = arg3;
	params.name_string = [name '_' sprintf('%.4d',GetNextSheetletNumber(name))];
end;

if finish,
	if firsttime,
		s = sheetlet(params.name_string,[0 0],0); % parent
	else,
		s = sheetlet(params.name);
	end;
	S = class(struct('dummy',0),'labeledEdit_sheetlet',s);
else, S = [];
end;

if firsttime,
	namestring = NameString(S);
        S = AddControl(S, [namestring '_' 'Static'], 'pixels',[0 0 100 25], 1,'style','text');
        S = AddControl(S, [namestring '_' 'Edit'], 'pixels', [105 0 200 25], 1,'style','edit');
	S = AddControlVar(S, 'Static', [namestring '_' 'Static'], 'string');
	S = AddControlVar(S, 'Edit', [namestring '_' 'Edit'], 'string');
	S = Draw(S, upperleft, visible);
	SetVarValues(S,'default');
end;

