function MarjenaSheet(command, fig)

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
	set(fig,'name','Pallas Sheet');
        MarjenaSheet ('default', fig);
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

	% default grating
        ps=periodicscript('default');
        p=getparameters(ps);
        p.angle=0;
	p.distance = 30;
        p.sFrequency=0.08;
        p.tFrequency = 4;
        p.nCycles=p.tFrequency*2;
        p.rect=[0 0 300 300];
        p.contrast = 1;
        p.flickerType = 0;
	p.animType = 4;
	p.imageType = 2;
	p.windowShape = 3;
        ps=periodicscript(p);

        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:22.5:360-22.5]','angle','','GratCtrl',0,0,'ref');
        lengthwidthcontrastaperturesheetlet_process(fig,'LengthWidthCA',usstruct.ds,'LengthWidthCASetVars','','[20 40 80 140 220 320 440 560]','[-1]','[1]','GratCtrl',0,'ref');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.15 0.2 0.3 0.5 0.8]','sFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'TempFreq',usstruct.ds,'TempFreqSetVars','','[0.5 1 2 4 8 16 32]','tFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'Contrast',usstruct.ds,'ContrastSetVars','','[0.02 0.04 0.08 0.16 0.32 0.64 1]','contrast','','GratCtrl',0,0,'ref');

        bs1 = blinkingstim('default');
        p=getparameters(bs1);
        p.BG = [0 0 0];
	p.random = 1;
	p.bgpause = 0;
	p.fps = 10;
	p.pixSize = [40 40];
	p.rect = [0 0 800 600];
	p.repeat = 30;
        p.value = [0 0 0]+255;
        bs1 = blinkingstim(p);
	p.BG = [255 255 255];
	p.value = [0 0 0];
        bs2 = blinkingstim(p);

        reversecorrelationsheetlet_process(fig, 'ReverseCorr', usstruct.ds, 'ReverseCorrSetVars',bs1,[],bs2,[],[100 20 15],[],[],[],0,'ref');

    otherwise
        disp(['unknown command ' command])
end
 


function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    40   829   737]);
set(gcf, 'tag', 'PallasSheet');
top=700;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = reversecorrelationsheetlet('Reverse Correlation', 'ReverseCorr', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Direction', 'CoarseDir', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = lengthwidthcontrastaperturesheetlet('LengthWidthCA', 'LengthWidthCA', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Frequency', 'SpatFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Temporal Frequency', 'TempFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Contrast', 'Contrast', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;



[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);
newpos = newpos-lengthwidth(2)-5;


