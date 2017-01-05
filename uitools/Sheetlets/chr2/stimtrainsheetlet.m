function [hlist,lengthwidth] = stimtrainsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''stimtrainsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''stimtrainsheetlet_process'',''' typeName ''');'];
cb.fontsize = 10;



hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 80 20],'string',title,'Tag',[typeName 'StimTraintxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+90 upperLeft(2)-7 250 20],'string','[Pulse Width, Pulse Interval, Num Pulses]','Tag',[typeName 'Pulsetxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+345 upperLeft(2)-7 150 20],'string','','Tag',[typeName 'pulselistEdit'],'callback',['sheetlet_callback(''stimtrainsheetlet_process'',''' typeName ''');']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+500 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [750 20];