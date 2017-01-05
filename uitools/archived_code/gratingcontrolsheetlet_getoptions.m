function [base,reps,isi,randomize,blank] = gratingcontrolsheetlet_getoptions(fig,typeName)

mystruct = get(findobj(fig,'tag',[typeName 'EditBaseBt']),'userdata');
base = mystruct.ps;

respstr = get(findobj(fig,'tag',[typeName 'RepsEdit']),'string');
isistr = get(findobj(fig,'tag',[typeName 'ISIEdit']),'string');
randomize = get(findobj(fig,'tag',[typeName 'RandomCB']),'value');
blank = get(findobj(fig,'tag',[typeName 'BlankCB']),'value');

try, eval(['reps = ' respstr ';']);
catch, errordlg(['Error in reps string: ' respstr '.']);
end;

try, eval(['isi = ' isistr ';']);
catch, errordlg(['Error in isi string: ' isistr '.']);
end;
