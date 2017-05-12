function RunExperiment(figNum, datapath, analysispath, remotedirpath)

%  RUNEXPERIMENT(FIGURENUM, DATAPATH, ANALYSISPATH, REMOTEDIRPATH)
%
%  Note:  Opens the experiment panel for the VH Lab experiment system
%
%  RunExperiment takes over the figure FIGURENUM, and sets up a panel to
%  control our experimental setup.  The panel should be self-explanatory,
%  but maybe we'll actually write more documentation someday.  Note that the
%  figure is totally cleared by this routine.
%
%  There are three optional arguments:  DATAPATH, ANALYSISPATH, and
%  REMOTEDIRPATH.  These provide initial values for the data path, analysis
%  path, and REMOTEDIRPATH.  Otherwise, the system default values are chosen.

  % add the path of the callback function, platform independent

  

if nargin==0, 
	z = geteditor('RunExperiment');
	if isempty(z),
		figure;
	else,
		figure(z);
	end;
	figureNum = gcf;
else,
	figureNum = figNum;
end;

loc = which('RunExperiment');
li = find(loc==filesep); loc = loc(1:li(end)-1);
addpath([loc filesep 'panelcallbacks' filesep]);
g = figure(figureNum); clf;

global initdatapathNLT initanalysispathNLT initremotedirpathNLT;

if nargin>1,
	InVivoDataPathRem = datapath;
	InVivoAnalysisPath = analysispath;
	InVivoRemoteDirPath = '';
else,
	% get current date and create dated folder in dataman/data/Y-M-D
	[Y,M,D] = datevec(date);
	InVivoDataPathRem = [initdatapathNLT sprintf('%.4i-%.2i-%.2i',Y,M,D)];
	dummy=1;
	try,
		[dummy,str] = dos('whoami');
	end;
	if dummy==0, % analysis path not used right now anyway
		str = str(1:end-1);
		InVivoAnalysisPath = [initanalysispathNLT sprintf('%.4i-%.2i-%.2i',Y,M,D)];
	else,
		InVivoAnalysisPath = '';
	end;
	InVivoRemoteDirPath = initremotedirpathNLT;
end;

 % convert from the Mac % no longer necessary
%InVivoDataPath(find(InVivoDataPath==':'))='/';
%InVivoDataPath = [ '/home/' InVivoDataPath ];

InVivoDataPath = InVivoDataPathRem;
SaveDir = 't001';

answer = questdlg(['Should we use the default path of ' InVivoDataPath ' ?'],'RunExperiment open...','Yes','No - choose another','No - use none','Yes');

if strcmp(answer,'No - choose another'),
	[thepath,thename]=fileparts(InVivoDataPath);
	InVivoDataPath = uigetdir(thepath);
elseif strcmp(answer,'No - use none'),
	InVivoDataPath = 0;
end;

if ischar(InVivoDataPath),
	if exist(InVivoDataPath)~=7,
		[thepath,thename]=fileparts(InVivoDataPath);
		mkdir(thepath, thename);
	end;
else,
	InVivoDataPath = '';
end;

ss = -235+070;
ds = -120+70;
as = 0120+70;
st = 0000+000;
es = 0000;

% set up frame for data and anaylisis directories
pathframe = uicontrol('Style','frame','Units','point', ...
              'Position',[10 485+ds 550 105]);

