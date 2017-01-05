function lwscript = lineweightsheetlet_run(fig,typeName, gratCtrlName)

[base,reps,isi,randomize,blank]=gratingcontrolsheetlet_getoptions(fig, gratCtrlName);

offstr = get(findobj(fig,'tag',[typeName 'shiftsEdit']),'string');
try, offs = str2num(offstr); catch, errordlg(['Syntax error in shifts: ' offstr '.']); error; end;
lwdstr = get(findobj(fig,'tag',[typeName 'LWDurEdit']),'string');
try, lwdur = str2num(lwdstr); catch, errordlg(['Syntax error in [L W Dur]: ' lwdstr '.']); error; end;
p = getparameters(base); p.dispprefs = {'BGposttime',lwdur(3)}; 	p.rect = [ 0 0 2 2];
base = periodicstim(p);
[newrect,dist,screenrect] = getscreentoolparams;
foreachstimdolocal({'base'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
lwscript = makelineweighting(base,offs,[1 -1],lwdur(1),lwdur(2),lwdur(3));
mngray = (p.chromhigh+p.chromlow)/2;
if blank, lwscript = addblankstim(lwscript,mngray); end;
lwscript = setDisplayMethod(lwscript,randomize,reps);


