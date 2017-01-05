function [hlist,lengthwidth] = gratingcontrolsheetlet(typeName,upperLeft)

button.Units = 'pixels';
button.BackgroundColor = [0.8 0.8 0.8];
button.HorizontalAlignment = 'center';
button.Callback = ['sheetlet_callback(''gratingcontrolsheetlet_process'',''' typeName ''');'];

txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
txt.fontsize = 10; txt.fontweight = 'normal';
txt.HorizontalAlignment = 'center';txt.Style='text';

edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';

popup = txt; popup.style = 'popupmenu';

cb = txt; cb.Style = 'Checkbox'; cb.Callback = ['sheetlet_callback(''gratingcontrolsheetlet_process'',''' typeName ''');'];
cb.fontsize = 12;

hlist = [];

h = uicontrol(button,'position',[upperLeft(1)+40 upperLeft(2)-10 80 20],'string','Edit Base','Tag',[typeName 'EditBaseBt']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+120 upperLeft(2)-10 50 20],'string','Reps:','Tag',[typeName 'Repstxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+170 upperLeft(2)-10 80 20],'string','','Tag',[typeName 'RepsEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+260 upperLeft(2)-10 30 20],'string','ISI:','Tag',[typeName 'ISItxt']);
hlist = [hlist h];

h = uicontrol(edit,'position',[upperLeft(1)+290 upperLeft(2)-10 80 20],'string','','Tag',[typeName 'ISIEdit']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+380 upperLeft(2)-10 80 20],'string','Randomize','Tag',[typeName 'Randomtxt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+460 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'RandomCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+480 upperLeft(2)-10 60 20],'string','Blank','Tag',[typeName 'Blanktxt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+540 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'BlankCB']);
hlist = [hlist h];

h = uicontrol(txt,'position',[upperLeft(1)+540+15 upperLeft(2)-10 100 20],'string','Blank is black','Tag',[typeName 'BlankIsBlacktxt']);
hlist = [hlist h];

h = uicontrol(cb,'position',[upperLeft(1)+540+15+85+20 upperLeft(2)-5 10 10],'string','','Tag',[typeName 'BlankIsBlackCB']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','RestoreVars','visible','off','Tag',[typeName 'RestoreVarsBt']);
hlist = [hlist h];

h=uicontrol(button,'position',[0 0 1 1],'String','SaveVars','visible','off','Tag',[typeName 'SaveVarsBt']);
hlist = [hlist h];
lengthwidth = [580 10];