% data path entry
dpl = uicontrol('Style','text','String','Data path:','Units','point', ...
	'Position',[20 556+ds 100 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left','tag','DataPathTxt');
dp  = uicontrol('Style','text','String',InVivoDataPath,'Units','point', ...
	'Position',[120+5 555+ds-2 350 25],'fontsize',14,'fontweight','normal', ...
	'HorizontalAlignment','left','Callback','runexpercallbk datapath','tag','DataPathEdit'); % now just text

% save directory entry
dptl= uicontrol('Style','text','String','Save dir:','Units','point', ...
	'Position',[20 523+ds 125 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left','visible','off');
dpt  = uicontrol('Style','edit','String',SaveDir,'Units','point', ...
	'Position',[127 522+ds 400 25],'fontsize',14,'fontweight','normal', ...
	'HorizontalAlignment','left','Tag','SaveDirEdit','visible','off');

dp_choose = uicontrol('Style','pushbutton','String','Choose new','units','points','position',[120+5+350+5 555+ds-2 60 25],'callback','runexpercallbk choosedatapath',...
	'tag','DataPathChooseBt');

ap=[];

% set up frame for acquisition list
acq_frame = uicontrol('Style','frame','Units','point', ...
		'Position',[10 130+as 550 110]);

% acquisition list entry
aql_txt = uicontrol('Style','text','String','Acquisition List:','Units','point',...
	'Position',[20 212+as 120 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left');

aql_menu = uicontrol('Style','popup',...
	'String',{'Command','---','Add','Increment All Refs','Decrement All Refs','Edit','Delete','---','Open...','Save...','---',...
		'Default 1 channel','Default 8 channel','Default 16 channel','Default 32 channel','---','Default 2-photon'},'Units','point',...
	'Position',[20+120+5 212+as+3 120 20],'fontsize',14,'tag','AcqListMenu',...
	'callback','runexpercallbk aq_menu');

% list box
aql = uicontrol('Style','listbox','String',{},'Units','point', ...
	'Position',[35 135+as 250 75],'fontweight','normal','fontsize',12,...
	'HorizontalAlignment','left','BackgroundColor',[1 1 1],'UserData',{});

vhlv_channelgrouping_txt = uicontrol('Style','text','String','vhlv_channelgrouping','units','point',...
	'Position',[35+250+10 212+as 120 20],'fontsize',12,'tag','vhlv_channelgroupingText','horizontalalignment','left');

vhlv_channelgrouping_menu = uicontrol('Style','popup','String',{'Commands','---','No editing commands yet','just a viewer'},...
	'units','point','Position',[35+250+10+120+5 212+as+3 120 20],'fontsize',12,...
	'tag','vhlv_channelgroupingMenu','callback','runexpercallbk vhlvchgrmenu');

vhlv_channelgrouping_listbox = uicontrol('Style','listbox','String',{},'Units','point',...
	'Position',[35+250+10 135+as+40 250 40],'fontweight','normal','fontsize',12,...
	'HorizontalAlignment','left','BackgroundColor',[1 1 1],'UserData',{},'tag','vhlv_channelgroupingList');

vhlv_filtermap_text = uicontrol('Style','text','String','vhlv_filtermap','units','point',...
	'Position',[35+250+10 135+as-5+20 120 20],'fontsize',12,'tag','vhlv_filtermap','horizontalalignment','left');
vhlv_filtermap_menu = uicontrol('Style','popup','String',{'Commands','---','No editing commands yet','just a viewer'},'units','point',...
	'Position',[35+250+10+120+5 135+as-5+3+20 120 20],'fontsize',12,'tag','vhlv_filtermapMenu','callback','runexpercallbk vhlvfiltermapmenu');
vhlv_filtermap_listbox = uicontrol('Style','list','String',{},'Units','point',...
	'Position',[35+250+10 135+as  250 20],'tag','vhlv_filtermapList','BackgroundColor',[1 1 1]);

% Script editor frame
scriptframe = uicontrol('Style','frame','Units','point',  ...
			'Position', [10 370+ss 550 110]);

% remote directory entry
rsdl= uicontrol('Style','text','String','Remote Dir', 'Units','point',...
	'Position',[220 449+ss 125 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left','visible','off');

ctdwn=uicontrol('Style','text','String','','Units','points',...
	'Position',[240 425+ss 250 20],'HorizontalAlignment','center');

% display remote directory
rsd = uicontrol('Style','edit','String',InVivoRemoteDirPath,'Units','point',...
	'Position',[327 452+ss 200 20],'fontsize',14,'fontweight','normal',...
	'HorizontalAlignment','left','visible','off');

rslb=uicontrol('Style','listbox','String',{},'Units','point','Position',...
	[20 380+ss 180 90],'Background',[1 1 1],...
        'Callback','runexpercallbk EnDis','Tag','scriptlist');

%rsl = uicontrol('Style','text','String','Run Script:','Units','point', ...
%	'Position',[20 418+ss 125 20],'fontsize',14,'fontweight','bold', ...
%	'HorizontalAlignment','left');

rs=[];
%rs  = uicontrol('Style','edit','String','','Units','point', ...
%	'Position',[127 420+ss 350 25],'fontsize',14,'fontweight','normal', ...
%	'HorizontalAlignment','left');

rsb=[];

% stimulus editor button
rtse= uicontrol('Style','pushbutton','String','StimEditor','Units','point', ...
	'Position',[215 407+ss 100 19],'fontweight','bold', ...
	'HorizontalAlignment','center','Callback',...
        'if geteditor(''StimEditor''),figure(geteditor(''StimEditor''));else StimEditor;end;');

% update button
rsu = uicontrol('Style','pushbutton','String','Update','Units','point', ...
	'Position',[215 387+ss 100 19],'fontweight','bold', ...
	'HorizontalAlignment','center','Callback',...
	'if geteditor(''RemoteScriptEditor''),RemoteScriptEditor(''UpdateRem'',geteditor(''RemoteScriptEditor''));else, RemoteScriptEditor; end;');

%rssl= uicontrol('Style','text','String','Show StimScript:','Units','point', ...
%	'Position',[20 383+ss 150 20],'fontsize',14,'fontweight','bold', ...
%	'HorizontalAlignment','left');

% acquire data button
swvs= uicontrol('Style','checkbox','String','Acquire Data','Units','point',...
	'Position',[315 387+ss 100 19],'fontweight','bold',...
	'HorizontalAlignment','left','Tag','AcquireDataCB');

% script editor button
rtse= uicontrol('Style','pushbutton','String','ScriptEditor','Units','point', ...
	'Position',[315 407+ss 100 19],'fontweight','bold', ...
	'HorizontalAlignment','center','Callback',...
        'if geteditor(''ScriptEditor''),figure(geteditor(''ScriptEditor''));else ScriptEditor;end;');

% show script button
rssb= uicontrol('Style','pushbutton','String','Show Script','Units','point', ...
	'Position',[420 387+ss 100 19],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','center','enable','off','Callback','runexpercallbk showstim');

% remote script editor button
rtse= uicontrol('Style','pushbutton','String','RemoteScriptEditor','Units','point', ...
	'Position',[420 407+ss 100 19],'fontweight','bold', ...
	'HorizontalAlignment','center','Callback',...
        'if geteditor(''RemoteScriptEditor''),figure(geteditor(''RemoteScriptEditor''));else RemoteScriptEditor;end;');
rss=[];

  % EXTERNAL COMMANDS / DEVICES

extdevframe = uicontrol('Style','frame','Units','point',...
	'Position',[10 135+es 550 65]);
extdevlist=uicontrol('Style','listbox','String',{},'Units','point',...
	'Position',[20 140+es 180 55],'Background',[1 1 1],'Tag','extdevlist',...
	'max',2,'value',[]);
extdevlab=uicontrol('Style','text','String','Extra commands/devices',...
	'units','points','position',[200 175+es 200 20],'fontsize',14,'fontweight','bold');
extdevaddbt=uicontrol('Style','pushbutton','String','Add','fontweight','bold',...
	'units','points','position',[225 150+es 70 18],'callback','runexpercallbk extdevaddbt',...
	'Tag','extdevaddbt');
extdevdelbt=uicontrol('Style','pushbutton','String','Delete','fontweight','bold',...
	'units','points','position',[300 150+es 70 18],'callback','runexpercallbk extdevdelbt',...
	'Tag','extdevdelbt');
extdevaboutbt=uicontrol('Style','pushbutton','String','Help','fontweight','bold',...
	'units','points','position',[375 150+es 70 18],'callback','runexpercallbk extdevaboutbt',...
	'Tag','extdevaboutbt');
extdevcb=uicontrol('Style','checkbox','String','Enable EC/Ds','fontweight','bold',...
	'units','points','position',[450 140+es 90 18],'Tag','extdevcb','value',1);

vdaqintrins=uicontrol('Style','checkbox','String','VDAQ Intrinsic','fontweight','bold',...
    'units','points','position',[450 175+es 90 18],'Tag','vdaqintrinsic','value',0);

lvintrins=uicontrol('Style','checkbox','String','LV Intrinsic','fontweight','bold',...
    'units','points','position',[450 157+es 90 18],'Tag','lvintrinsic','value',0);

  % TOOL BUTTONS and POPUPS

toolsframe = uicontrol('Style','frame','Units','point', ...
	'Position',[10 18+st 550 110]);

stlab= uicontrol('units','point','Style','text','String','Useful tools:', 'Units','point',...
	'Position',[18 100+st 125 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left');
uicontrol('unit','point','Style','popup','String',{'Screen Tool','LV Sorting','Intan sorting','Willow sorting', 'TwoPhotonBulkLoad'},'position',[130 100+st 300 20],...
		'callback','simplepopupmenucallback({''screentool;'',  ''vhlv_spikesorting(''''ds'''',dirstruct(get(findobj(gcbf,''''tag'''',''''DataPathEdit''''),''''string'''')));'' ,''vhintan_spikesorting(''''ds'''',dirstruct(get(findobj(gcbf,''''tag'''',''''DataPathEdit''''),''''string'''')));'', ''vhwillow_spikesorting(''''ds'''',dirstruct(get(findobj(gcbf,''''tag'''',''''DataPathEdit''''),''''string'''')));'', ''twophotonbulkload(get(findobj(gcbf,''''tag'''',''''DataPathEdit''''),''''string''''));'' }'')');

stlab2= uicontrol('units','point','Style','text','String','Active sheets:', 'Units','point',...
	'Position',[18 100+st-25 125 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left');
uicontrol('unit','point','Style','popup',...
		'String',{'SimpleComplex','MultiMouse','BrainSurfaceImaging','Ferret Direction','Ferret Training','Ferret LGN','Length Summing','Image Buffer','ChR2 Shen','ChR2 Projector','ChR2','Ferret Scramble','MarjenaSheet'},...
		'position',[130 100+st-25 300 20],...
		'callback','simplepopupmenucallback({''SimpleComplexSheet;'',''MultiMouseSheet;'',''BrainSurfaceImagingSheet;'',''FerretDirectionSheet;'',''TrainingSheet;'',''FerretLGNSheet;'',''LengthSummingSheet;'',''ImageBufferSheet;'',''ChR2ShenSheet;'',''ChR2ProjectorSheet;'',''ChR2Sheet;'',''FerretScrambleSheet;'',''MarjenaSheet;''});');

stlab3= uicontrol('units','point','Style','text','String','Old stuff:', 'Units','point',...
	'Position',[18 100+st-50 125 20],'fontsize',14,'fontweight','bold', ...
	'HorizontalAlignment','left');

uicontrol('unit','point','Style','popup',...
		'String',{'LGN panel','Cortex panel','LGN/CTX panel','ML panel','Fast sloppy analysis popup-upper'},...
		'position',[130 100+st-50 300 20],...
		'callback','simplepopupmenucallback({''lgnexperpanel;'',''ctxexperpanel;'',''lgnctxexperpanel;'',''mlexperpanel;'',''runexpercallbk datapath;fsapu;''});');


data = struct('datapath',dp,'savedir',dpt,'analpath',ap,'runscript',rs, ...
	'remotepath',rsd,'showstim',rss,'savestims',swvs, 'list_aq',aql,...
	'rslb',rslb,'rssb',rssb,'ctdwn',ctdwn,'tag','RunExperiment',...
	'ds',[]);
set(gcf,'UserData',data,'name','RunExperiment','NumberTitle','off');

set(gcf,'Position',[586   239   766   734]);
fig = gcf;
set(findobj(fig,'tag','AcqListMenu'),'value',12);
runexpercallbk('aq_menu',fig);
if ~isempty(InVivoDataPath),
	runexpercallbk('datapath',fig); 
end;

screentool;
