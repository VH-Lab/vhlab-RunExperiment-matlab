function [varargout]=gratingsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: revstim1, test1, revstim2, test2, ctrloc,
 % onoffvalue, cb1, cb2, ctrcb

 % if number of input arguments is 3
 %   then process a command
 % if number of arguments is 7, then set variables
 %   revstim1, test1, revstim2, test2, ctrloc, cb1, cb2

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [rev1s,t1s,rev2s,t2s,ctredit,onoff,cb1,cb2,cb3]=reversecorrelationsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0, set(findobj(fig,'tag',[typeName 'EditBaseBt']),'userdata',varargin{1}); end;
        if length(varargin)>1, set(findobj(fig,'tag',[typeName 'RepsEdit']),'string',num2str(varargin{2})); end;
        if length(varargin)>2, set(findobj(fig,'tag',[typeName 'ISIEdit']),'string',num2str(varargin{3})); end;
        if length(varargin)>3, set(findobj(fig,'tag',[typeName 'RandomCB']),'value',varargin{4}); end;
        if length(varargin)>4, set(findobj(fig,'tag',[typeName 'BlankCB']),'value',varargin{5}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'EditBaseBt']),'userdata'); varargout{1}=varargout{1}.ps; end;
        if nargout>1, varargout{2}=str2mat(get(findobj(fig,'tag',[typeName 'RepsEdit']),'string')); end;
        if nargout>2, varargout{4}=str2mat(get(findobj(fig,'tag',[typeName 'ISIEdit']),'string')); end;
        if nargout>3, varargout{5}=get(findobj(fig,'tag',[typeName 'RandomCB']),'value'); end;
        if nargout>4, varargout{6}=get(findobj(fig,'tag',[typeName 'BlankCB']),'value'); end;
    case 'RunBt',
        [ps,reps,isi,randomize,blank]=gratingcontrolsheetlet_process(fig, GratCtrlName, ds, [GratCtrlName 'GetVars']);
        p=getparameters(ps);
        try
            eval(['p.' parameter '=' str ';']);
        catch
            errordlg(['Syntax Error in ' typeName ': ' str '.'], 'My Error Dialog');
        end
        p.dispprefs = {'BGposttime',isi};
        myps=periodicscript(p);
        myps=setDisplayMethod(myps, randomize, reps);
        
        thescript=append(stimscript(0),rev1s);
        if nargout>0, varargout{1}=thescript; end;        
        test=RunScriptRemote(ds,thescript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'CoarseTestEdit']),'string',test);
    case 'FineRunBt',
        thescript=append(stimscript(0),rev2s);
        if nargout>0, varargout{1}=thescript; end;        
        test=RunScriptRemote(ds,thescript,saveit,0,1);
        set(findobj(fig,'Tag',[typeName 'FineTestEdit']),'string',test);
    case 'CoarseEditBt',
        cl = class(rev1s);
        if ~isempty(cl)&~strcmp(cl,'double'), 
            eval(['rev1s = ' cl '(''graphical'',rev1s);']);
        end;
        if ~isempty(rev1s),
            reversecorrelationsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],rev1s,[],[],[],[],[],[],[],[]);
        end;
    case 'FineEditBt',
        cl = class(rev2s);
        if ~isempty(cl)&~strcmp(cl,'double'), 
            eval(['rev1s = ' cl '(''graphical'',rev2s);']);
        end;
        if ~isempty(rev2s),
            reversecorrelationsheetlet_process(fig, typeName, ds, [typeName 'SetVars'],[],[],rev2s,[],[],[],[],[],[]);
        end;
    case 'CoarseCB',
    case 'FineCB',
    case 'CenterLocCB',
    case 'RestoreVarsBt',
        fname = findobj(fig,'tag',[typeName 'RestoreVarsBt']);
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['reversecorrsheet' typeName],'-mat');
    case 'SaveVarsBt',
        fname = findobj(fig,'tag',[typeName 'SaveVarsBt']);
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        [rev1s,t1s,rev2s,t2s,ctredit,onoff,cb1,cb2,cb3]=reversecorrelationsheetlet_process(fig, typeName, 'GetVars');
        eval(['reversecorrsheet' typeName '={rev1s,t1s,rev2s,t2s,ctredit,onoff,cb1,cb2,cb3};']);
        eval(['save ' fname ' reversecorrsheet' typeName '-append -mat']);
end;