function myrect = Span(S)

% SPAN - Size of a sheetlet in pixels
%
%  s = Span(S)
%
%  Returns the span of a sheetlet,
%     s = [ left top right bottom];

myrect = [];

for i=1:length(S.params.controllist),
	newrect = [];
	if S.params.controllist(i).canbevisible,
		% calculate sizes
		if strcmp(S.params.controllist(i).type,'uicontrol'),
			newrect = controllist(i).position;
		else, % it is a sheetlet
			eval(['newrect = Span(' S.params.controllist(i).type '(S.params.controllist(i).name));']);
		end;
	end;
	if isempty(myrect),
		myrect = newrect;
	elseif ~isempty(mynewrect),
		myrect = UnionRect(myrect,newrect);
	end;
end;
