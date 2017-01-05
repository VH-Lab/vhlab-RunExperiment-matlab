function [hlist,lengthwidth] = lengthwidthsheetlet(title,typeName,upperLeft)

  % Why is this file here?  I don't know....

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = 'genercallback';

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 12; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = 'genercallback';
cb.fontsize = 12;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 110 20],'string','Length/Width:','Tag',[typeName 'LWtxt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+120 upperLeft(2)-7 100 20],'string','Lengths(pix):','Tag',[typeName 'Lengthtxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+230 upperLeft(2)-7 100 20],'string','pix','Tag',[typeName 'pixBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+340 upperLeft(2)-7 85 20],'string','Widths:','Tag',[typeName 'Widthtxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+430 upperLeft(2)-7 100 20],'string','width','Tag',[typeName 'widthBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+540 upperLeft(2)-7 50 20],'string','Run:','Tag',[typeName 'Runtxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+600 upperLeft(2)-7 50 20],'string','run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+660 upperLeft(2)-7 100 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+770 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100 upperLeft(2)-40 100 20],'string',['Preference:'],'Tag',[typeName 'preftxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+210 upperLeft(2)-40 100 20],'string','pref1','Tag',[typeName 'prefEdit1Bt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+320 upperLeft(2)-40 100 20],'string','pref2','Tag',[typeName 'prefEdit2Bt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+770 upperLeft(2)-38 10 10],'string','','Tag',[typeName 'prefCB']);
hlist = [hlist h];




lengthwidth = [700 50];
