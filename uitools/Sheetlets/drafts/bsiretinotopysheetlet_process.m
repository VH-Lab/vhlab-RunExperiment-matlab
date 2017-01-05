function [varargout]=bsiretinotopysheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 % testName,startstopeditstr,gratCtrl,GoodCB,refsh

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,startstopeditstr,gratCtrl,GoodCB,refsh,bsiCtl]=retinotopysheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'startstopEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'startstopEdit']),'userdata',varargin{3}); end;        
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{6}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'startstopEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'startstopEdit']),'userdata'); end;        
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        try, arg = str2num(startstopeditstr); catch, errordlg(['Syntax error in command: ' startstopeditstr '.']); return; end;
        p = getparameters(ps);
        p.dispprefs = {'BGposttime',isi};
        ctr= mean(arg([1 3]));
        mngray = (p.chromhigh+p.chromlow)/2;
        myangle = mod(p.angle,360);
        if arg(5), % searching in X
            p.rect = [ ctr-arg(4)/2 0-300 ctr+arg(4)/2 600+300];
            Y=1; X = round(diff(arg([1 3]))/arg(2))+1; stimvalues = X;
            p.windowShape = 4;
        else,
            p.rect = [ 0-300 ctr-arg(4)/2 800+300 ctr+arg(4)/2];
            X=1; Y = round(diff(arg([1 3]))/arg(2))+1; stimvalues = Y;
            p.windowShape = 2;
        end;
        base = periodicstim(p);
        posscript=makegratingposition(base,X,Y,arg(2));
        if blank, posscript = addblankstim(posscript,mngray); stimvalues(end+1) = NaN; end;
        posscript=setDisplayMethod(posscript,randomize,reps);
        %for i=1:numstims(posscript), g=getparameters(get(posscript,i));g.rect,end;
        test=RunScriptRemote(ds,posscript,saveit,0,1,stimvalues);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['retinotopysheet' typeName],'-mat'); g=getfield(g,['retinotopysheet' typeName]);
        retinotopysheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['retinotopysheet' typeName '={testName,startstopeditstr,gratCtrl,GoodCB,refsh,bsiCtl};']);
        eval(['save ' fname ' retinotopysheet' typeName ' -append -mat']);
    case 'AddDBBt',
        refsh='ref',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
        else,
            assoc = struct('type',[typeName ' test'],'owner','retinotopysheetlet','data',testName,'desc',[typeName ' test']);
        end;
        if nargout>0, varargout{1} = assoc; end;
    case 'AnalyzeBt',
        refsh='ref',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refsh,ds,[refsh 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        savedScript = getstimscript(ds,testName);
        sswhatvaries(savedScript),
        isxPos = isempty(intersect(sswhatvaries(savedScript),{'yposition'}));
        if isxPos, paramstr = 'xposition'; else, paramstr = 'yposition'; end;
        paramstr,
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitgrating2(ds, mycell{j}, mycellname{j}, testName, paramstr, 1);
                assoc = struct('type',[typeName ' test'],'owner','retinotopysheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','retinotopysheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db);        
end;
