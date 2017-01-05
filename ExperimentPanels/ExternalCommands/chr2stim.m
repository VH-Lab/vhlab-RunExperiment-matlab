function newscript = chr2stim(values,dur,commandstr,origscript,outputpath)

if nargin==0,
    newscript = 'scriptmodifier';
    return;
end;

newscript = [];

switch commandstr,
    case 'EditScript',
     % make a smart guess at doparam and reps

        do = getDisplayOrder(origscript);
        N = numStims(origscript);
        reps = round(length(do)/N);
        if eqlen(do(:),repmat(1:N,1,reps)'), doparam = 3; else, doparam = 1; end;

        [newscript,iontTable] = makeiontophoresisscript(origscript,values,dur,0,doparam,reps);

        writeiontophoresistable(outputpath,iontTable);

        ans = questdlg('You must now RESET the acquisition program and start it','','OK','Cancel','OK');
        if strcmp(ans,'Cancel'),
            newscript = [];
        end;
    case 'CleanUp',
        try, delete([outputpath 'iontophoresis_instruction.txt']); end;
end;

