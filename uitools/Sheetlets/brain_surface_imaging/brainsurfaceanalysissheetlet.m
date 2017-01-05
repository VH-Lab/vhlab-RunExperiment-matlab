function [hlist,lengthwidth] = brainsurfaceanalysissheetlet(typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''brainsurfaceanalysissheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'left'; txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit'; edit.HorizontalAlignment = 'center';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''brainsurfaceanalysissheetlet_process'',''' typeName ''');'];


hlist = [];


h = uicontrol(cb,'position',[upperLeft(1)+0 upperLeft(2)-7 150 20],'string','LV Intrinsic On','Tag',[typeName 'LVIntrinsicONCB'],'fontweight','bold');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+0 upperLeft(2)-10-20 100 20],'string','Stim opts','Tag',[typeName 'StimOptionsTxt'],'fontweight','bold');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100+5 upperLeft(2)-10-20 100 20],'string','Subtract frames','Tag',[typeName 'FSTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+100+5+100+5 upperLeft(2)-10-20 30 20],'string','1','Tag',[typeName 'FSEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100+5+100+5+30+5 upperLeft(2)-10-20 100 20],'string','Divide frames','Tag',[typeName 'DSTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+100+5+100+5+100+5+30+5 upperLeft(2)-10-20 30 20],'string','1','Tag',[typeName 'DFEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100+5+100+5+100+5+30+5+35 upperLeft(2)-10-20 100 20],'string','Signal frames','Tag',[typeName 'SigFTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+100+5+100+5+100+5+70+5+30+5+35+30 upperLeft(2)-10-20 100 20],'string','[3:10]','Tag',[typeName 'SigFEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100+5+100+5+100+5+30+5+35+30+105+70 upperLeft(2)-10-20 70 20],'string','Multiply','Tag',[typeName 'MultTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+100+5+100+5+100+5+70+5+30+5+35+30+105+75 upperLeft(2)-10-20 70 20],'string','1000','Tag',[typeName 'MultEdit']);
hlist = [hlist h];

 % map options
h = uicontrol(txt,'position',[upperLeft(1)+0 upperLeft(2)-35-20 100 20],'string','Map opts','Tag',[typeName 'MapOptsTxt'],'fontweight','bold');
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+100+5 upperLeft(2)-35-20 150 20],'string','Difference images','Tag',[typeName 'DifferenceImageCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100+5+150+5 upperLeft(2)-35-20 100 20],'string','Mean filter:','Tag',[typeName 'MeanFilterTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+100+5+150+5+100+5 upperLeft(2)-35-20 40 20],'string','100','Tag',[typeName 'MeanFilterEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+100+5+150+5+100+5+5+40 upperLeft(2)-35-20 100 20],'string','Median filter:','Tag',[typeName 'MedianFilterTxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+100+5+150+5+100+5+5+40+100+5 upperLeft(2)-35-20 30 20],'string','5','Tag',[typeName 'MedianFilterEdit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];
lengthwidth = [100+5+150+5+100+5+5+40+100+5+5 65];

