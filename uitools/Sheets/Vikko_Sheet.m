function Vikko_Sheet(command, fig)

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
        Vikko_Sheet ('default', fig);
    case 'default'
        z = geteditor('RunExperiment');
        ud = get(z,'userdata');
        if ~isa(ud.ds,'dirstruct')
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
        p.sFrequency=0.2;
        p.tFrequency = 4;
        p.nCycles=8;
        p.rect=[0 0 800 600];
        p.contrast = 1;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        
        %adding in triple vary information for Direction, TF, and SF
        triplegratingsheetlet_process(fig,'dirsftf',usstruct.ds,'dirsftfSetVars','','[0:45:180-45]','angle','[0.04 0.08 0.16 0.24 0.32 0.64 0.90 1.25]','sFrequency','[0.5 1 2 4 8 16 32]','tFrequency','GratCtrl',0,'ref');
        
	h1 = hartleystim('default');
	p = getparameters(h1);
	p.rect = [ 0 0 800 800];
	p.windowShape = 0;
	p.distance = 30;
	p.M = 200;
	p.sfmax = 5;
	p.reps = 10;
	p.fps = 10;
	h1 = hartleystim(p);

        bs2 = blinkingstim('default');
        p=getparameters(bs2);
        p.value = [0 0 0];
        p.BG = [0 0 0]; p.random = 1; p.bgpause = 1; p.fps = 2; p.pixSize = [800 600]; p.rect = [0 0 800 600]; p.repeat = 30;
        bs2 = blinkingstim(p);

        hartleysheetlet_process(fig, 'ReverseCorr', usstruct.ds, 'ReverseCorrSetVars',h1,[],bs2,[],[20 15],[],[],[],1,'ref');
    otherwise
        disp(['unknown command ' command])
end
    



function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    40   829   555]);
set(gcf, 'tag', 'Vikko_Sheet');
top=500;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = hartleysheetlet('Hartley', 'ReverseCorr', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

newpos = newpos-lengthwidth(2)-5;

%Adding in triple vary sheetlet for Direction, SF, and TF)
[hlist,lengthwidth] = triplegratingsheetlet({'Direction','Spatial Frequency','Temporal Frequency'},'dirsftf',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;
