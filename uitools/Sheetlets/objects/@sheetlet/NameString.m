function ns = NameString(S)

% NAMESTRING - Returns the name string of a sheetlet object
%
%   NS = NAMESTRING(S)
%
%  Returns in NS the name string of the SHEETLET object S.

P = GetParameters(S);

ns = P.name_string;
