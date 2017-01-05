function S = RmControl(S_in, name)

% RMCONTROL - Remove a control from a sheetlet
%  
%   S = RMCONTROL(S_IN, NAME)
%
%  Removes the control with the name NAME from the sheetlet S_IN.
%  

S = S_in;

controllist = GetControl(S);

foundit = 0;

for i=1:length(controllist),
        if strcmp(controllist(i),name, name),
		foundit = 1;
		break;
        end;
end;

if foundit==0,
	error(['Did not find a control named ' name ' to remove.']);
else,
	P = GetParameters(S);
	P.controllist = controllist([1:foundit-1 foundit+1:end]);
	S.params = P;
	SaveParameters(S);
end;
