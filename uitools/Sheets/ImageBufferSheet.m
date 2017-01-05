function ImageBufferSheet(command, fig)

if nargin==0
    command='init';
end

if ishandle(command)
    fig=gcbf;
    command=get(command, 'tag');
    userdata = get(fig,'userdata');
end

switch command
    case 'init'
        fig=drawsheet; 
        ImageBufferSheet ('default', fig);
    case 'default'
        z = geteditor('RunExperiment');
        ud = get(z,'userdata');
        if ~isa(ud.ds,'dirstruct'),
            errordlg('No data in RunExperiment window -- hit return after data directory.');
            error('No data in RunExperiment window -- hit return after data directory.');
        else, usstruct.ds = dirstruct(getpathname(ud.ds));
        end;
        set(fig,'userdata',usstruct);

        referencesheetlet_process(fig, 'ref', usstruct.ds, ['ref' 'ChooseNameRef']);
        
        eyemonitorpossheetlet_process(fig, 'eye', usstruct.ds, 'eyeGrabFromScreentool');
        
        
	ib = imagebufferstim('default');
	%p.filename = 'C:\remote\quicktime\matrix_lighter.mov';
	%p.rect = [ 0 0 800 600];
	imagebuffersheetlet_process(fig,'IB',usstruct.ds,'IBSetVars','',ib,0,'ref');
	imagebuffersheetlet_process(fig,'IB2',usstruct.ds,'IB2SetVars','',ib,0,'ref');



    otherwise
        disp(['unknown command ' command])
end
    





function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    93   829   905]);
set(gcf, 'tag', 'ImageBufferSheet');
top=880;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = reversecorrelationsheetlet('Reverse Correlation', 'ReverseCorr', [5 newpos]);

newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = imagebuffersheetlet('ImageBuffer','IB',[5 newpos]);

newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = imagebuffersheetlet('ImageBuffer','IB2',[5 newpos]);

newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
