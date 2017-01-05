function BrainSurfaceImagingSheet(command, fig)

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
        BrainSurfaceImagingSheet ('default', fig);
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
        p.nCycles=20;
        p.tFrequency = 4;
        p.rect=[0 0 200 200];
        p.contrast = 1.0;
        p.flickerType = 0; p.animType = 4; p.imageType = 2;
        p.loops = 0;
        ps=periodicscript(p);
        
        gratingcontrolsheetlet_process(fig,'GratCtrl',usstruct.ds,'GratCtrlSetVars',ps,20,5,1,1);
        brainsurfaceanalysissheetlet_process(fig,'BSIAnalyze',usstruct.ds,'BSIAnalyzeSetVars','1','1','[3:10]','1000',1,'100','5',1);        
        gratingsheetlet_process(fig,'CoarseDir',usstruct.ds,'CoarseDirSetVars','','[0:22.5:180-22.5]','angle','','GratCtrl',0,0,'ref','BSIAnalyze');
        gratingsheetlet_process(fig,'SpatFreq',usstruct.ds,'SpatFreqSetVars','','[0.05 0.1 0.2 0.5 0.8 1 1.3 1.6]','sFrequency','','GratCtrl',0,0,'ref','BSIAnalyze');
        gratingsheetlet_process(fig,'TempFreq',usstruct.ds,'TempFreqSetVars','','[0.5 1 2 4 6 8 12 16 20 25 30]','tFrequency','','GratCtrl',0,0,'ref','BSIAnalyze');
        gratingsheetlet_process(fig,'Contrast',usstruct.ds,'ContrastSetVars','','[0:0.1:1]','contrast','','GratCtrl',0,0,'ref','BSIAnalyze');
        %bsigratingsheetlet_process(fig,'SpatPhase',usstruct.ds,'SpatPhaseSetVars','','[0:pi/6:pi-pi/6]','sPhaseShift','','GratCtrl',0,0,'ref');
        gratingsheetlet_process(fig,'FineDir',usstruct.ds,'FineDirSetVars','','[0:22.5:360-22.5]','angle','','GratCtrl',0,0,'ref','BSIAnalyze');
        %positionsheetlet_process(fig, 'Pos', usstruct.ds, 'PosSetVars', '','200','200','50','','GratCtrl',0,0,'ref','BSIAnalyze')
        %lineweightsheetlet_process(fig,'Line',usstruct.ds,'LineSetVars','','[-98:3.5:98]*2','[800 7 0.1]','','GratCtrl',0,0,'ref','BSIAnalyze');
        %lengthwidthsheetlet_process(fig,'LengthWidth',usstruct.ds,'LengthWidthSetVars','','[50:50:450]','[200]','GratCtrl',0,'ref','BSIAnalyze');
        %aperaturesheetlet_process(fig,'Aperature',usstruct.ds,'AperatureSetVars','','[50:50:450]','[200]','GratCtrl',0,'ref','BSIAnalyze');
        retinotopysheetlet_process(fig,'retinotopy',usstruct.ds,'retinotopySetVars','','[100 50 400 100 1]','GratCtrl',0,'ref','BSIAnalyze');
        stimtrainsheetlet_process(fig,'stimtrain',usstruct.ds,'stimtrainSetVars','[2 0.001 1]',0,'ref','BSIAnalyze');
        %daceyrevcorrsheetlet_process(fig,'dacey',usstruct.ds,'daceySetVars','','GratCtrl',0,'ref');
        %disparitysheetlet_process(fig, 'disparity', usstruct.ds, 'disparitySetVars','','[-20:4:20]',0,'ref','GratCtrl');
        %brieforisheetlet_process(fig,'briefori',usstruct.ds,'brieforiSetVars','','GratCtrl',0,'ref');
        %barorisheetlet_process(fig,'barori',usstruct.ds,'baroriSetVars','0:22.5:180-22.5','',0,'ref','BSIAnalyze');
        %frequencyresponsesheetlet_process(fig,'freqresp',usstruct.ds,'freqrespSetVars','','[0 5 15 25 35 55 75]','[5e-3 2 5 5]',0,'ref','BSIAnalyze');

        bs1 = blinkingstim('default');
        p=getparameters(bs1);
        p.BG = 128+[0 0 0]; p.random = 1; p.bgpause = 0; p.fps = 10; p.pixSize = [40 40]; p.rect = [0 0 400 400]; p.repeat = 30;
        bs1 = blinkingstim(p);
        p.value = [0 0 0];
        bs2 = blinkingstim(p);

        %reversecorrelationsheetlet_process(fig, 'ReverseCorr', usstruct.ds, 'ReverseCorrSetVars',bs1,[],bs2,[],[],[],[],[],[],'ref');
    otherwise
        disp(['unknown command ' command])
