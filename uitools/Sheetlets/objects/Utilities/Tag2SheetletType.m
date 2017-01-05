function classname = Tag2SheetletType(tag)

% TAG2SHEETLETYPE - Returns sheetlet type from a Tag
%
%  CLASSNAME = TAG2SHEETLETTYPE(TAG_STRING)
%
%  Returns the classname of the sheelet that owns the
%  control with tag TAG.


classname = ''; 

spacers = find(tag=='_');

 % sheetlet name

sn = tag(1:spacers(end)-1);
act = tag(spacers(end)+1:end);

base = findobj('tag',[sn '_base']);

if ~isempty(base),
	ud = get(base,'userdata');
	classname = ud.type;
end;
