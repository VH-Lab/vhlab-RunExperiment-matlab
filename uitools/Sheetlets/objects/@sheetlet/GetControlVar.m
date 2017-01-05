function [ctl] = GetControlVar(S, name)

% GETCONTROLVAR - Get a control variable for a sheetlet
%
%  [CTLVAR] = GETCONTROLVAR(S, NAME)
%
%  Returns the control variable structure (in CTLVAR).
%
%  NAME should be the name of the variable, in the form
%  [NAMESTRING(S) '_MYVARNAME'].
%
%  If NAME is not provided, then the structure list of all
%  controls is returned in CTL and HANDLE is [].


ctl = [];
handle = [];

P = GetParameters(S);

if nargin==1, ctl = P.controlvarlist; return; end;

for i=1:length(P.controlvarlist),
	if strcmp(P.controlvarlist(i),name, name),
		ctl = P.controlvarlist(i);
		break;
	end;
end;
