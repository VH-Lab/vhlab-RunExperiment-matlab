function newscript = vdaqintrinsicmodifier(thescript)

newscript = stimscript(0);
do = getDisplayOrder(thescript);

for i=1:numStims(thescript),
    p = getparameters(get(thescript,i));
    p.dispprefs = cat(2,p.dispprefs,{'BGpretime',0.55});
    str = class(get(thescript,i));
	eval(['newstim=' str '(p);']);
	newscript = append(newscript,newstim);
end;

newscript = setDisplayMethod(newscript,2,do);