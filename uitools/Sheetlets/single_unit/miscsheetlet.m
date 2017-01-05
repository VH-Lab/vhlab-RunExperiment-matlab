function [hlist,lengthwidth] = miscsheetlet(title,typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''miscsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''miscsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

upperLeft (2)=upperLeft(2)+15;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-25 200 20],'string',['Additional Comments:'],'Tag',[typeName 'commentstxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+10 upperLeft(2)-170 200 150],'string','','Tag',[typeName 'commentsEdit'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+470 upperLeft(2)-47 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+220 upperLeft(2)-50 100 20],'string',['Putative Layers:'],'Tag',[typeName 'putativetxt'], 'horizontalalignment', 'right');
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+340 upperLeft(2)-50 100 20],'string',{'---', 'Ctx','1', '2' '3', '4a', '4m', '4b', '5', '6','---','LGN1','LGN2','LGN3','LGN4','LGN5','LGN6'},'Tag',[typeName 'putativePopup']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+220 upperLeft(2)-75 100 20],'string',['Histology Layer:'],'Tag',[typeName 'histologytxt'], 'horizontalalignment', 'right');
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+340 upperLeft(2)-75 100 20],'string',{'---', 'Ctx','1', '2' '3', '4a', '4m', '4b', '5', '6','---','LGN1','LGN2','LGN3','LGN4','LGN5','LGN6'},'Tag',[typeName 'histologyPopup']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+220 upperLeft(2)-100 100 20],'string',['Isolation:'],'Tag',[typeName 'isolationtxt'], 'horizontalalignment', 'right');
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+340 upperLeft(2)-100 100 20],'string',{'---', 'Multi-unit', 'Good' 'Excellent'},'Tag',[typeName 'isolationPopup']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+220 upperLeft(2)-125 100 20],'string',['Penetration #:'],'Tag',[typeName 'depthtxt'], 'horizontalalignment', 'right');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+340 upperLeft(2)-125 100 20],'string','','Tag',[typeName 'penetrationEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+220 upperLeft(2)-125-25 100 20],'string',['Depth:'],'Tag',[typeName 'depthtxt'], 'horizontalalignment', 'right');
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+340 upperLeft(2)-125-25 100 20],'string','','Tag',[typeName 'depthEdit']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [490 170+30];