function thescript = positionsheetlet_run(fig, typeName, gratCtrlName)

[base,reps,isi,randomize,blank]=gratingcontrolsheetlet_getoptions(fig, gratCtrlName);

pszs = get(findobj(fig,'Tag',[typeName 'PatchEdit']),'string');
try, patsz = str2num(pszs); catch, errordlg(['Syntax error in Patch size : ' pszs '.']); error; end;	
szs = get(findobj(fig,'Tag',[typeName 'SearchEdit']),'string');
try, sz = str2num(szs); catch, errordlg(['Syntax error in Search size : ' szs '.']); error; end;
sss = get(findobj(fig,'Tag',[typeName 'stepEdit']),'string');
try, stepsize = str2num(sss); catch, errordlg(['Syntax error in stepsize: ' sss '.']); error; end;
p = getparameters(base);
xctr = mean(p.rect([1 3])); yctr = mean(p.rect([2 4]));
p.rect = round([xctr yctr xctr yctr]+patsz*[-1 -1 1 1]/2);
p.dispprefs = {'BGposttime',isi};
base = periodicstim(p);
[newrect,dist,screenrect] = getscreentoolparams;
foreachstimdolocal({'base'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
sz = ceil(sz/stepsize);
thescript = makegratingposition(base,sz,sz,stepsize);
mngray = (p.chromhigh+p.chromlow)/2;
if blank, thescript = addblankstim(thescript,mngray); end;
thescript = setDisplayMethod(thescript,randomize,reps);
