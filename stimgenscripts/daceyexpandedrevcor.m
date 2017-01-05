function dscript = daceyexpandedrevcor(base, OTs, SFs, phases, reps)

[Lc,Sc,Rc,RGB_plus,RGB_minus] = TreeshrewConeContrastsColorExchange(4);

p = getparameters(base);

dscript = stimscript(0);

stimnum = 1;

for i=1:length(RGB_plus),
    p.chromhigh = 255 * [ RGB_plus(:,i)'];
    p.chromlow =  255 * [ RGB_minus(:,i)'];
    for k=1:length(OTs),
        p.angle = OTs(k);
        for s=1:length(SFs),
            p.sFrequency = SFs(s);
            for t=1:length(phases),
                p.sPhaseShift = phases(t);
                p.stimnum = stimnum;
                stimnum = stimnum+1;
                newstim = periodicstim(p);
                dscript = append(dscript,newstim);
            end;
        end;
    end;
end;

dscript = setDisplayMethod(dscript,1,reps);
