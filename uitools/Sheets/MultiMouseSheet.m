function MultiMouseSheet(command, fig)

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
        MultiMouseSheet ('default', fig);
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
        p.sFrequency=0.05;
        p.nCycles=3;
        p.tFrequency = 2;
        p.rect=[0 0 800 600];
        p.contrast = 1;
        p.distance = 25;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,6,1.5,1,1);
        doublegratingsheetlet_process(fig,'dirspat',usstruct.ds,'dirspatSetVars','','[0:30:360-30]','angle','[.01 .02 .04 .08 .16 .32]','sFrequency','GratCtrl',0,'ref');
        doublegratingsheetlet_process(fig,'dirtemp',usstruct.ds,'dirtempSetVars','','[0:30:360-30]','angle','[1 2 4 8 16]','tFrequency','GratCtrl',0,'ref');
        doublegratingsheetlet_process(fig,'dircontr',usstruct.ds,'dircontrSetVars','','[0:30:360-30]','angle','[0.16 0.33 0.5 0.67 0.83 1]','contrast','GratCtrl',0,'ref');
    otherwise
        disp(['unknown command ' command])
end
    





function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    93   829   905]);
set(gcf, 'tag', 'MultiMouseSheet');
top=880;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = doublegratingsheetlet({'Direction','Spatial Frequency'},'dirspat',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = doublegratingsheetlet({'Direction','Temporal Frequency'},'dirtemp',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = doublegratingsheetlet({'Direction','Contrast'},'dircontr',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
