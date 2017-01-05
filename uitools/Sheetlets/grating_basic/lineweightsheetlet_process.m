function [varargout]=lineweightsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,shifts,lwdur,preference,gratCtrl,GoodCB,prefCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,shiftsstr,lwdurstr,preference,gratCtrl,GoodCB,prefCB,refsh]=lineweightsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'shiftsEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'LWDurEdit']),'string',varargin{3}); end;
        %if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'positionEdit']),'string',mat2str(varargin{4})); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'shiftsEdit']),'userdata',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'prefCB']),'value',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{8}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'shiftsEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'LWDurEdit']),'string'); end;
        %if nargout>3, varargout{4}=str2mat(get(findobj(fig,'tag',[typeName 'positionEdit']),'string')); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'shiftsEdit']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'prefCB']),'value'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        gratCtrl
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        reps = 30;
        p=getparameters(ps);
        p.dispprefs = {'BGposttime',isi};
	if eqlen(p.chromhigh,[0 0 255]),
        	mngray = ([0 0 0])/2;
		signs = 1;
	else,
        	mngray = (p.chromhigh+p.chromlow)/2;
		signs = [1 -1];
	end;
        try, offs = eval([shiftsstr]); catch, errordlg(['Error in shifts']); error('Error in shifts'); end;
        try, lwdur = eval([lwdurstr]); catch, errordlg(['Error in LWDur string']); error('Error in LWDur string'); end;
        p.dispprefs = {'BGposttime',0*lwdur(3)};
        p.contrast = 1;
        base = periodicstim(p);
        [newrect,dist,screenrect] = getscreentoolparams;
        foreachstimdolocal({'base'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        thescript = makelineweighting(base,offs,signs,lwdur(1),lwdur(2),lwdur(3));
        if blank, thescript = addblankstim(thescript,mngray); end;
        thescript = setDisplayMethod(thescript,randomize,reps);
        test=RunScriptRemote(ds,thescript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['lineweightsheet' typeName],'-mat'); g=getfield(g,['lineweightsheet' typeName]);
        lineweightsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['lineweightsheet' typeName '={testName,shiftsstr,lwdurstr,preference,gratCtrl,GoodCB,prefCB,refsh};']);
        eval(['save ' fname ' lineweightsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','lineweightsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        refsh='ref',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refsh,ds,[refsh 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitlineweight(ds, mycell{j}, mycellname{j}, testName, 'linenumber', 1);
                %lineweightsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','lineweightsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','lineweightsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;
