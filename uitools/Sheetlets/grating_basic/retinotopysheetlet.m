function [hlist,lengthwidth] = retinotopysheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''retinotopysheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''retinotopysheetlet_process'',''' typeName ''');'];
cb.fontsize = 10;



hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 70 20],'string','Retinotopy','Tag',[typeName 'retinotopytxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100 upperLeft(2)-7 160 20],'string','[Start Step Stop Width X?]','Tag',[typeName 'startstoptxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+265 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'startstopEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+370 upperLeft(2)-7 30 20],'string','Run','Tag',[typeName 'RunBt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+405 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+515 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+600 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [750 20];