function [varargout]=modulatingdoublegratingsheetlet_process(fig, typeName, ds, command, varargin)
% var input argument order testName,tuneEdit,parameter,TuneWithModulatingGratingCB,tune2Edit,parameter2,Tune2WithModulatingGrating,gratCtrl,modGratCtrl,GoodCB,refCtrl
command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
	[testName,tuneEdit,parameter,TuneWithModulatingGratingCB,tune2Edit,parameter2,Tune2WithModulatingGratingCB,gratCtrl,modGratCtrl,GoodCB,refCtrl]=...
			modulatingdoublegratingsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end; % testname
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'string',varargin{2}); end; % tuneEdit string
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'TitleText']),'userdata',varargin{3});end; % parameter1
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'TuneWithModulatingGratingCB']),'value',varargin{4});end; % is first param modulating?
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'Tune2Edit']),'string',varargin{5}); end; % tune2Edit string
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'Title2Text']),'userdata',varargin{6});end; % parameter2
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'Tune2WithModulatingGratingCB']),'value',varargin{7});end; % is second param modulating?
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata',varargin{8}); end; % gratCtrl
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'Tune2Edit']),'userdata',varargin{9}); end; % modGratCtrl 
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{10}); end;  % goodCB
        if length(varargin)>10&~isempty(varargin{11}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{11}); end; % refCtl
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end; % testname
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'string'); end; % first tuneEdit string
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'TitleText']),'userdata'); end; % parameter 1
        if nargout>2, varargout{4}=get(findobj(fig,'tag',[typeName 'TuneWithModulatingGratingCB']),'value'); end; % is first param modulating?
        if nargout>3, varargout{5}=get(findobj(fig,'tag',[typeName 'Tune2Edit']),'string'); end; % second tuneedit string
        if nargout>4, varargout{6}=get(findobj(fig,'tag',[typeName 'Title2Text']),'userdata'); end; % parameter 2
        if nargout>2, varargout{7}=get(findobj(fig,'tag',[typeName 'Tune2WithModulatingGratingCB']),'value'); end; % is second param modulating?
        if nargout>5, varargout{8}=get(findobj(fig,'tag',[typeName 'TuneEdit']),'userdata'); end; % gratCtrl sheetlet
        if nargout>5, varargout{9}=get(findobj(fig,'tag',[typeName 'Tune2Edit']),'userdata'); end; % modGratCtrl sheetlet
        if nargout>6, varargout{10}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end; % goodCB
        if nargout>7, varargout{11}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end; % refCtrl
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        [psm,repsm,isim,randomize,blankm]=gratingcontrolsheetlet_process(fig, modGratCtrl, ds, [modGratCtrl 'GetVars']);
        p=getparameters(ps);
        pm=getparameters(psm);
	p.rect = pm.rect; % use second rectangle
        if strcmp(typeName,'CoarseDir'), p.imageType = 1;  end;
        mystimdur = duration(periodicstim(p));
	try, p1list = eval(tuneEdit); catch, errordlg(['Syntax error in ' typeName ': ' tuneEdit '.'],'My Error Dialog'); end;
	try, p2list = eval(tune2Edit);catch, errordlg(['Syntax error in ' typeName ': ' tune2Edit '.'],'My Error Dialog'); end;
        p.dispprefs = {'BGposttime',isi};
	myps = stimscript(0);
	for i=1:length(p1list),
		if TuneWithModulatingGratingCB,
			pm = setfield(pm,parameter,p1list(i));
		else,
			p = setfield(p,parameter,p1list(i));
		end;
		for j=1:length(p2list),
			if Tune2WithModulatingGratingCB,
				pm = setfield(pm,parameter,p2list(j));
			else,
				p = setfield(p,parameter2,p2list(j));
			end;
			mypsparams = p,
			mypsparams.ps_mask = periodicstim(pm);
			myps = append(myps,periodicstim(mypsparams));
		end;
	end;
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'myps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        if strcmp(parameter,'tFrequency')|strcmp(parameter2,'tFrequency'),
            for i=1:numStims(myps),
                p = getparameters(get(myps,i));
                p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
                myps=set(myps,periodicstim(p),i);
            end;
        elseif strcmp(parameter,'sPhaseShift')|strcmp(parameter2,'sPhaseShift'), % default is counterphase
            for i=1:numStims(myps);
                p = getparameters(get(myps,i));
                p.flickerType = 2;
                p.animType = 2;
                myps=set(myps,periodicstim(p),i);
            end;
        end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, myps = addblankstim(myps,mngray); end;
        myps=setDisplayMethod(myps, randomize, reps);
        test=RunScriptRemote(ds,myps,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['modulatingdoublegratingsheet' typeName],'-mat');g=getfield(g,['modulatingdoublegratingsheet' typeName]);
        modulatingdoublegratingsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['modulatingdoublegratingsheet' typeName '={testName,tuneEdit,parameter,TuneWithModulatingGratingCB,tune2Edit,parameter2,Tune2WithModulatingGratingCB,gratCtrl,modGratCtrl,GoodCB,refCtrl};']);
        eval(['save ' fname ' modulatingdoublegratingsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','modulatingdoublegratingsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,pref,dummy,dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1,'stimnum');
                assoc = struct('type',[typeName ' test'],'owner','modulatingdoublegratingsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','modulatingdoublegratingsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);
end;
