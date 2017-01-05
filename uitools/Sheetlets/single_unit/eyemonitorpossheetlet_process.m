function [varargout]=eyemonitorpossheetlet_process(fig, typeName, ds, command, varargin)
 % var input argument order list:
 %Monx,Mony,Monz,eyeValue,ODLeftV,ODLeftH,ODRightV,ODRightH,Good1CB,Good2CB

command = command(length(typeName)+1:end);

command,

if ~strcmp(command, 'GetVars')&~strcmp(command,'SetVars'),
    [ODLeftV,ODLeftH,ODRightV,ODRightH,Monx,Mony,Monz,eyeValue,hemiValue,GoodCB]=eyemonitorpossheetlet_process(fig, typeName, ds, [typeName 'GetVars']);
end;

z=geteditor('RunExperiment');
if ~isempty(z), saveit = get(findobj(z,'string','Acquire Data'),'value');
else, saveit = 0;
end;

switch command,
    case 'SetVars',
        if length(varargin)>0, set(findobj(fig,'tag',[typeName 'LeftVEdit']),'string',num2str(varargin{1})); end;
        if length(varargin)>1, set(findobj(fig,'tag',[typeName 'LeftHEdit']),'string',num2str(varargin{2})); end;
        if length(varargin)>2, set(findobj(fig,'tag',[typeName 'RightVEdit']),'string',num2str(varargin{3})); end;
        if length(varargin)>3, set(findobj(fig,'tag',[typeName 'RightHEdit']),'string',num2str(varargin{4})); end;
        if length(varargin)>4, set(findobj(fig,'tag',[typeName 'XEdit']),'string',num2str(varargin{5})); end;
        if length(varargin)>5, set(findobj(fig,'tag',[typeName 'YEdit']),'string',num2str(varargin{6})); end;
        if length(varargin)>6, set(findobj(fig,'tag',[typeName 'ZEdit']),'string',num2str(varargin{7})); end;
        if length(varargin)>7, set(findobj(fig,'tag',[typeName 'eyePopup']),'value',varargin{8}); end;
        if length(varargin)>8, set(findobj(fig,'tag',[typeName 'HemiPopup']),'value',varargin{9}); end;
        if length(varargin)>9, set(findobj(fig,'tag',[typeName 'GoodCB']),'value',varargin{10}); end;
    case 'GetVars',
        if nargout>0, varargout{1}=str2nume(get(findobj(fig,'tag',[typeName 'LeftVEdit']),'string')); end;
        if nargout>1, varargout{2}=str2nume(get(findobj(fig,'tag',[typeName 'LeftHEdit']),'string')); end;
        if nargout>2, varargout{3}=str2nume(get(findobj(fig,'tag',[typeName 'RightVEdit']),'string')); end;
        if nargout>3, varargout{4}=str2nume(get(findobj(fig,'tag',[typeName 'RightHEdit']),'string')); end;
        if nargout>4, varargout{5}=str2nume(get(findobj(fig,'tag',[typeName 'XEdit']),'string')); end;
        if nargout>5, varargout{6}=str2nume(get(findobj(fig,'tag',[typeName 'YEdit']),'string')); end;
        if nargout>6, varargout{7}=str2nume(get(findobj(fig,'tag',[typeName 'ZEdit']),'string')); end;
        if nargout>7, varargout{8}=get(findobj(fig,'tag',[typeName 'eyePopup']),'value'); end;
        if nargout>8, varargout{9}=get(findobj(fig,'tag',[typeName 'HemiPopup']),'value'); end;
        if nargout>9, varargout{10}=get(findobj(fig,'tag',[typeName 'GoodCB']),'value'); end;        
    case 'GrabFromScreentool',
        ods = getscreentoolopticdisks(geteditor('screentool'));
        if ~isempty(ods),
            set(findobj(fig,'tag',[typeName 'LeftVEdit']),'string',num2str(ods.LeftVert));
            set(findobj(fig,'tag',[typeName 'LeftHEdit']),'string',num2str(ods.LeftHort));
            set(findobj(fig,'tag',[typeName 'RightVEdit']),'string',num2str(ods.RightVert));
            set(findobj(fig,'tag',[typeName 'RightHEdit']),'string',num2str(ods.RightHort));
        end;
        mps = getscreentoolmonitorposition(geteditor('screentool'));
        if ~isempty(mps),
            set(findobj(fig,'tag',[typeName 'XEdit']),'string',mps.MonPosX);
            set(findobj(fig,'tag',[typeName 'YEdit']),'string',mps.MonPosY);
            set(findobj(fig,'tag',[typeName 'ZEdit']),'string',mps.MonPosZ);
        end;
    case 'RestoreVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'RestoreVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'RestoreVarsBt']); end;
        g = load(fname,['eyemonitorpossheet' typeName],'-mat'); g=getfield(g,['eyemonitorpossheet' typeName]);
        eyemonitorpossheetlet_process(fig,typeName,ds,[typeName 'SetVars'],g{:});
    case 'SaveVarsBt',
        fname = get(findobj(fig,'tag',[typeName 'SaveVarsBt']),'userdata');
        if isempty(fname), error(['Empty filename for ' typeName 'SaveVarsBt']); end;
        eval(['eyemonitorpossheet' typeName '={ODLeftV,ODLeftH,ODRightV,ODRightH,Monx,Mony,Monz,eyeValue,hemiValue,GoodCB};']);
        eval(['save ' fname ' eyemonitorpossheet' typeName ' -append -mat']); 
    case 'AddDBBt',
        if GoodCB,
            assoc=struct('type','','owner','','data','','desc','');
            assoc = assoc([]);
            if ~isempty(Monx)&~isempty(Mony)&~isempty(Monz),
                Monpos = [Monx Mony Monz];
                assoc(end+1) = struct('type','Monitor position','owner','eyemonitorpossheetlet','data',Monpos, ...
                        'desc','');
            end;
            if ~isempty(ODLeftV)&~isempty(ODRightV)&~isempty(ODLeftH)&~isempty(ODRightH),
                ODpos = eval(['[' ODLeftV ' ' ODLeftH ';' ODRightV ' ' ODRightH '];']); 
                assoc(end+1) = struct('type','Optic disk position','owner','eyemonitorpossheetlet','data',ODpos, ...
                        'desc','');
            end;
            eyestr = get(findobj(fig,'tag',[typeName 'eyePopup']),'string');
            hemistr = get(findobj(fig,'tag',[typeName 'HemiPopup']),'string');                    
            assoc(end+1)=struct('type','OD index','owner','eyemonitorpossheetlet','data',eyestr{eyeValue},'desc','');
            assoc(end+1)=struct('type','Hemisphere','owner','eyemonitorpossheetlet','data',hemistr{hemiValue},'desc','');
            
            if nargout>0, varargout{1} = assoc; end;
        else,
            warning('Warning: eyemonitorposition sheetlet was not checked.');
            if nargout>0, varargout{1} = []; end;
        end;  
end;