function [hlist,lengthwidth] = modulatinggratingsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''modulatinggratingsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''modulatinggratingsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

%figure;

hlist = [];

h = uicontrol(button,'position',[upperLeft(1)+430 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-7 250 20],'string','','Tag',[typeName 'TuneEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 150 20],'string',[title],'Tag',[typeName 'Titletxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-3 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+600 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+40 upperLeft(2)-30 100 20],'string',['Preference'],'Tag',[typeName 'preftxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-28 10 10],'string','','Tag',[typeName 'TuneWithModulatingGratingCB'],'visible','off');
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-28 10 10],'string','','Tag',[typeName 'prefCB']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+490 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30 100 20],'string','','Tag',[typeName 'prefEdit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [700 30];
