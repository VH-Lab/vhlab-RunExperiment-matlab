function [varargout]=brieforisheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName,gratCtrl,GoodCB,refCtrl


command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [testName,gratCtrl,GoodCB,refCtrl]=brieforisheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'TestEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'TestEdit']),'userdata',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata',varargin{4}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'TestEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'TestEdit']),'userdata'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'AnalyzeBt']),'userdata'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, gratCtrl, ds, [gratCtrl 'GetVars']);
        p=getparameters(ps);
        mystimdur = duration(periodicstim(p));
        TF = [2 6]; SF = [ 0.2 0.5 0.8]; ORI = [ 0:22.5:180-22.5];
        p.contrast = 0.8;
        p.dispprefs = {'BGposttime',isi};
        mystimscript = stimscript(0);
        [newrect,dist,screenrect] = getscreentoolparams;
        inc=0;
        for t=1:length(TF), for s=1:length(SF), for o=1:length(ORI),
            p.tFrequency = TF(t); p.sFrequency = SF(s); p.angle = ORI(o);
            p.nCycles = max([1 round(mystimdur*p.tFrequency/(p.loops+1))]);
            p.stimnum=inc;inc=inc+1;
            ps = periodicstim(p);
            foreachstimdolocal({'ps'},'recenterstim',{'rect',newrect,'screenrect',screenrect,'params',1});
            mystimscript = append(mystimscript,ps);
        end;end;end;
        mngray = (p.chromhigh+p.chromlow)/2;
        if blank, mystimscript = addblankstim(mystimscript,mngray); end;
        mystimscript=setDisplayMethod(mystimscript, randomize, reps);
        test=RunScriptRemote(ds,mystimscript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'TestEdit']),'string',test);        
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['brieforisheetlet' typeName],'-mat');
        if isfield(g,['brieforisheetlet' typeName]),
            g=getfield(g,['brieforisheetlet' typeName]);
            brieforisheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
        end;
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['brieforisheetlet' typeName '={testName,gratCtrl,GoodCB,refCtrl};']);
        eval(['save ' fname ' brieforisheetlet' typeName ' -append -mat']);
    case 'AnalyzeBt',
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata','');
        [mycell,mycellname] = referencesheetlet_process(fig,refCtrl,ds,[refCtrl 'GetCells']);
        db.assoc = {}; db.cellnames = mycellname;
        if ~isempty(mycell),
            for j=1:length(mycell),
                [dummy,dummy,co]=singleunitlineweight(ds, mycell{j}, mycellname{j}, testName, 'stimnum', 1);
                %lineweightsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],'','','',pref);
                assoc = struct('type',[typeName ' test'],'owner','brieforisheetlet','data',testName,'desc',[typeName ' test']);
                assoc(end+1) = struct('type',[typeName ' resp'],'owner','brieforisheetlet','data',co,'desc',[typeName ' resp']);
                db.assoc{j} = assoc;
            end;
        end;
        set(findobj(fig,'tag',[typeName 'GoodCB']),'userdata',db); 
    case 'AddDBBt',
        if get(findobj(fig,'tag',[typeName 'GoodCB']),'value')~=1,
            assoc = [];
            if nargout>0, varargout{1} = []; end;
        else,
            assoc = struct('type',[typeName ' test'],'owner','brieforisheetlet','data',testName,'desc',[typeName ' test']);            
        end;
        if nargout>0, varargout{1} = assoc; end;        
end;
