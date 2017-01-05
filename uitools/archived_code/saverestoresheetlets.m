function saverestoresheetlets(fig,filename,saveorrestore)

bts = findobj(fig,'tag','');

if saveorrestore==1, btnstr = 'SaveVars'; elseif saveorrestore==-1, btnstr = 'RestoreVars'; end;

for i=1:length(bts),
    if findstr(get(bts(i),'tag'),btnstr),
        set(bts(i),'userdata',filename);
        eval(get(bts(i),'callback'));
    end;
end;