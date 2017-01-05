function [varargout]=cpositionsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,PatchSize,SearchSize,StepSize,preference,gratCtrl,GoodCB,prefCB,refsh,intensity,duration,reps_string,isi_string

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,PatchSize,SearchSize,StepSize,preference,gratCtrl,GoodCB,prefCB,refsh,intensity,duration,reps_string,isi_string]=cpositionsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'PatchEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'SearchEdit']),'string',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'stepEdit']),'string',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'prefEdit']),'string',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'prefEdit']),'userdata',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'prefCB']),'value',varargin{8}); end;
        if length(varargin)>8&~isempty(varargin{9}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{9}); end;
        if length(varargin)>9&~isempty(varargin{10}), set(findobj(fig,'tag',[typeName 'intensityEdit']),'userdata',varargin{10}); end;
        if length(varargin)>10&~isempty(varargin{11}), set(findobj(fig,'tag',[typeName 'durationEdit']),'string',varargin{11}); end;
        if length(varargin)>11&~isempty(varargin{12}), set(findobj(fig,'tag',[typeName 'repsEdit']),'string',varargin{12}); end;
        if length(varargin)>12&~isempty(varargin{13}), set(findobj(fig,'tag',[typeName 'isiEdit']),'string',varargin{13}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'PatchEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'SearchEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'stepEdit']),'string'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'prefEdit']),'string'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'prefEdit']),'userdata'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'prefCB']),'value'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'intensityEdit']),'string'); end;
        if nargout>10, varargout{11}=get(findobj(fig,'tag',[typeName 'durationEdit']),'string'); end;
        if nargout>11, varargout{12}=get(findobj(fig,'tag',[typeName 'repsEdit']),'string'); end;
        if nargout>12, varargout{13}=get(findobj(fig,'tag',[typeName 'isiEdit']),'string'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank,blankisblack]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
        mngray = 0*(p.chromhigh+p.chromlow)/2 * (1-blankisblack);
        try, patsz = eval([PatchSize]); catch, errordlg(['Error in patch size']); error('Error in patch size'); end;
        try, sz = eval([SearchSize]); catch, errordlg(['Error in search size']); error('Error in search size'); end;
        try, stepsize = eval([StepSize]); catch, errordlg(['Error in step size']); error('Error in step size'); end;
        try, intensityval= eval([intensity]); catch, errordlg(['Error in intensity']); error('Error in intensity'); end;
        try, durationval= eval([duration]); catch, errordlg(['Error in duration']); error('Error in duration'); end;
	try, reps = eval(reps_string); catch, errordlg(['Error in reps']); error('Error in reps'); end;
	try, isi = eval(isi_string); catch, errordlg(['Error in isi']); error('Error in isi'); end;
        xctr = mean(p.rect([1 3])); yctr = mean(p.rect([2 4]));
    	p_cs = getparameters(centersurroundstim('default'));
    	p_cs.FGc = intensityval * p.chromhigh / 255;
    	p_cs.center = [xctr yctr];
    	p_cs.radius = patsz;
    	p_cs.stimduration = durationval;
        p_cs.dispprefs = {'BGposttime',isi};
    	p_cs.BG = mngray;
        [newrect,dist,screenrect] = getscreentoolparams;
    	newcenterrect = recenterrect(newrect,p_cs.center([1 2 1 2]),screenrect);
    	p_cs.center = newcenterrect([1 2]);
        base = centersurroundstim(p_cs);
        sz=ceil(1e-15+sz/stepsize);
        %sz = length(-sz:stepsize:sz);
        thescript = makecentersurroundposition(base,sz,sz,stepsize);
        if blank, thescript = addblankstim(thescript,mngray); end;
        thescript = setDisplayMethod(thescript,randomize,reps);
        test=RunScriptRemote(ds,thescript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['positionsheet' typeName],'-mat');g=getfield(g,['positionsheet' typeName]);
        cpositionsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['positionsheet' typeName '={testName,PatchSize,SearchSize,StepSize,preference,gratCtrl,GoodCB,prefCB,refsh,intensity,duration,reps_string,isi_string};']);
        eval(['save ' fname ' positionsheet' typeName ' -append -mat']);
    case 'AnalyzeBt',
        [mycell,mycellname] = referencesheetlet_process(fig,refsh,ds,[refsh 'GetCells']);
        for j=1:length(mycell),
            [dummy,dummy2,pref,dumm3,dummy4,s]=singleunitlineweight(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1);
            p = getparameters(get(s.stimscript,pref));
            pref = p.center;
            if ~isempty(pref), cpositionsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','','',mat2str(pref)); end;
        end;
    case 'prefCB',
        if prefCB, % if checked
            [ps]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
            p = getparameters(ps);
            pref = str2num(preference);
            xctr = pref(1); yctr = pref(2);
            p.rect = round([xctr yctr xctr yctr]+[-diff(p.rect([1 3])) -diff(p.rect([2 4])) diff(p.rect([1 3])) diff(p.rect([2 4]))]/2);
            ps = periodicscript(p);
            gratingcontrolsheetlet_process(fig,gratCtrl,ds,[gratCtrl 'SetVars'],ps);
            Z = geteditor('screentool');
            if ~isempty(Z),
                udd = get(Z,'userdata');
                set(udd.currrect,'string',mat2str(p.rect));
                myfig = gcf;
                figure(Z);
                screentool('plotcurr',Z);
                figure(myfig);
            end;
        end;
    case 'AddDBBt',
        if GoodCB,
            if nargout>0, varargout{1} = struct('type',[typeName ' test'],'owner','cpositionsheetlet','data',testName,'desc',[typeName ' test']);; end;
        else,
            warning('Warning: position sheetlet was not checked.');
            if nargout>0, varargout{1} = []; end;
        end;        
end;
