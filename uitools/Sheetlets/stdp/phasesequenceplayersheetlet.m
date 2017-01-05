function [hlist,lengthwidth] = phasesequenceplayersheetlet(typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''phasesequenceplayersheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''phasesequenceplayersheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-10 100 20],'string','Phase seq','Tag',[typeName 'PhaseSeqText'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+430-200-10-100 upperLeft(2)-10 50 20],...
	'string','# stims','Tag',[typeName 'PhaseSeqEditLabelTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+430-200-10-100+50 upperLeft(2)-10 100 20],...
	'string','100','Tag',[typeName 'PhaseSeqEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+430-200-10-100+50+55+50 upperLeft(2)-10 50 20],...
	'string','#blanks','Tag',[typeName 'PhaseSeqEditLabel2Txt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+430-200-10-100+50+55+55+50 upperLeft(2)-10 40 20],...
	'string','10','Tag',[typeName 'PhaseSeqBlanksEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+430 upperLeft(2)-10 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+60+430 upperLeft(2)-10 100 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+430+60+110 upperLeft(2)-10 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+430+60+110+90 upperLeft(2)-7 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

lengthwidth = [430+60+110+60+20 20];
