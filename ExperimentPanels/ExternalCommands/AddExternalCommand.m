function b = AddExternalCommand(commandstr, pos, rstr)

% ADDEXTERNALCOMMAND - Add a command to the RunExperiment window
%
%  B = ADDEXTERNALCOMMAND(COMMANDSTR, POSITION, [REPLACESTR])
%
%  This function adds an external command to the RunExperiment window.
%  COMMANDSTR is a string with the command that is to be added.
%  If POSITION is 0, then the new command is placed at the beginning of the
%  list (so it will be run first).  If POSITION is 1, then it is placed at
%  the end of the list (so it will be run last).
%  If REPLACESTR is given and is not empty, then, any current external commands
%  that have any part of the string REPLACESTR will be replaced. (For example,
%  if your COMMANDSTR is a command with paranthesis and arguments, you could
%  set REPLACESTR to be the command, and any instances would be deleted before
%  COMMANDSTR is added.)

b = 1;

if nargin<3, replacestr = []; else, replacestr = rstr; end;

if ~isempty(replacestr),
	[b,i] = RemoveExternalCommand(replacestr);
end;

if b, % now just add to the list
	z = geteditor('RunExperiment');
	if isempty(z), b = 0; return; end; % can't do it if there's no editor
	ecdlist = get(findobj(z,'tag','extdevlist'),'string');
	if pos==1, ecdlist = cat(1,ecdlist,commandstr); else, ecdlist = cat(1,commandstr,ecdlist); end;
	set(findobj(z,'tag','extdevlist'),'string',ecdlist,'value',1);
end;

% make separate function for flipping switch on and off
