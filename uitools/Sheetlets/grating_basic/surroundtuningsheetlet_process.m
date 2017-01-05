function [varargout]=surroundtuningsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,SurroundAngleStr,StimSizeStr,pgratCtrl,GoodCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,SurroundAngleStr,StimSizeStr,gratCtrl,GoodCB,refsh]=surroundtuningsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'SurroundAngleEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'StimSizeEdit']),'string',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'StimSizeEdit']),'userdata',varargin{4}); end;        
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{6}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'SurroundAngleEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'StimSizeEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'StimSizeEdit']),'userdata'); end;        
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        try, SurroundAngle= str2num(SurroundAngleStr); catch, errordlg(['Syntax error in Flank Location Angle string: ' SurroundAngleStr '.']); return; end;
	try, StimSize = str2num(StimSizeStr); catch, errordlg(['Syntax erorr in Stim Size string:' StimSizeStr '.']); end;
        p = getparameters(ps);
        [newrect,dist,screenrect] = getscreentoolparams;
        p.rect = screenrect;
        p.dispprefs = {'BGposttime',isi};
	p.windowShape = 0;
        base = periodicstim(p);
        foreachstimdolocal({'base'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
        surroundscript = makelengthwidthoverlaytuning(base,SurroundAngle,StimSize,StimSize);
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, surroundscript = addblankstim(surroundscript,mngray); end;
        surroundscript = setDisplayMethod(surroundscript,randomize,reps);
        test=RunScriptRemote(ds,surroundscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['surroundtuningsheet' typeName],'-mat'); g=getfield(g,['surroundtuningsheet' typeName]);
        surroundtuningsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['surroundtuningsheet' typeName '={testName,SurroundAngleStr,StimSizeStr,gratCtrl,GoodCB,refsh};']);
        eval(['save ' fname ' surroundtuningsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','surroundtuningsheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        refsh='ref',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refsh,ds,[refsh 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        savedScript = getstimscript(ds,testName)
	%islength = isempty(intersect(sswhatvaries(savedScript),'length'));
	%if islength, paramstr = 'length'; else, paramstr = 'width'; end;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, 'surroundangle', 1);
		myfig = gcf;
                assoc = struct('type',[typeName ' test'],'owner','surroundtuningsheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','surroundtuningsheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;

