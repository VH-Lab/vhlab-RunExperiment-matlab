function vars = GetVarValues(S)

% GETVARVALUES - Return variables values from a sheetlet object
%
%   VALUES = GETVARVALUES(S)
%
%   Returns the variable values associated with a sheetlet S
%
%  See also: GETCONTROLVARS

vars = struct([]);

v = GetControlVar(S);

for i=1:length(v),
	ctl = findobj('Tag',v(i).tag);
	if ~isempty(ctl),
		if isempty(vars),
			vars = setfield([],v(i).name,get(ctl,v(i).field));
		else,
			vars = setfield(vars,v(i).name,get(ctl,v(i).field));
		end;
	else,
		error(['Could not find control with tag ' v(i).tag '.']);
	end;
end;

subs = GetSubSheetlet(S);

for i=1:length(subs),
	eval(['mysubsheetvars = GetVars(' subs(i).type '(subs(i).name));']);
	if isempty(vars),
		vars = setfield([],subs(i).name,mysubsheetvars);
	else,
		vars = setfield(vars,subs(i).name,mysubsheetvars);
	end;
end;

  % vars

 %  myvars
 %	var1
 %	var2
 % 	var3
 % 	sheetlet_1_name
 % 		var1
 %		var2
 %	sheetlet_2
