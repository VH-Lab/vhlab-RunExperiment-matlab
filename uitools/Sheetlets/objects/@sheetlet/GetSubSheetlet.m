function [subsheetlet] = GetSubSheetlet(S, name)

% GETCONTROL - Get the control structure for a sheetlet
%
%  [Subsheetlet] = GETSUBSHEETLET(S, NAME)
%
%  Returns the subsheetlet structure (in Subsheetlet).
%
%  NAME should be the name of the Subsheetlet, in the form
%  [NAMESTRING(S) '_MYSUBSHEETLET'].
%
%  If NAME is not provided, then the structure list of all
%  subsheetlets is returned in Subsheetlet.


subsheetlet = [];

P = GetParameters(S);

if nargin==1, subsheetlet = P.subsheetlets; return; end;

handle = findobj('Tag',name);

for i=1:length(P.subsheetlets),
	if strcmp(P.subsheetlets(i),name, name),
		subsheetlet = P.subsheetlets(i);
		break;
	end;
end;
