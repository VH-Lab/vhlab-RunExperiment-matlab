function [list,channelgrouping,filtermap] = getrunexperimentacquisitionlist(full)
% GETRUNEXPERIMENTACQUISITIONLIST - Return the acquisition list from the RunExperiment window
%
%    LIST = GETRUNEXPERIMENTACQUISITIONLIST
%         or
%    LIST = GETRUNEXPERIMENTACQUISITIONLIST(1)
%         or
%    [LIST,CHANNELGROUPING,FILTERMAP] = GETRUNEXPERIMENTACQUISITIONLIST
%
%    Gets the structure of the items comprising the Acquisition List in RunExperiment.
%    
%    If the argument FULL is provided and is 1 (as opposed to 0), then the full list
%    is provided. Otherwise, the fields are limited to name, ref, and type.
%
%    If the outputs CHANNELGROUPING and FILTERMAP are provided, then the structures
%    for CHANNELGROUPING and FILTERMAP are also copied from the RunExperiment window.
%    
%    

list = [];

z = geteditor('RunExperiment');

if isempty(z),
	error(['No RunExperiment window found.']);
elseif length(z)>1,
	error(['More than 1 RunExperiment window found. Only 1 should be open.']);
else,
	list_aq = getfield(get(z,'userdata'),'list_aq');
	list = get(list_aq,'userdata');
end;

usefull = 0;
if nargin>0,
	usefull = full;
end;

if ~usefull,
	fieldstoremove = setdiff(fieldnames(list),{'name','ref','type'});
	for i=1:length(fieldstoremove),
		list = rmfield(list,fieldstoremove{i});
	end;
	list = orderfields(list,{'name','ref','type'});
end;

if nargout>1,
	channelgrouping = get(findobj(z,'tag','vhlv_channelgroupingList'),'UserData'); 
end;

if nargout>2,
	filtermap = get(findobj(z,'tag','vhlv_filtermapList'),'UserData'); 
end;

