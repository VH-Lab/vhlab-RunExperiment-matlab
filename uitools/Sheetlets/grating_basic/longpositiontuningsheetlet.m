function [hlist,lengthwidth] = longpositiontuningsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''longpositiontuningsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''longpositiontuningsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;



hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 100 20],'string','Long Pos Tune','Tag',[typeName 'lineweighttxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+130 upperLeft(2)-7 60 20],'string','Shifts:','Tag',[typeName 'shiftstxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-7 100 20],'string','-98:14:98','Tag',[typeName 'shiftsEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+280 upperLeft(2)-7 60 20],'string','[L W C1 CN]:','Tag',[typeName 'LWDurtxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+350 upperLeft(2)-7 100 20],'string','[800 7 0.1]','Tag',[typeName 'LWDurEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+460 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+520 upperLeft(2)-7 70 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+600 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [750 10];
