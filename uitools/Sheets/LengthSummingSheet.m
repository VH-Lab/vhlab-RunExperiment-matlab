function LengthSummingSheet(command, fig)

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
	set(fig,'name','Length Summing');
        LengthSummingSheet ('default', fig);
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
        p.sFrequency=0.1;
        p.tFrequency = 4;
        p.nCycles=p.tFrequency*2;
        p.rect=[0 0 200 200];
        p.contrast = 0.7;
        p.flickerType = 0;
	p.animType = 4;
	p.imageType = 2;
	p.windowShape = 3;
        ps=periodicscript(p);

	% default modulating grating
        psm=periodicscript('default');
        pm=getparameters(psm);
        pm.angle=0;
        pm.sFrequency=0.05;
        pm.tFrequency = 1;
        pm.nCycles=pm.tFrequency*2;
        pm.rect=[0 0 800 600];
        pm.contrast = 1.;
        pm.flickerType = 0;
	pm.animType = 4;
	pm.imageType = 2;
        psm=periodicscript(pm);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:22.5:360-22.5]','angle','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.15 0.2 0.3 0.5 0.8]','sFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'TempFreq',usstruct.ds,'TempFreqSetVars','','[0.5 1 2 4 6 8 12 16 20 25 30]','tFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'Contrast',usstruct.ds,'ContrastSetVars','','[0.02 0.04 0.08 0.16 0.32 0.64 1]','contrast','','GratCtrl',0,0,'ref');
        contrastplaidsheetlet_process(fig,'ContrastPlaid',usstruct.ds,'ContrastPlaidSetVars','','[0.02 0.04 0.08 0.16 0.32 0.64 1]','contrast','','GratCtrl',0,0,'ref');
        lengthwidthcontrastsheetlet_process(fig,'LengthWidthC',usstruct.ds,'LengthWidthCSetVars','','[20:20:600]','[-1]','[1]','GratCtrl',0,'ref');
        longpositiontuningsheetlet_process(fig,'LongPosC',usstruct.ds,'LongPosCSetVars','','[-150:15:150]','[300 300 1]','','GratCtrl',0,0,'ref');
        gratingcontrolsheetlet_process(fig,'ModGratCtrl',usstruct.ds,'ModGratCtrlSetVars',psm,5,3,1,1);
        modulatinggratingsheetlet_process(fig,'ModCoarseDir',usstruct.ds,'ModCoarseDirSetVars','','[0:22.5:180-22.5]','angle','','GratCtrl',1, 'ModGratCtrl',0,0,'ref');
        modulatinggratingsheetlet_process(fig,'ModSpatFreq',usstruct.ds,'ModSpatFreqSetVars','','[0.01 0.025 0.05 0.1 0.2]','sFrequency','','GratCtrl',1, 'ModGratCtrl',0,0,'ref');
        modulatinggratingsheetlet_process(fig,'CarrierContrast',usstruct.ds,'CarrierContrastSetVars','','[0.01 0.04 0.08 0.16 0.32 0.64 0.8 1]','contrast','','GratCtrl',0,'ModGratCtrl',0,0,'ref');
        modulatingdoublegratingsheetlet_process(fig,'ModSFCarrierContrast',usstruct.ds,'ModSFCarrierContrastSetVars','','[0.01 0.015 0.02 0.03 0.04 0.05 0.075 0.1]','sFrequency',1,...
				'[0.04 0.08 0.16 0.64]','contrast',0,'GratCtrl','ModGratCtrl',0,'ref');

    otherwise
        disp(['unknown command ' command])
end
 




function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    40   829   955]);
set(gcf, 'tag', 'LengthSummingSheet');
top=900;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Direction', 'CoarseDir', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Frequency', 'SpatFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Temporal Frequency', 'TempFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Contrast', 'Contrast', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist, lengthwidth] = contrastplaidsheetlet('ContrastPlaid','ContrastPlaid', [ 5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = lengthwidthcontrastsheetlet('LengthWidthC', 'LengthWidthC', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = longpositiontuningsheetlet('LongPosHigh', 'LongPosC', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('ModGratCtrl',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = modulatinggratingsheetlet('Mod Orientation', 'ModCoarseDir', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = modulatinggratingsheetlet('Mod Spatial Frequency', 'ModSpatFreq', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = modulatinggratingsheetlet('Car. Contrast', 'CarrierContrast', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = modulatingdoublegratingsheetlet({'Mod SF x','Car. Contrast'}, 'ModSFCarrierContrast', [5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);
newpos = newpos-lengthwidth(2)-5;
