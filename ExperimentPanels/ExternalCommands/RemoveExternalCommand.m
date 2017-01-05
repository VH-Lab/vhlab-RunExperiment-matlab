function [b,I] = RemoveExternalCommand(replacestr)

% B is 1 if the list was found and searched successfully
% I contains index values that were removed.  LENGTH(I) will indicate number of entries that
% were removed.
%

I = [];

b = 0;

z = geteditor('RunExperiment');
if isempty(z), b = 0; return; end; % can't do it if there's no editor
myobj = findobj(z,'tag','extdevlist');
if ~ishandle(myobj), b = 0; return; end; % can't do it if there's no list

ecdlist = get(findobj(z,'tag','extdevlist'),'string');
for i=1:length(ecdlist),
	if any(findstr(ecdlist{i},replacestr)),
		I(end+1) = i;
	end;
end;

ecdlist = ecdlist(setdiff(1:length(ecdlist),I));

l = length(ecdlist);
if l==0, value = []; else, value = 1; end;
set(myobj,'string',ecdlist,'value',value);

b = 1;
