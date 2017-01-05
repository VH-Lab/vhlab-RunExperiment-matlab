function [S,ctl] = Build(S_in, varargin)


% BUILD - Build a sheetlet object
%
%  [S,CTLs] = BUILD(S_IN) or
%
%  [S,CTLs] = BUILD(S_IN, CTLNAME1, CTLNAME2, ...)
%
%  This function "builds" or creates the uicontrol objects or
%  sub-sheetlet objects for the sheetlet S_IN.
%
%  If the function is called with a list of CTLNAMES (strings
%  with the tag name), then the corresponding uicontrol is created.
%  Handles to the uicontrols are returned in CTL.
%
%  See also:  SHEETLET

ctl = [];
S = S_in;

namestring = NameString(S);

if nargin>2, % call it and add to it
	[S,newctl1] = Build(S,varargin{1:end-1});
	[S,newctl2] = Build(S,varargin{end});
	ctl = [newctl1 newctl2];
	return;
end;

if nargin==2,
	name = varargin{1};
	% here, we should check to see what the type of control is, and make the
        % appropriate call
	params = GetParameters(S);
	[ctl_struct,ctl] = GetControl(S,name);
	if ~isempty(ctl_struct),
		if ~isempty(ctl), delete(ctl); end;
		ctl = uicontrol('Tag',name,'callback','GenericSheetletCallBack',ctl_struct.extra{:});
	end;
else,
	error(['How did this function get called with no arguments? Should not be possible.']);
end;

