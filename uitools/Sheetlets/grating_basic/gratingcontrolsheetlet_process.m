function [varargout]=gratingcontrolsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: revstim1, test1, revstim2, test2, ctrloc,
 % onoffvalue, cb1, cb2, ctrcb

 % if number of input arguments is 3
 %   then process a command
 % if number of arguments is 7, then set variables
 %   revstim1, test1, revstim2, test2, ctrloc, cb1, cb2

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [base,reps,isi,random,blank,blankisblack]=gratingcontrolsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0, mystruct.ps = varargin{1}; set(findobj(fig,'tag',[typeName 'EditBaseBt']),'userdata',mystruct); end;
        if length(varargin)>1, set(findobj(fig,'tag',[typeName 'RepsEdit']),'string',num2str(varargin{2})); end;
        if length(varargin)>2, set(findobj(fig,'tag',[typeName 'ISIEdit']),'string',num2str(varargin{3})); end;
        if length(varargin)>3, set(findobj(fig,'tag',[typeName 'RandomCB']),'value',varargin{4}); end;
        if length(varargin)>4, set(findobj(fig,'tag',[typeName 'BlankCB']),'value',varargin{5}); end;
        if length(varargin)>5, set(findobj(fig,'tag',[typeName 'BlankIsBlackCB']),'value',varargin{6}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'EditBaseBt']),'userdata'); varargout{1}=varargout{1}.ps; end;
        if nargout>1, varargout{2}=str2num(get(findobj(fig,'tag',[typeName 'RepsEdit']),'string')); end;
        if nargout>2, varargout{3}=str2num(get(findobj(fig,'tag',[typeName 'ISIEdit']),'string')); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'RandomCB']),'value'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'BlankCB']),'value'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'BlankIsBlackCB']),'value'); end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['gratingcontrolsheet' typeName],'-mat');g=getfield(g,['gratingcontrolsheet' typeName]);
        gratingcontrolsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['gratingcontrolsheet' typeName '={base,reps,isi,random,blank,blankisblack};']);
        eval(['save ' fname ' gratingcontrolsheet' typeName ' -append -mat']);
    case 'EditBaseBt',
        base=periodicscript('graphical', base);
        if ~isempty(base)
            gratingcontrolsheetlet_process(fig, typeName, ds, [typeName 'SetVars'], base);
        end        
end;
