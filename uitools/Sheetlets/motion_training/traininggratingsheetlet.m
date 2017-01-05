function [hlist,lengthwidth] = traininggratingsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''traininggratingsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'left';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''traininggratingsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

%figure;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+125 upperLeft(2)-7 55 20],'string',['Pref Dir:'],'Tag',[typeName 'DirPrefTxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+125+60 upperLeft(2)-7 50 20],'string','','Tag',[typeName 'DirPrefEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+125+60+55 upperLeft(2)-7 90 20],'string','[ON OFF](min)','Tag',[typeName 'ONOFFText']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+125+80+55+80 upperLeft(2)-7 60 20],'string','[20 10]','Tag',[typeName 'ONOFFEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-7 115 20],'string',[title],'Tag',[typeName 'Titletxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

  % run / testedit / analyze / good check box

h = uicontrol(button,'position',[upperLeft(1)+430 upperLeft(2)-7 50 20],'string','Run','Tag',[typeName 'RunBt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+490 upperLeft(2)-7 100 20],'string','','Tag',[typeName 'TestEdit']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+600 upperLeft(2)-7 80 20],'string','Analyze','Tag',[typeName 'AnalyzeBt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+690 upperLeft(2)-3 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

  % second row

h = uicontrol(txt,'position',[upperLeft(1)+40 upperLeft(2)-30 75 20],'string',['Method:'],'Tag',[typeName 'MethodTxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+105 upperLeft(2)-30 125 20],'string',{'Bidirectional','Unidirectional','Counterphase--single sPhase','Flash--randomized sPhase','4-directional','8-directional','Seq A1','Seq A2','Seq A3','Seq A4','Seq A5','Seq A6','Seq A7','Seq A8','Seq B1','Seq B2','Seq B3','Seq B4','Seq B5','Seq B6','Seq B7','Seq B8','Seq B9','Seq B10','Seq B11','Seq B12','Field', 'OrthAlternating','Short Gratings'},'Tag',[typeName 'methodPopup']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+110+125+5 upperLeft(2)-30 80 20],'string','Acquire','Tag',[typeName 'AcquireCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+430 upperLeft(2)-30 150 20],'string','Elapsed Time: 0:00:00','Tag',[typeName 'ElapsedTxt']);
hlist = [hlist h];

h = uicontrol(button,'position',[upperLeft(1)+600 upperLeft(2)-30 80 20],'string','Stop','Tag',[typeName 'StopBt']);
hlist = [hlist h];

   % hidden buttons

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [700 30];
