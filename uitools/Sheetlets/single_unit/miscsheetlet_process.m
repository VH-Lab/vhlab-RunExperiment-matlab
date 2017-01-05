function [varargout]=miscsheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: putative_layer_value,
 % histology_layer_value, isolation_value, commentsstr, goodcb,
 % depthEdit, penetrationEdit

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [putative_layer_value,histology_layer_value,isolation_value,commentsstr,GoodCB,depthString,penetrationString]=miscsheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0, set(findobj(fig,'tag',[typeName 'putativePopup']),'value',varargin{1}); end;
        if length(varargin)>1, set(findobj(fig,'tag',[typeName 'histologyPopup']),'value',varargin{2}); end;
        if length(varargin)>2, set(findobj(fig,'tag',[typeName 'isolationPopup']),'value',varargin{3}); end;
        if length(varargin)>3, set(findobj(fig,'tag',[typeName 'commentsEdit']),'string',varargin{4}); end;
        if length(varargin)>4, set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{5}); end;
        if length(varargin)>5, set(findobj(fig,'tag',[typeName 'depthEdit']),'string',varargin{6}); end;
        if length(varargin)>6, set(findobj(fig,'tag',[typeName 'penetrationEdit']),'string',varargin{7}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'putativePopup']),'value'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'histologyPopup']),'value'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'isolationPopup']),'value'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'commentsEdit']),'string'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'depthEdit']),'string'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'penetrationEdit']),'string'); end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['miscsheet' typeName],'-mat'); g = getfield(g,['miscsheet' typeName]);
        miscsheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['miscsheet' typeName '={putative_layer_value,histology_layer_value,isolation_value,commentsstr,GoodCB,depthString,penetrationString};']);
        ['save ' fname ' miscsheet' typeName ' -append -mat'],
        eval(['save ' fname ' miscsheet' typeName ' -append -mat']);
    case 'AddDBBt',
        if GoodCB,
            putstr = get(findobj(fig,'tag',[typeName 'putativePopup']),'string');
            histstr = get(findobj(fig,'tag',[typeName 'histologyPopup']),'string');
            isostr = get(findobj(fig,'tag',[typeName 'isolationPopup']),'string');
            assoc=struct('type','Putative Layer','owner','miscsheetlet','data',putstr{putative_layer_value},'desc','');
            assoc(end+1)=struct('type','Histology Layer','owner','miscsheetlet','data',histstr{histology_layer_value},'desc','');
            assoc(end+1)=struct('type','Isolation','owner','miscsheetlet','data',isostr{isolation_value},'desc','');
            assoc(end+1)=struct('type','Comments','owner','miscsheetlet','data',commentsstr,'desc','');
            assoc(end+1)=struct('type','depth','owner','miscsheetlet','data',str2nume(depthString),'desc','');
            assoc(end+1)=struct('type','penetration','owner','miscsheetlet','data',str2nume(penetrationString),'desc','');
            if nargout>0, varargout{1} = assoc; end;
        else,
            warning('Warning: misc sheetlet was not checked.');
            if nargout>0, varargout{1} = []; end;
        end;
end;