end
    





function fig=drawsheet
fig=figure;

set(gcf, 'position', [96    93   829   905]);
set(gcf, 'tag', 'BrainSurfaceImagingSheet');
top=880;
newpos=top;

[hlist,lengthwidth] = referencesheetlet('Reference', 'ref',[5 newpos]);

hlisthide = {'namereftxt','UpdateBt','cellstxt','cellList','DBBt','filenametxt','filenameEdit'};

for i=1:length(hlisthide),
    set(findobj(gcf,'Tag',['ref' hlisthide{i}]),'visible','off');
end;

newpos = newpos-lengthwidth(2)-15+70;

[hlist,lengthwidth] = eyemonitorpossheetlet('eye',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = brainsurfaceanalysissheetlet('BSIAnalyze',[5 newpos]);
newpos = newpos-lengthwidth(2) - 5;

%[hlist,lengthwidth] = stimtrainsheetlet('ChR2 train','stimtrain',[5 newpos]);

%newpos = newpos-lengthwidth(2) - 5;

% [hlist,lengthwidth] = frequencyresponsesheetlet('Freq response','freqresp',[5 newpos]);
% 
% newpos = newpos-lengthwidth(2) - 5;

[hlist,lengthwidth] = gratingcontrolsheetlet('GratCtrl',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = bsigratingsheetlet('Coarse Direction', 'CoarseDir', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

% [hlist,lengthwidth] = positionsheetlet('Position', 'Pos', [5 newpos]);
% 
% newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = bsigratingsheetlet('Spatial Frequency', 'SpatFreq', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = bsigratingsheetlet('Temporal Frequency', 'TempFreq', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = bsigratingsheetlet('Fine Direction', 'FineDir', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = barorisheetlet('Bar orientation','BarOri',[5 newpos]);

newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = bsigratingsheetlet('Contrast', 'Contrast', [5 newpos]);

newpos = newpos-lengthwidth(2)-15;

% [hlist,lengthwidth] = Lineweightsheetlet('Line Weight', 'Line', [5 newpos]);
% 
% newpos = newpos-lengthwidth(2)-15;
% 
% [hlist,lengthwidth] = lengthwidthsheetlet('Length/Width', 'LengthWidth', [5 newpos]);
% 
% newpos = newpos-lengthwidth(2)-5;

[hlist,lengthwidth] = retinotopysheetlet('Retinotopy', 'retinotopy', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;

% [hlist,lengthwidth] = aperaturesheetlet('Aperature', 'Aperature', [5 newpos]);
% 
% newpos = newpos-lengthwidth(2)-5;


%[hlist,lengthwidth] = bsigratingsheetlet('Spatial Phase', 'SpatPhase', [5 newpos]);

%newpos = newpos-lengthwidth(2)-15;

%[hlist,lengthwidth] = reversecorrelationsheetlet('Reverse Correlation', 'ReverseCorr', [5 newpos]);

%newpos = newpos-lengthwidth(2)-15;

%[hlist,lengthwidth] = daceyrevcorrsheetlet('dacey',[5 newpos]);

%newpos = newpos-lengthwidth(2)-15;

[hlist,lengthwidth] = miscsheetlet('Miscellaneous', 'Misc', [5 newpos]);

newpos = newpos-lengthwidth(2)-5;
