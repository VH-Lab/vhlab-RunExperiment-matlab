function S = AddControlVar(S_in, name, tag, field, defaultvalue)

% ADDCONTROLVAR - Add a control variable to a sheetlet object
%
%   S = ADDCONTROLVAR(S_IN, NAME, TAG, FIELD, DEFAULTVALULE)
%
%  Adds a variable that is linked to the field FIELD of the uicontrol with
%  the tag TAG.
%
%  See also: SHEETLET

S = S_in;

newstruct = struct('name',name,'tag',tag,'field',field,'defaultvalue',defaultvalue);

if isempty(S.params.controlvarlist),
	S.params.controlvarlist = newstruct;
else,
	foundit = 0;
	% make sure it's not already there, and overwrite if need be
	for i=1:length(S.params.controlvarlist),
		if strcmp(S.params.controlvarlist(i),name),
			S.params.controlvarlist(i) = newstruct;
			foundit = 1;
			break;
		end;
	end;
	if ~foundit, S.params.controlvarlist(end+1) = newstruct; end;
end;

SaveParameters(S);
