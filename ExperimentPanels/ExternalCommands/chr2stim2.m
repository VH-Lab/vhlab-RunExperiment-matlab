function newscript = chr2stim2(values,arg2,commandstr,origscript,outputpath)

if nargin==0,
    newscript = 'scriptmodifier';
    return;
end;

pulsewidth=arg2(1);pulseinterval=arg2(2);numpulses=arg2(3);


newscript = [];

switch commandstr,
    case 'EditScript',
     % make a smart guess at doparam and reps

        do = getDisplayOrder(origscript);
        N = numStims(origscript);
        reps = round(length(do)/N);
        if eqlen(do(:),repmat(1:N,1,reps)'), doparam = 3; else, doparam = 1; end;

        [newscript,iontTable] = makeiontophoresisscript2(origscript,values,pulsewidth,pulseinterval,numpulses,0,doparam,reps);

        writeiontophoresistable2(outputpath,iontTable);

        ans = questdlg('You must now RESET the acquisition program and start it','','OK','Cancel','OK');
        if strcmp(ans,'Cancel'),
            newscript = [];
        end;
    case 'CleanUp',
        try, delete([outputpath 'iontophoresis_instruction.txt']); end;
end;

