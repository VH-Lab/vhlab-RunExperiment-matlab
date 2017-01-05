function thescript = RunScriptModifiers(commandstr,thescript)

% RUNSCRIPTMODIFIERS
%
%   Runs all ScriptModifiers in the ExternalCommand list

global FitzScriptmodifier_dirname FitzExperFileName FitzInstructionFileName;


z = geteditor('RunExperiment');
if isempty(z),
    error(['Could not find RunExperiment window; could not perform RunScriptModifiers.']);
end;

ecd = get(findobj(z,'tag','extdevcb'),'value');
ecdlist = get(findobj(z,'tag','extdevlist'),'string');

if ecd,
    for i=1:length(ecdlist),
        openpars = find(ecdlist{i}=='('); closepars = find(ecdlist{i}==')');
        if isempty(openpars), openpars = length(ecdlist{i})+1; end;
        eval(['typ=' ecdlist{i}(1:openpars(1)-1) ';']);
        if strcmp(typ,'scriptmodifier'),
            disp(['Running the scriptmodifier ' ecdlist{i} ' with command ' commandstr '.']);
            if closepars - openpars == 1 | all(' '==ecdlist{i}(openpars+1:closepars-1)),
                estring = '';
            else, estring = ',';
            end;
            ['thescript = ' ecdlist{i}(1:closepars(1)-1) estring  '''' commandstr ''',thescript,FitzScriptmodifier_dirname);'],
            eval(['thescript = ' ecdlist{i}(1:closepars(1)-1) estring  '''' commandstr ''',thescript,FitzScriptmodifier_dirname);']); 
        end;
    end;
end;