function [hlist,lengthwidth] = referencesheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''referencesheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''referencesheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

list=button;list.style='list';

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 80 20],'string','Reference','Tag',[typeName 'reftxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+200 upperLeft(2)-7 100 20],'string','Name / Ref #','Tag',[typeName 'namereftxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+350 upperLeft(2)-30 60 20],'string','Save','Tag',[typeName 'SaveBt']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+415 upperLeft(2)-30 80 20],'string','Restore','Tag',[typeName 'RestoreBt']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+500 upperLeft(2)-30 80 20],'string','Update','Tag',[typeName 'UpdateBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100 upperLeft(2)-30 50 20],'string','Cells:','Tag',[typeName 'cellstxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(list,'position',[upperLeft(1)+140 upperLeft(2)-80 200 70],'string','','Tag',[typeName 'cellList']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+350 upperLeft(2)-53 100 20],'string','Add to DB','Tag',[typeName 'DBBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100 upperLeft(2)-105 100 20],'string','Filename Extra','Tag',[typeName 'filenametxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+205 upperLeft(2)-105 135 20],'string','','Tag',[typeName 'filenameEdit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [580 110];
