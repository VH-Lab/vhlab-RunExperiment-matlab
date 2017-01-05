function [hlist,lengthwidth] = blinkingstimscriptsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''blinkingstimscriptsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = button.Callback;
cb.fontsize = 12;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 200 20],'string','BlinkingStim set','Tag',[typeName 'RCtxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
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

h = uicontrol(txt,'position',[upperLeft(1)+50 upperLeft(2)-30 100 20],'string',['display length(s)'],'Tag',[typeName 'DisplayDurationsTxt']);
hlist = [hlist h];
h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-30 150 20],'string','[0.020 0.040 0.1 0.2]','Tag',[typeName 'DisplayDurationsEdit']);
hlist = [hlist h];
h = uicontrol(txt,'position',[upperLeft(1)+50+170+100+5 upperLeft(2)-30 100 20],'string',['pause length(s)'],'Tag',[typeName 'PauseDurationsTxt']);
hlist = [hlist h];
h = uicontrol(edit,'position',[upperLeft(1)+50+170+5+100+100 upperLeft(2)-30 150 20],'string','[0.020 0.040 0.1 0.2]','Tag',[typeName 'PauseDurationsEdit']);
hlist = [hlist h];
h = uicontrol(txt,'position',[upperLeft(1)+170+100+5+100+100+100-40+50 upperLeft(2)-30 130 20],'string',['rep_stim rep_overall isi'],'Tag',[typeName 'RepInfoTxt']);
hlist = [hlist h];
h = uicontrol(edit,'position',[upperLeft(1)+170+5+5*100+5+50 upperLeft(2)-30 100 20],'string','[5 1 10]','Tag',[typeName 'RepInfoEdit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [810 35];
