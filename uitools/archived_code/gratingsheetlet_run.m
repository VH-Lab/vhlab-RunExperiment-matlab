function myps = gratingsheetlet_run(fig, typeName, parameter, GratCtrlName)

[ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_getoptions(fig, GratCtrlName);
p=getparameters(ps);
str=get(findobj(fig, 'tag', [typeName 'TuneEdit']), 'string');
try
    eval(['p.' parameter '=' str ';']);
catch
    errordlg(['Syntax Error in ' typeName ': ' str '.'], 'My Error Dialog');
end
p.dispprefs = {'BGposttime',isi};
myps=periodicscript(p);
myps=setDisplayMethod(myps, randomize, reps);
