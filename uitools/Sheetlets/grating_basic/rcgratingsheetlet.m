function [hlist,lengthwidth] = rcgratingsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''rcgratingsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''rcgratingsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

hlist = [];

h = uicontrol(button,'position',[upperLeft(1)+430 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-7 250 20],'string','','Tag',[typeName 'TuneEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 150 20],'string',title{1},'Tag',[typeName 'TitleText'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+490 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-3 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+600 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+40 upperLeft(2)-30 150 20],'string',title{2},'Tag',[typeName 'Title2Text'], 'horizontalalignment', 'left','fontweight','bold');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30 250 20],'string','','Tag',[typeName 'Tune2Edit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+170+255 upperLeft(2)-30 100 20],'string','[ISI Reps BISI]','Tag',[typeName 'PLabel'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170+255+100 upperLeft(2)-30 150 20],'string','','Tag',[typeName 'ISIRepsBISIEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+40 upperLeft(2)-30-23 150 20],'string',title{3},'Tag',[typeName 'Title3Text'], 'horizontalalignment', 'left','fontweight','bold');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30-23 250 20],'string','','Tag',[typeName 'Tune3Edit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [700 30+25];
