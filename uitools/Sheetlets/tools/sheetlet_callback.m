function sheetlet_callback(sheetlet_command, typeName, varargin)

h1 = gcbf;
userdata = get(h1,'userdata');
t = get(h1,'Tag');
eval([sheetlet_command '(h1, ''' typeName ''', userdata.ds, get(gcbo,''tag''),varargin{:});']);
