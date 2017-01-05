function S = Delete(S_in)

% Delete - Delete graphic objects of a sheetlet
%
%  S = Delete(S)
%
%  Note that GetVars will likely not work properly after
%  calling this function.  Call this function only when you
%  are completely done with a sheetlet and want to release
%  all its graphic elements.
%
%  Returns [] to help remind you that the sheetlet reference is
%  no longer any good.

S = S_in;

for i=1:length(S.params.controllist),
	% calculate sizes
	if strcmp(S.params.controllist(i).type,'uicontrol'),
		delete(findobj('Tag',[NameString(S) '_' S.params.controllist(i).name]));
	else, % it is a sheetlet
		eval(['Delete(' S.params.controllist(i).type '(' NameString(S) '_' S.params.controllist(i).name '));']);
	end;
end;

S = [];
