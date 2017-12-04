function FerretDirectionSheet(command, fig)

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
        FerretDirectionSheet ('default', fig);
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
        p.sFrequency=0.08;
        p.nCycles=8;
        p.tFrequency = 4;
        p.rect=[0 0 1000 1000];
        p.contrast = 0.7;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,5,3,1,1);
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:30:360-30]','angle','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.2 0.5 0.8 1 1.3 ]','sFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'TempFreq',usstruct.ds,'TempFreqSetVars','','[0.5 1 2 4 6 8 12 16 20 25 30]','tFrequency','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'Contrast',usstruct.ds,'ContrastSetVars','','[0:0.1:1]','contrast','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'SpatPhase',usstruct.ds,'SpatPhaseSetVars','','[[0:pi/6:pi-pi/6] 2*pi+[0:pi/6:pi-pi/6]]','sPhaseShift','','GratCtrl',0,0,'ref');
	barvelocitysheetlet_process(fig,'BarVel',usstruct.ds,'BarVelSetVars','','logspace(2,0,10)','0.5','','GratCtrl',0,0,'ref');
	%lineweightsheetlet_process(fig,'Line',usstruct.ds,'LineSetVars','','[-98:3.5:98]*2','[800 7 0.1]','','GratCtrl',0,0,'ref');
        %lengthwidthsheetlet_process(fig,'LengthWidth',usstruct.ds,'LengthWidthSetVars','','[50:50:450]','[300]','','GratCtrl',0,0,'ref');
        rcgratingsheetlet_process(fig,'RCG',usstruct.ds,'RCGSetVars','','[0:22.5:180-22.5]','orientations','[0.025 0.05 0.1 0.2 0.4 0.8]', 'spatialfrequencies', ...
                    '[0:pi/4:2*pi-pi/4]','spatialphases','[0.2 50 1]','GratCtrl',0,'ref');
        bs1 = blinkingstim('default');
        p=getparameters(bs1);
        p.BG = 128+[0 0 0]; p.random = 1; p.bgpause = 0; p.fps = 10; p.pixSize = [40 40]; p.rect = [0 0 400 400]; p.repeat = 30;
        bs1 = blinkingstim(p);
        p.value = [0 0 0];
        bs2 = blinkingstim(p);
        
        sgs1 = stochasticgridstim('default');
        sgs2 = stochasticgridstim('default');

        reversecorrelationsheetlet_process(fig, 'ReverseCorr', usstruct.ds, 'ReverseCorrSetVars',sgs1,[],bs2,[],[100 20 15],[],[],[],1,'ref');
	
	p = getparameters(quicktimestim('default'));
	p.filename = 'C:\remote\quicktime\matrix_lighter.mov';
    p.rect = [ 0 0 800 600];
	qtbasestim = quicktimestim(p);
	quicktimesheetlet_process(fig,'QT',usstruct.ds,'QTSetVars','',qtbasestim,0,'ref');

	%ib = imagebufferstim('default');
	%p.filename = 'C:\remote\quicktime\matrix_lighter.mov';
	%p.rect = [ 0 0 800 600];
	%imagebuffersheetlet_process(fig,'IB',usstruct.ds,'IBSetVars','',ib,0,'ref');

    otherwise
        disp(['unknown command ' command])
end
    





function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    93   829   905]);
set(gcf, 'tag', 'FerretDirectionSheet');
top=880;
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

[hlist,lengthwidth] = gratingsheetlet('Temporal Frequency', 'TempFreq', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Contrast', 'Contrast', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

%[hlist,lengthwidth] = Lineweightsheetlet('Line Weight', 'Line', [5 newpos]);
[hlist,lengthwidth] = barvelocitysheetlet('Bar velocity', 'BarVel', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = lengthwidthsheetlet('Length/Width', 'LengthWidth', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = gratingsheetlet('Spatial Phase', 'SpatPhase', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = reversecorrelationsheetlet('Reverse Correlation', 'ReverseCorr', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = quicktimesheetlet('QuickTime','QT',[5 newpos]);
newpos = newpos - lengthwidth(2)-15;

%[hlist,lengthwidth] = imagebuffersheetlet('ImageBuffer','IB',[5 newpos]);
%newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = rcgratingsheetlet({'Ori','SFreq','Phase'},'RCG',[5 newpos]);
newpos = newpos - lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
