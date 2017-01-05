function S = RmControlVar(S_in, name)

% RMCONTROLVAR - Remove a control variable from a sheetlet
%  
%   S = RMCONTROL(S_IN, NAME)
%
%  Removes the control with the name NAME from the sheetlet S_IN.
%  

S = S_in;

controlvarlist = GetControlVar(S_in);

foundit = 0;

for i=1:length(controlvarlist),
        if strcmp(controlvarlist(i),name, name),
		foundit = 1;
		break;
        end;
end;

if foundit==0,
	error(['Did not find a control variable named ' name ' to remove.']);
else,
	P = GetParameters(S);
	P.controlvarlist = controlvarlist([1:foundit-1 foundit+1:end]);
	S.params = P;
	SaveParameters(S);
end;
