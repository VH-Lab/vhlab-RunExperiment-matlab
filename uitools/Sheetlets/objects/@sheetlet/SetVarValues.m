function SetVarValues(S, varargin)

% SETVARVALUES - Set variable values of a sheetlet object
%
%   SETVARVALUES(S, varstruct)
%
%   or
%
%   SETVARVALUES(S,'DEFAULT') will set default parameters
%
%   or
%
%   SETVARVALUES(S,'varname1','value1',...) will allow setting 
%      of variables with name/value pairs
%
%   Sets the variables associated with a sheetlet S
%
%   Each field of the varstruct corresponds to a variable name; if a variable
%   name is not present, then no action is taken on that variable.
%
%   Use GetControlVar for a list of available variable names.

if nargin==1, % has to be a structure
	varstruct = varargin{1};
else,
	varstruct = setfield([],varargin{1},varargin{2});
	for j=3:length(varargin),
		varstruct = setfield(varstruct,varargin{j},varargin{j+1});
	end;

end;

cv = GetControlVar(S);

if ischar(varstruct),
	if strcmp(varstruct,'default'),
		for i=1:length(cv),
			varstruct = setfield(varstruct,cv(i).name,cv(i).defaultvalue);
		end;
	end;
end;

if isstruct(varstruct), 
	fn = fieldnames(varstruct);
else, return;
end;

if ~isempty(cv), varnames = {cv.name};  else, varnames = {}; end;


subsheetlets = GetSubSheetlet(S);

if ~isempty(subsheetlets), subnames = {subsheetlets.name}; else, subnames = {}; end;

for j=1:length(fn),
	[C,AI,IB] = intersect(fn{j}, varnames);
	[C2,AI2,IB2] = intersect(fn{j}, subnames);
	if ~isempty(C),
		obj = findobj('Tag',cv(IB).tag);
		if ~isempty(obj),
			set(obj,cv(IB).field,getfield(varstruct,fn{j}));
		else,
			error(['Could not find object with tag ' cv(IB).tag '.']);
		end;
		% set the variable here
	elseif ~isempty(C2), % this is only here in the sheetlet class, not needed in others
		SetVarValues(sheetlet(subnames(IB2)),varstruct(j));
	else, % nothing to do
	end;
end;

SaveParameters(S);
