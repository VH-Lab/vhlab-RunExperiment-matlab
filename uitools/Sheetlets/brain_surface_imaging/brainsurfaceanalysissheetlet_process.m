function [varargout]=brainsurfaceanalysissheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list: testName,gratCtrl,GoodCB,refCtrl


command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [subF,divF,SigF,Mult,DiffImg,MeanFilt,MedianFilt,LVIntrinsicON]=brainsurfaceanalysissheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0&~isempty(varargin{1}), set(findobj(fig,'tag',[typeName 'FSEdit']),'string',varargin{1}); end;
        if length(varargin)>1&~isempty(varargin{2}), set(findobj(fig,'tag',[typeName 'DFEdit']),'string',varargin{2}); end;
        if length(varargin)>2&~isempty(varargin{3}), set(findobj(fig,'tag',[typeName 'SigFEdit']),'string',varargin{3}); end;
        if length(varargin)>3&~isempty(varargin{4}), set(findobj(fig,'tag',[typeName 'MultEdit']),'string',varargin{4}); end;
        if length(varargin)>4&~isempty(varargin{5}), set(findobj(fig,'tag',[typeName 'DifferenceImageCB']),'value',varargin{5}); end;
        if length(varargin)>5&~isempty(varargin{6}), set(findobj(fig,'tag',[typeName 'MeanFilterEdit']),'string',varargin{6}); end;
        if length(varargin)>6&~isempty(varargin{7}), set(findobj(fig,'tag',[typeName 'MedianFilterEdit']),'string',varargin{7}); end;
        if length(varargin)>7&~isempty(varargin{8}), set(findobj(fig,'tag',[typeName 'LVIntrinsicONCB']),'value',varargin{8}); end;
        brainsurfaceanalysissheetlet_process(fig,typeName,ds,[typeName 'LVIntrinsicONCB']);
    case 'GetVars',
        if nargout>0, varargout{1}=get(findobj(fig,'tag',[typeName 'FSEdit']),'string'); end;
        if nargout>1, varargout{2}=get(findobj(fig,'tag',[typeName 'DFEdit']),'string'); end;
        if nargout>2, varargout{3}=get(findobj(fig,'tag',[typeName 'SigFEdit']),'string'); end;
        if nargout>3, varargout{4}=get(findobj(fig,'tag',[typeName 'MultEdit']),'string'); end;
        if nargout>4, varargout{5}=get(findobj(fig,'tag',[typeName 'DifferenceImageCB']),'value'); end;
        if nargout>5, varargout{6}=get(findobj(fig,'tag',[typeName 'MeanFilterEdit']),'string'); end;
        if nargout>6, varargout{7}=get(findobj(fig,'tag',[typeName 'MedianFilterEdit']),'string'); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'LVIntrinsicONCB']),'value'); end;
    case 'LVIntrinsicONCB',
        if ~isempty(z), set(findobj(z,'tag','lvintrinsic'),'value',LVIntrinsicON); end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['brainsurfaceanalysissheetlet' typeName],'-mat');
        if isfield(g,['brainsurfaceanalysissheetlet' typeName]),
            g=getfield(g,['brainsurfaceanalysissheetlet' typeName]);
            brieforisheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
        end;
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['brainsurfaceanalysissheetlet' typeName '={subF,divF,SigF,Mult,DiffImg,MeanFilt,MedianFilt,LVIntrinsicON};']);
        eval(['save ' fname ' brainsurfaceanalysissheetlet' typeName ' -append -mat']);   
end;
