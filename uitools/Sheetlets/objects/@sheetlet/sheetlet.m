function S = sheetlet(arg1, arg2, arg3)

% SHEETLET - Creates a new sheetlet object
%
%   SHEETLETs are collections of user interface elements that are related.
%   For example, you might want to draw a static text field that labels an
%   editable text field. 
% 
%   To create a new sheetlet in the current figure, use
%
%   S = SHEETLET(NAME, UPPER_LEFT, VISIBLE)
%
%   where NAME is the name of your sheetlet (known to Matlab, but not
%   visible to the user using the window), and UPPER_LEFT is the 
%   coordinate in X, Y (in pixels) of where the drawing should start.
%   VISIBLE is 0 if the sheetlet should be invisible, 1 if it should
%   be visible.
%
%   After the sheetlet already exists, an object structure can be
%   created by calling its name:
%
%   S = SHEETLET(NAME_STRING)
%

drawing.upperleft = [NaN NaN];
drawing.upperleft_shift = [0 0];
drawing.visible = NaN;

params = struct('name_string', [], 'type', 'sheetlet', 'controllist', [], 'subsheetlets',[],...
	'controlvarlist',[],'drawing', drawing);
finish = 0;
firsttime = 0;

if nargin==1, % build from data structures
	% control objects, drawing preferences
	name_string = arg1;
	myparams = get(findobj('Tag',[name_string '_base']),'userdata');
	if isempty(myparams),
		error(['Could not find any sheetlet ' name_string '.']);
	else,
		params = myparams;
		if ~strcmp(params.type,'sheetlet'),  % if it's not a vanilla sheetlet, call the appropriate creator
			eval(['S=' params.type '(name_string);']);
			return;
		end;
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
	S = class(struct('params',params),'sheetlet');
else, S = [];
end;

if firsttime,
	namestring = NameString(S);
	S = AddControl(S, [namestring '_' 'base'], 'pixels',[0 0 1 1], 0,'style','pushbutton');
	S = AddControl(S, [namestring '_' 'SaveBt'], 'pixels',[0 0 1 1], 0,'style','pushbutton');
	S = AddControl(S, [namestring '_' 'RestoreBt'], 'pixels',[0 0 1 1], 0,'style','pushbutton');
	S = Draw(S, upperleft, visible);
	SetVarValues(S,'default');
end;

  % methods
  %  name_string -- returns name__number
  %  itemlist - tag names / local coordinates
  %  Draw -- set location, visible
  %  SetVars
  %  GetVars
  %  Save
  %  Restore
  %  Delete
  %  Action
  %  Span - the size it takes up in width / height
  %  AddControl -- adds information about a control to the sheetlet -- does it draw it?  No, just adds type, name, position


  % what are the data structures?
  % params.
  %  type
  %  variables.
  %        varname1 = value1
  %        varname2 = value2
  %  controlobjects.
  %        type       uicontrol, sheetlet
  %        name       tagname or sheetlet_name
  %        location{i}   [left top right bottom], or [left top]
  %        canbevisible  0/1   can this item ever be visible?
  %  draw.
  %        upper_left
  %        upper_left_shift
  %        visible
  %        
  %        
  %      
  %   What is the mapping between uitools and the objects this guy finds?
  %       Option 1:
  %             If we simply use Tags, then we can only have an object local to this figure, or use a fancy numbering scheme
  % Tag could be ObjName_XXXX_controlname 

  %  Need GetNextSheetletNumber(name), returns next unused number
  %  Need GenericSheetletCallBack

  %     What parameters should be present in each one?
  %         UIControlList -- a structure with Tags / local coordinates
  %         Variables  -- a structure
  %                   derived from a structure or derived live from the uicontrol fields?
  %				% well, some have to be from a structure
  %                             % it's up to each function, but ultimately must be stored in the uicontrol fields
  %         %  what are standard controls?
  %                                   save / restore / button for everything else
  %         Draw -- upper left -- upper left shift -- visible
  %              how does it know which figure(s) to draw in?  let's have it be in a single figure for right now...
  %         Standard commands: 
  %             Save / Restore / Draw / Delete --  it's the sheet's problem to make sure this is set right at save/restore
  %             Should commands have their own function or just an Action command?  Let's start out with just an action
  %             command


