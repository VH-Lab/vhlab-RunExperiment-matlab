function [hlist,lengthwidth] = eyemonitorpossheetlet(typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''eyemonitorpossheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''eyemonitorpossheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

%figure;

hlist = [];

h = uicontrol(txt,'position',[upperLeft(1)+420 upperLeft(2)-25 40 20],'string',['Eye:'],'Tag',[typeName 'eyetxt']);
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+470 upperLeft(2)-25 50 20],'string',{'---', '1', '2', '3', '4', '5', '6', '7'},'Tag',[typeName 'eyePopup']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+10 upperLeft(2)-25 120 20],'string',['Monitor Position'],'Tag',[typeName 'monitorpostxt'], 'fontweight', 'bold', 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+155 upperLeft(2)-3 50 20],'string',['X'],'Tag',[typeName 'Xtxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+140 upperLeft(2)-25 80 20],'string','','Tag',[typeName 'XEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+245 upperLeft(2)-3 50 20],'string',['Y'],'Tag',[typeName 'Ytxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+230 upperLeft(2)-25 80 20],'string','','Tag',[typeName 'YEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+335 upperLeft(2)-3 50 20],'string',['Z'],'Tag',[typeName 'Ztxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+320 upperLeft(2)-25 80 20],'string','','Tag',[typeName 'ZEdit']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+530 upperLeft(2)-20 10 10],'string','','Tag',[typeName 'GoodCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+40 upperLeft(2)-85 70 20],'string',['Optic Disks'],'Tag',[typeName 'opticdisktxt'], 'horizontalalignment', 'left');
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+110 upperLeft(2)-75 60 20],'string',['Left:'],'Tag',[typeName 'Lefttxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-75 80 20],'string','','Tag',[typeName 'LeftVEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+110 upperLeft(2)-95 60 20],'string',['Right:'],'Tag',[typeName 'righttxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-95 80 20],'string','','Tag',[typeName 'RightVEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+160 upperLeft(2)-55 100 20],'string',['Vertical'],'Tag',[typeName 'Verttxt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+240 upperLeft(2)-55 100 20],'string',['Horizontal'],'Tag',[typeName 'Horizontxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+250 upperLeft(2)-75 80 20],'string','','Tag',[typeName 'LeftHEdit']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+250 upperLeft(2)-95 80 20],'string','','Tag',[typeName 'RightHEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+340 upperLeft(2)-85 100 20],'string',['Hemisphere:'],'Tag',[typeName 'Hemitxt']);
hlist = [hlist h];

h = uicontrol(popup,'position',[upperLeft(1)+450 upperLeft(2)-85 70 20],'string',{'---', 'Left', 'Right'},'Tag',[typeName 'HemiPopup']);
hlist = [hlist h];

% h = uicontrol(cb,'position',[upperLeft(1)+530 upperLeft(2)-85 10 10],'string','','Tag',[typeName 'prefCB']);
% hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','AddDB','visible','off','Tag',[typeName 'AddDBBt']);
hlist = [hlist h];

lengthwidth = [540 95];