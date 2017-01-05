function S = AddSubSheetlet(S_in, name, position, canbevisible, varargin)

% ADDSUBSHEETLET - Add a subsheetlet to a sheetlet object
%
%   S = ADDSUBSHEETLET(S_IN, NAME, LOCAL_POSITION, ...
%              CANBEVISIBLE, VARARGIN)
%
%  Adds a subsheetlet to the list of the sheetlets that the sheelet knows.
%
%  NAME is the tag name of the subsheetlet (should be [NameString(S) '_MYNAME'],
%    where MYNAME is the name of the Action the control will call.)
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

newstruct = struct('name',name,'position',position,'canbevisible',canbevisible);

newstruct.extra = {};

if ~isempty(varargin),
	newstrict.extra = varargin;
end;

if isempty(S.params.subsheetlets),
	S.params.subsheetlets = newstruct;
else,
	foundit = 0;
	% make sure it's not already there, and overwrite if need be
	for i=1:length(S.params.subsheetlets),
		if strcmp(S.params.subsheetlets(i),name),
			S.params.subsheetlets(i) = newstruct;
			foundit = 1;
			break;
		end;
	end;
	if ~foundit, S.params.subsheetlets(end+1) = newstruct; end;
end;

SaveParameters(S);
