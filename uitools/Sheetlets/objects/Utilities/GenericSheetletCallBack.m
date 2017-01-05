function GenericSheetletCallBack

% GENERICSHEETLETCALLBACK - Generic callback function for sheetlets
%
%   Uses the 'Tag' field of the clicked object to determine which
%   sheetlet and action to call.

tag = get(gcbo,'Tag');

classname = Tag2SheetletType(tag);

spacers = find(tag=='_');
sn = tag(1:spacers(end)-1);
act = tag(spacers(end)+1:end);

if ~isempty(classname),
	eval(['Action(' classname '(sn),act);']);
end;


