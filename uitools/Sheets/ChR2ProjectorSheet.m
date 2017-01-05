function ChR2ProjectorSheet(command, fig)

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
        ChR2ProjectorSheet ('default', fig);
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
        p.sFrequency=0.2;
        p.nCycles=8;
        p.tFrequency = 4;
        p.rect=[0 0 800 600];
        p.contrast = 1;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
	p.chromhigh = [0 0 255];
	p.chromlow = [ 0 0 0];
	p.backdrop = [ 0 0 0 ];
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:30:360-30]','angle','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.2 0.5]','sFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatPhase',usstruct.ds,'SpatPhaseSetVars','','[0:pi/6:pi-pi/6]','sPhaseShift','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'Brightness',usstruct.ds,'BrightnessSetVars','','0:0.2:1','brightness','','GratCtrl',0,0,'ref');
        cpositionsheetlet_process(fig,'Position',usstruct.ds,'PositionSetVars','','200','200','50','','GratCtrl',0,0,'ref');
        lineweightsheetlet_process(fig,'Line',usstruct.ds,'LineSetVars','','[-200:5:200]','[800 10 0.1]','','GratCtrl',0,0,'ref');

        bs1 = blinkingstim('default');
        p=getparameters(bs1);
        p.BG = [0 0 0]; p.random = 0; p.bgpause = 1; p.fps = 10; p.pixSize = [400 400]; p.rect = [0 0 400 400]; p.repeat = 10; p.value = [ 0 0 255];
        bs1 = blinkingstim(p);
        p.BG = [0 0 0]; p.random = 0; p.bgpause = 1; p.fps = 10; p.pixSize = [40 40]; p.rect = [0 0 400 400]; p.repeat = 20;
        bs2 = blinkingstim(p);
        
        sgs1 = stochasticgridstim('default');
        sgs2 = stochasticgridstim('default');

	fis = flashimageseqstim('default');
	p = getparameters(fis);
	p.dirname = '/Users/vhlab/tools/vhtools/VH_matlab_code/NewStim/Stimuli/default_files/flashimageseqstim_images';
	fis = flashimageseqstim(p);
        reversecorrelationsheetlet_process(fig, 'ReverseCorr', usstruct.ds, 'ReverseCorrSetVars',bs1,[],bs2,[],[100 20 15],[],[],[],0,'ref');
        flashingimageseqsheetlet_process(fig, 'FlashImage1', usstruct.ds, 'FlashImage1SetVars',fis,[],fis,[],[15 10],[],[],[],1,'ref');
        blinkingstimscriptsheetlet_process(fig, 'BLS2', usstruct.ds, 'BLS2SetVars',bs1,[],bs2,[],[0.020 0.040 0.1 0.2],[0.020 0.040 0.1 0.2],[5 1 10],0,0,'ref');

    otherwise
        disp(['unknown command ' command])
end
    





function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    40   829   955]);
set(gcf, 'tag', 'ChR2ProjectorSheet');
top=940;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Coarse Direction', 'CoarseDir', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Frequency', 'SpatFreq', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = Lineweightsheetlet('Line Weight', 'Line', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Phase', 'SpatPhase', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Brightness', 'Brightness', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = cpositionsheetlet('Position', 'Position', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = reversecorrelationsheetlet('Reverse Correlation', 'ReverseCorr', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = flashingimageseqsheetlet('Flashing Image Seq','FlashImage1',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = blinkingstimscriptsheetlet('BlinkingStimScript','BLS2',[5 newpos]);
newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
