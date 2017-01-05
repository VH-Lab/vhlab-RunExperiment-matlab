function [b, currentvalue] = ToggleExternalCommand(value)

% TOGGLEEXTERNALCOMMAND - Set/Read the ExternalCommand ON/OFF status
%
%  [B,CURRENTVALUE] = TOGGLEEXTERNALCOMMAND(VALUE)
%
%  VALUE indicates the value to set the ExternalCommand checkbox.  
%     -1 means set it to off, 1 means set it to on, 0 means do nothing.
%  B is 1 if the ExternalCommand checkbox was successfully found and set.
%  CURRENTVALUE is the value (0/1) of the check box after any modifications
%      by TOGGLEEXTERNALCOMMAND (or the previous value if VALUE was set to 0).

b = 0; currentvalue = [];

z=geteditor('RunExperiment');
if ~isempty(z),
	myobj = findobj(z,'tag','extdevcb');
	if ~isempty(myobj),
		b=1;
		if value~=0,
			set(myobj,'value',(value+1)/2);
		end;
		currentvalue = get(myobj,'value');
	end;
end;

