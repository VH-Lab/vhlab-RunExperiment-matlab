function [hlist,lengthwidth] = glidersheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''glidersheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = button.Callback;
cb.fontsize = 12;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 200 20],'string','Glider stim','Tag',[typeName 'RCtxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+170 upperLeft(2)-7 80 20],'string','Edit1','Tag',[typeName 'CoarseEditBt']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+260 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'CoarseRunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+320 upperLeft(2)-7 50 20],'string','','Tag',[typeName 'CoarseTestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+380 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeCoarseBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+470 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'CoarseCB']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+500 upperLeft(2)-7 80 20],'string','Edit2','Tag',[typeName 'FineEditBt']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+590 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'FineRunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+650 upperLeft(2)-7 50 20],'string','','Tag',[typeName 'FineTestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+710 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeFineBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+800 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'FineCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+50 upperLeft(2)-30 100 20],'string',['frames reps isi'],'Tag',[typeName 'Centertxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30 100 20],'string','','Tag',[typeName 'CenterEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+280 upperLeft(2)-30-2 140 20],'string',['Enable fames/reps/isi:'],'Tag',[typeName 'Signtxt'],'visible','on');
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+330 upperLeft(2)-30 70 20],'string',{'---', 'On', 'Off'},'Tag',[typeName 'OnOffPopup'],'visible','off');
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+280+140+5 upperLeft(2)-28 10 10],'string','','Tag',[typeName 'CenterLocCB'],'visible','on');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+280+140+5+15 upperLeft(2)-30 70 20],'string',['gliders'],'Tag',[typeName 'gliderText']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+280+140+5+15+5+70 upperLeft(2)-30 100 20],'string','[0:5]','Tag',[typeName 'gliderEdit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [810 35];
