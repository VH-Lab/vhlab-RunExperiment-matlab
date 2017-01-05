function [hlist,lengthwidth] = positionsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''positionsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''positionsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 70 20],'string','Position','Tag',[typeName 'Positiontxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+90 upperLeft(2)-7 80 20],'string','Patch Size:','Tag',[typeName 'Patchtxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-7 50 20],'string','','Tag',[typeName 'PatchEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+230 upperLeft(2)-7 80 20],'string','Search Size:','Tag',[typeName 'Searchtxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+310 upperLeft(2)-7 50 20],'string','','Tag',[typeName 'SearchEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+380 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+440 upperLeft(2)-7 50 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+500 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+590 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+90 upperLeft(2)-30 80 20],'string',['Step Size:'],'Tag',[typeName 'steptxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30 50 20],'string','','Tag',[typeName 'stepEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+230 upperLeft(2)-30 70 20],'string',['Preference:'],'Tag',[typeName 'preftxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+310 upperLeft(2)-30 50 20],'string','','Tag',[typeName 'prefEdit']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+590 upperLeft(2)-28 10 10],'string','','Tag',[typeName 'prefCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [600 30];