function S = RmSubSheetlet(S_in, name)

% RMSUBSHEETLET - Remove a SubSheetlet from a sheetlet
%  
%   S = RMSUBSHEETLET(S_IN, NAME)
%
%  Removes the subsheetlet with the name NAME from the sheetlet S_IN.
%  

S = S_in;

P = GetParameters(S);

foundit = 0;

for i=1:length(P.subsheetlets),
        if strcmp(P.subsheetlets(i),name, name),
		foundit = 1;
		break;
        end;
end;

if foundit==0,
	error(['Did not find a subsheetlet named ' name ' to remove.']);
else,
	P.subsheetlets= P.subsheetlets([1:foundit-1 foundit+1:end]);
	S.params = P;
	SaveParameters(S);
end;
