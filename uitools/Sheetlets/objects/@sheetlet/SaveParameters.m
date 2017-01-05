function SaveParameters(S)

% SAVEPARAMETERS - Save Sheetlet parameters

namestring = NameString(S);

set(findobj('Tag', [namestring '_base']),'userdata',GetParameters(S));


