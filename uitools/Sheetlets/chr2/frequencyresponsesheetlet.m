function [hlist,lengthwidth] = frequencyresponsesheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''frequencyresponsesheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''frequencyresponsesheetlet_process'',''' typeName ''');'];
cb.fontsize = 10;



hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 140 20],'string','Frequency Response','Tag',[typeName 'freqresptxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+155 upperLeft(2)-7 40 20],'string',title,'Tag',[typeName 'freqtxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+200 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'freqlistEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+305 upperLeft(2)-7 110 20],'string','[PW Dur ISI Reps]','Tag',[typeName 'Durationtxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+415 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'DurationEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+515 upperLeft(2)-7 30 20],'string','Run','Tag',[typeName 'RunBt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+550 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+655 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+660+80 upperLeft(2)-7 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [750 20];