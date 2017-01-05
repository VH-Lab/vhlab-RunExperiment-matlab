function S = AddControl(S_in, name, units, position, canbevisible, varargin)

% ADDCONTROL - Add a control or subsheetlet to a sheetlet object
%
%   S = ADDCONTROL(S_IN, NAME, UNITS, LOCAL_POSITION, ...
%              CANBEVISIBLE, VARARGIN)
%
%  Adds a control to the list of the controls that the sheelet knows.
%
%  NAME is the tag name of the control (should be [NameStrin(S) '_MYNAME'],
%    where MYNAME is the name of the Action the control will call.)
%
%  UNITS are the units for the control, such as 'pixels'; See: UICONTROL
%
%  LOCAL_POSITION is a rectangle [left top right bottom] indicating where
%   the control should be drawn, in local coordinates with respect to the
%   UPPER_LEFT / UPPER_LEFT_SHIFT fields (see DRAW).
%
%  CANBESIVIBLE should be 1 if this control can ever be visible to the user.
%
%  VARARGIN are name/value pairs that can be passed to the control after
%    the default parameters (see 'help set').
%
%  If you try to add a control that already exists (that is, it has the
%  same name), then the newly added control will overwrite the old.
%
%  (Why is it desirable to have this function, you ask?
%   Why shouldn't this be done in Build?  The reason is so that
%   classes that are based on SHEETLET can add simple controls tothemselves;
%   in Matlab, descendent classes cannot access the fields of their ancestors.)
%
%  See also: ADDSUBSHEETLET SHEETLET

S = S_in;

newstruct = struct('name',name,'units',units,'position',position,'canbevisible',canbevisible);

newstruct.extra = {};

if ~isempty(varargin),
	newstruct.extra = varargin;
end;

if isempty(S.params.controllist),
	S.params.controllist = newstruct;
else,
	foundit = 0;
	% make sure it's not already there, and overwrite if need be
	for i=1:length(S.params.controllist),
		if strcmp(S.params.controllist(i),name),
			S.params.controllist(i) = newstruct;
			foundit = 1;
			break;
		end;
	end;
	if ~foundit, S.params.controllist(end+1) = newstruct; end;
end;

SaveParameters(S);
