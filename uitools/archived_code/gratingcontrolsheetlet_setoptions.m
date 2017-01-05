function gratingcontrolsheetlet_setoptions(fig,typeName,base,reps,isi,randomize,blank)

if ~isempty(base),
    mystruct.ps = base;
    set(findobj(fig,'tag',[typeName 'EditBaseBt']),'userdata',mystruct);
end;

if ~isempty(reps),
    set(findobj(fig,'tag',[typeName 'RepsEdit']),'string',num2str(reps));
end;

if ~isempty(isi),
    set(findobj(fig,'tag',[typeName 'ISIEdit']),'string',num2str(isi));
end;

if ~isempty(randomize), set(findobj(fig,'tag',[typeName 'RandomCB']),'value',randomize); end;
if ~isempty(blank), set(findobj(fig,'tag',[typeName 'BlankCB']),'value',blank); end;