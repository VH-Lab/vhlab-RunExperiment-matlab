function [ctl,handle] = GetControl(S, name)

% GETCONTROL - Get the control structure for a sheetlet
%
%  [CTL_STRUCTURE,HANDLE] = GETCONTROL(S, NAME)
%
%  Returns the control structure (in CTL_STRUCTURE) and,
%  if found, the Matlab handle for the actual control.
%
%  NAME should be the name of the control, in the form
%  [NAMESTRING(S) '_MYCTLNAME'].
%
%  If NAME is not provided, then the structure list of all
%  controls is returned in CTL and HANDLE is [].


ctl = [];
handle = [];

P = GetParameters(S);

if nargin==1, ctl = P.controllist; return; end;

handle = findobj('Tag',name);

for i=1:length(P.controllist),
	if strcmp(P.controllist(i).name, name),
		ctl = P.controllist(i);
		break;
	end;
end;
