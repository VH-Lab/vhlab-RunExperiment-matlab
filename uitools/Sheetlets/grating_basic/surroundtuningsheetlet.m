function [hlist,lengthwidth] = surroundtuningsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''surroundtuningsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = button.Callback;
cb.fontsize = 10;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 100 20],'string','Surround tuning:','Tag',[typeName 'LWtxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+110+80 upperLeft(2)-7 130 20],'string','Surround angle:','Tag',[typeName 'SurroundAngleTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+110+80+130 upperLeft(2)-7 120 20],'string','angles','Tag',[typeName 'SurroundAngleEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+110 upperLeft(2)-30 80 20],'string','Stim size:','Tag',[typeName 'StimSizeTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+110+80 upperLeft(2)-30 80 20],'string','125','Tag',[typeName 'StimSizeEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+460 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+520 upperLeft(2)-7 70 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+600 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

% h = uicontrol(txt,'position',[upperLeft(1)+90 upperLeft(2)-30 90 20],'string',['Preference:'],'Tag',[typeName 'preftxt']);
% hlist = [hlist h];

% h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30 100 20],'string','pref1','Tag',[typeName 'prefEdit1Bt']);
% hlist = [hlist h];
% 
% h = uicontrol(edit,'position',[upperLeft(1)+275 upperLeft(2)-30 100 20],'string','pref2','Tag',[typeName 'prefEdit2Bt']);
% hlist = [hlist h];
% 
% h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-28 10 10],'string','','Tag',[typeName 'prefCB']);
% hlist = [hlist h];
% 

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [700 40];
