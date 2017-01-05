function [ns,mti,bs,bmti] = removeblankstim(thescript,themti)

%  REMOVEBLANKSTIM - Removes a blank stim from a stimscript, mti record
%
%  [NEWSCRIPT,NEWMTI,BLANKSCRIPT,BLANKMTI] = REMOVEBLANKSTIM( ...
%    THESCRIPT, THEMTI)
%
%  Removes a blank stimulus from a stimscript and mti timing record.
%

elem = [];
for i=1:numStims(thescript),
	if ~isfield(getparameters(get(thescript,i)),'isblank'),
		elem(end+1) = i;
	end;
end;

[ns,bs,mti,bmti] = decomposescriptmti(thescript,themti,elem);
