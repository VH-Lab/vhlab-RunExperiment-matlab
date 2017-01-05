function [number] = GetNextSheetletNumber(name)

% GETNEXTSHEETLETNUMBER
%
%  [NUMBER] = GETNEXTSHEETLETNUMBER(NAME)
%
%  Finds the next unique number for the sheetlet with name
%  NAME.
%
%  Example: [NUMBER] = GETNEXTSHEETLETNUMBER('Test')
%
%    might yield NUMBER = 1 if there are no other sheetlets
%    named 'Test'.
%


number = 1;

while ~isempty((findobj('Tag',[name '_' sprintf('%.4d',number) '_base']))), number = number + 1; end;
