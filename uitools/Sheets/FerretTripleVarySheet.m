function FerretTripleVarySheet(command, fig)

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
        FerretTripleVarySheet ('default', fig);
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
        
        ps=periodicscript('default');
        p=getparameters(ps);
        p.angle=0;
        p.sFrequency=0.1;
        p.tFrequency=4;
        p.nCycles=8; % 2 seconds
        p.rect=[0 0 800 600];
        p.contrast = 1;
        p.distance = 25;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,6,1.5,1,1);
        triplegratingsheetlet_process(fig,'dirspatcont',usstruct.ds,'dirspatcontSetVars','','[0:30:360-30]','angle','[.01 .02 .04 .08 .16 .32]','sFrequency','[0.1:0.1:1]','contrast','GratCtrl',0,'ref');
        triplegratingsheetlet_process(fig,'dirtempcont',usstruct.ds,'dirtempcontSetVars','','[0:30:360-30]','angle','[1 2 4 8 16]','tFrequency','[0.1:0.1:1]','contrast','GratCtrl',0,'ref');
    otherwise
        disp(['unknown command ' command])
end
     





function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    93   829   905]);
set(gcf, 'tag', 'FerretTripleVarySheet');
top=880;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = triplegratingsheetlet({'Direction','Spatial Frequency','Contrast'},'dirspatcont',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = triplegratingsheetlet({'Direction','Temporal Frequency','Contrast'},'dirtempcont',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
