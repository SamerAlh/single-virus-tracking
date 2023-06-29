function evalSPT
close all
%written by BSc. C.P.Richter
%University of Osnabrueck
%Department of Biophysics / Group Piehler
%%%2019 : adapted for Matlab R2018B By Yasmina Fedalaclose all
%%%Tested (and minimally adapted) for Matlab2019a by IIA
vers = ver;
if strcmp(vers(1).Release,'(R2018b)')
set(groot,'defaultFigureCreateFcn',@(fig,~)addToolbarExplorationButtons(fig));
set(groot,'defaultAxesCreateFcn',@(ax,~)set(ax.Toolbar,'Visible','off'));
end
%FRONTPAGE


h(1) =...
    figure(...
    'Tag', 'home',...
    'Units','normalized',...
    'Position', [0.2 0.2 0.5 0.7],...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'Name', 'SPTeval Build 1.103c',...
    'MenuBar', 'none',...
    'ToolBar', 'none',...
    'NumberTitle', 'off',...
        'Resize', 'off');
set(h(1),'Defaultuicontrolunits','Normalized')

h(2) =...
    uicontrol(...
    'Style', 'listbox',...
    'Units','normalized',...
    'Position', [0.05 0.87 0.85 0.1],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1]);

h(3) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Units','normalized',...
    'Position', [0.9 0.936 0.05 0.033],...
    'FontSize', 25,...
    'FontUnits', 'normalized',...
    'String', '+',...
    'Callback', {@addFile, h(2)});

h(4) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Units','normalized',...
    'Position', [0.9 0.903 0.05 0.033],...
    'FontSize', 30,...
    'FontUnits', 'normalized',...
    'String', '-',...
    'Callback', {@delFile, h(2)});

uicontrol(...
    'Style', 'togglebutton',...
    'Units','normalized',...
    'Position', [0.9 0.87 0.05 0.033],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'OK',...
    'Callback', @loadData)

%% TRACK LENGTH PAGE
h(5) =uipanel('Title','Specify Data Subset','FontSize',13,...           
             'Position',[0.05 0.65 0.45 0.2]);


uicontrol(...
    'Style', 'text',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.05 0.7 0.45 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Track Lifetime [Frames]:',...
    'HorizontalAlignment', 'left');

% min
h(6) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.5 0.7 0.2 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'Callback', @setMinTrackLength);

uicontrol(...
    'Style', 'text',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.5 0.94 0.2 0.08],...
    'FontSize', 9,...
    'FontUnits', 'normalized',...
    'String', 'min');

% max
h(7) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.75 0.7 0.2 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'Callback', @setMaxTrackLength);

uicontrol(...
    'Style', 'text',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.75 0.94 0.2 0.08],...
    'FontSize', 9,...
    'FontUnits', 'normalized',...
    'String', 'max');

% excluded data
h(8) =...
    uicontrol(...
    'Style', 'text',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.5 0.4 0.2 0.2],...
    'BackgroundColor', [1 1 1],...
    'FontSize', 10,...
    'FontUnits', 'normalized');

uicontrol(...
    'Style', 'text',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.4 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Data Excluded [%]:',...
    'HorizontalAlignment', 'left');

% exclude by hand (trajectory map)
h(9) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.05 0.1 0.6 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'REMOVE TRACK MANUALLY',...
    'Callback', @removeTrack,...
    'Enable', 'off');

% show track length histogram
h(10) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.7 0.1 0.25 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'HISTOGRAM',...
    'Callback', @trackLengthHist,...
    'Enable', 'off');

h(11) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(5),...
    'Units','normalized',...
    'Position', [0.7 0.4 0.25 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'EXPORT DATA',...
    'Callback', @exportTracks,...
    'Enable', 'off');

%% VISUALISATION PAGE
h(12) =...
    uicontrol(...
    'Style', 'togglebutton',...
    'Units','normalized',...
    'Position', [0.951 0.795 0.04 0.04],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', '1',...
    'Callback', @changeVisMode);
h(13) =...
    uicontrol(...
    'Style', 'togglebutton',...
    'Units','normalized',...
    'Position', [0.951 0.751 0.04 0.04],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', '2',...
    'Value', 1,...
    'Callback', @changeVisMode);
    

%% VISUALISATION PAGE ONE
h(14) =...
    uipanel(...
    'Position', [0.5 0.65 0.45 0.2],...
    'Title','Visualize Trajectory Ensemble',...
    'FontSize',13,...
    'Visible', 'off');

uicontrol(...
    'Style', 'text',...
    'Parent', h(14),...
    'Units','normalized',...
    'Position', [0.05 0.7 0.45 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Colorcoding:',...
    'HorizontalAlignment', 'left');

h(15) =...
    uicontrol(...
    'Style', 'popupmenu',...
    'Parent', h(14),...
    'Units', 'normalized',...
    'Position', [0.4 0.7 0.55 0.2],...
    'String', {'Detection Time', 'Track ID',...
    'Track Length', 'Detection Density', 'Local Diff. Coeff.'},...
    'Value', 1,...
    'BackgroundColor', [1 1 1],...
    'FontSize', 8,...
    'FontUnits', 'normalized');

% set pixelbinning factor
uicontrol(...
    'Style', 'text',...
    'Parent', h(14),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.4 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Binning [px^2]:',...
    'HorizontalAlignment', 'left');

h(16) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(14),...
    'Units','normalized',...
    'Position', [0.4 0.4 0.2 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 1);

% visualise data
h(17) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(14),...
    'Units','normalized',...
    'Position', [0.05 0.1 0.4 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'SHOW ENSEMBLE',...
    'Callback', @showData,...
    'Enable', 'off');

%% VISUALISATION PAGE TWO
h(18) =uipanel(    'Position', [0.5 0.65 0.45 0.2],...
    'Title','Visualize Single Trajectories','FontSize',13);

uicontrol(...
    'Style', 'text',...
    'Parent', h(18),...
    'Units','normalized',...
    'Position', [0.05 0.7 0.45 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Select Trajectory by ID:',...
    'HorizontalAlignment', 'left');

h(19) =...
    uicontrol(...
    'Style', 'popupmenu',...
    'Parent', h(18),...
    'Units', 'normalized',...
    'Position', [0.5 0.7 0.45 0.2],...
    'String', 'empty',...
    'Value', 1,...
    'BackgroundColor', [1 1 1],...
    'FontSize', 8,...
    'FontUnits', 'normalized');

h(20) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(18),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.4 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'CHOOSE FROM MAP',...
    'Callback', @selectTrackFromMap,...
    'Enable', 'off');

h(21) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(18),...
    'Units','normalized',...
    'Position', [0.05 0.1 0.4 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'CHOOSE FROM LIST',...
    'Callback', @selectTrackFromList,...
    'Enable', 'off');

h(22) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(18),...
    'Units','normalized',...
    'Position', [0.5 0.1 0.45 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'SHOW TRACK DETAILS',...
    'Callback', @showOverview,...
    'Enable', 'off');

%% DIFFUSION PAGE
h(23) =...
    uicontrol(...
    'Style', 'togglebutton',...
    'Units','normalized',...
    'Position', [0.01 0.595 0.04 0.04],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', '1',...
    'Value', 1,...
    'Callback', @changeDiffMode);
h(24) =...
    uicontrol(...
    'Style', 'togglebutton',...
    'Units','normalized',...
    'Position', [0.01 0.555 0.04 0.04],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', '2',...
    'Callback', @changeDiffMode);
    
h(25) =...
    uipanel(...
    'Units','normalized',...
    'Position', [0.05 0.3 0.45 0.35],...
    'Title','Two Fractions (Schütz et al.)',...
    'FontSize',13,...
    'FontUnits', 'normalized');

%% DIFFUSION PAGE ONE
%short range
h(26) =...
    uicontrol(...
    'Style', 'checkbox',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.05 0.8 0.4 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Short Range:',...
    'Value', 1);

% start
h(27) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.5 0.8 0.2 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 2);

% stop
h(28) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.75 0.8 0.2 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 6);

%long range
h(29)=...
    uicontrol(...
    'Style', 'checkbox',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.05 0.6 0.35 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Long Range:',...
    'Value', 1);

% start
h(30) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.5 0.6 0.2 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 2);

% stop
h(31) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.75 0.6 0.2 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 26);

%Dmax
h(32) =...
    uicontrol(...
    'Style', 'checkbox',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.7 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Estimate upper Diffusion Limit',...
    'Value', 1);

%diffusion model
uicontrol(...
    'Style', 'text',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.05 0.22 0.45 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Diffusion Model:',...
    'HorizontalAlignment', 'left');

h(33) =...
    uicontrol(...
    'Style', 'popupmenu',...
    'Parent', h(25),...
    'Units', 'normalized',...
    'Position', [0.5 0.24 0.45 0.11],...
    'String', {'Brownian', 'Anomalous', 'Transport'},...
    'Value', 1,...
    'BackgroundColor', [1 1 1],...
    'FontSize', 10,...
    'FontUnits', 'normalized');

h(34) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(25),...
    'Units','normalized',...
    'Position', [0.05 0.05 0.65 0.11],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'ANALYZE DIFFUSION',...
    'Callback', @analyseDiffusionOne,...
    'Enable', 'off');

%% DIFFUSION PAGE TWO
h(35) =...
    uipanel(...
    'Units','normalized',...
    'Position', [0.05 0.3 0.45 0.35],...
    'Title','Multiple Fractions',...
    'FontSize',13,...
    'FontUnits', 'normalized',...
    'Visible', 'off');

h(36) =...
    uicontrol(...
    'Style', 'popupmenu',...
    'Parent', h(35),...
    'Units', 'normalized',...
    'Position', [0.05 0.8 0.65 0.11],...
    'String', {'Analyze Time Step [Frame]',...
    'Analyze Time Series [Frames]'},...
    'Value', 1,...
    'BackgroundColor', [1 1 1],...
    'FontSize', 9,...
    'FontUnits', 'normalized',...
    'Callback',@changeTimeDpndncy);
    function changeTimeDpndncy(src, event)
        h = getappdata(1, 'handles');
        
        switch get(src, 'Value')
            case 1
                set(h(37), 'Visible', 'on')
                set(h(38), 'Visible', 'off')
                set(h(39), 'Visible', 'off')
            case 2
                set(h(37), 'Visible', 'off')
                set(h(38), 'Visible', 'on')
                set(h(39), 'Visible', 'on')
        end %if
    end

h(37) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.75 0.8 0.2 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 5);

% h(37)(2) =...
%     uicontrol(...
%     'Style', 'text',...
%     'Parent', h(35),...
%     'Units','normalized',...
%     'Position', [0.75 0.7 0.2 0.2],...
%     'FontSize', 8,...
%     'FontUnits', 'normalized',...
%     'String', 'Frames',...
%     'HorizontalAlignment', 'left');

h(38) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.75 0.8 0.1 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 2,...
    'BackgroundColor', [1 1 1],...
    'Visible', 'off');

h(39) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.85 0.8 0.1 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 26,...
    'BackgroundColor', [1 1 1],...
    'Visible', 'off');

uicontrol(...
    'Style', 'text',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.05 0.6 0.35 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', '# of Subpopulations:',...
    'HorizontalAlignment', 'left');

h(40) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.5 0.6 0.2 0.11],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 2);

uicontrol(...
    'Style', 'text',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.35 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', '# Bins (Samplingrate):',...
    'HorizontalAlignment', 'left');

h(41) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.5 0.4 0.2 0.11],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 100);

h(42) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.05 0.05 0.5 0.11],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'ANALYZE DIFFUSION',...
    'Callback', @analyseDiffusionTwo,...
    'Enable', 'off');

h(43) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.6 0.17 0.35 0.11],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'D HISTOGRAM',...
    'Callback', @diffCoeffHist,...
    'Enable', 'off');

h(43) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(35),...
    'Units','normalized',...
    'Position', [0.6 0.05 0.35 0.11],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'ALPHA HISTOGRAM',...
    'Callback', @diffCoeffHist,...
    'Enable', 'off');

%% CONFINEMENT

h(44) =...
    uipanel(...
    'Position', [0.5 0.45 0.45 0.2],...
    'Title','Confinement Analysis',...
    'FontSize',13);

uicontrol(...
    'Style', 'text',...
    'Parent', h(44),...
    'Units','normalized',...
    'Position', [0.05 0.7 0.34 0.22],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Upper Diffusion Limit [um^2/s]:',...
    'HorizontalAlignment', 'left');

% max. diffusion coefficient
h(45) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', h(44),...
    'Units','normalized',...
    'Position', [0.4 0.7 0.2 0.2],...
    'BackgroundColor', [1 1 1],...
    'FontSize', 10,...
    'FontUnits', 'normalized');

h(46) =...
    uicontrol(...
    'Style', 'checkbox',...
    'Parent', h(44),...
    'Units','normalized',...
    'Position', [0.7 0.7 0.3 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'estimate',...
    'Value', 1);

uicontrol(...
    'Style', 'text',...
    'Parent', h(44),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.35 0.2],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Algorithm:',...
    'HorizontalAlignment', 'left');

h(47) =...
    uicontrol(...
    'Style', 'popupmenu',...
    'Parent', h(44),...
    'Units', 'normalized',...
    'Position', [0.4 0.43 0.55 0.2],...
    'String', {'Meilhac et al.', 'Saxton et al.'},...
    'Value', 1,...
    'BackgroundColor', [1 1 1],...
    'FontSize', 9,...
    'FontUnits', 'normalized');

h(46) =...
    uicontrol(...
    'Style', 'pushbutton',...
    'Parent', h(44),...
    'Units','normalized',...
    'Position', [0.05 0.1 0.6 0.2],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'ANALYZE CONFINEMENT',...
    'Callback', @confinementAnalysis,...
    'Enable', 'off');

%% track movie
uipanel(...
    'Tag','trackMoviePanel',...
    'Position', [0.5 0.3 0.45 0.15],...
    'Title','Trajectory Movie',...
    'FontSize',13);

uicontrol(...
    'Style', 'togglebutton',...
    'Parent', findobj(h(1),'Tag','trackMoviePanel'),...
    'Tag','buttonSetTrackMovie',...
    'Units','normalized',...
    'Position', [0.55 0.4 0.4 0.3],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Settings',...
    'CreateFcn',{@initializeVarList,'Track Movie'},...
    'Callback', @settingsTrackMovie);

uicontrol(...
    'Style', 'pushbutton',...
    'Parent', findobj(h(1),'Tag','trackMoviePanel'),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.4 0.3],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'START MOVIE',...
    'Callback', @buildTrackMovie,...
    'Enable', 'off');

%% Kinetics
uipanel(...
    'Tag','trackKineticsPanel',...    
    'Position', [0.05 0.05 0.45 0.25],...
    'Title','Kinetics Analysis',...
    'FontSize',13);

uicontrol(...
    'Style', 'text',...
    'Parent', findobj(h(1),'Tag','trackKineticsPanel'),...
    'Units','normalized',...
    'Position', [0.05 0.7 0.35 0.16],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Analysis Window:',...
    'HorizontalAlignment', 'left');

h(47) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', findobj(h(1),'Tag','trackKineticsPanel'),...
    'Units','normalized',...
    'Position', [0.5 0.75 0.2 0.16],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', 16);

uicontrol(...
    'Style', 'text',...
    'Parent', findobj(h(1),'Tag','trackKineticsPanel'),...
    'Units','normalized',...
    'Position', [0.05 0.4 0.35 0.16],...
    'FontSize', 10,...
    'FontUnits', 'normalized',...
    'String', 'Transition Threshold:',...
    'HorizontalAlignment', 'left');

h(48) =...
    uicontrol(...
    'Style', 'edit',...
    'Parent', findobj(h(1),'Tag','trackKineticsPanel'),...
    'Units','normalized',...
    'Position', [0.5 0.45 0.2 0.16],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'BackgroundColor', [1 1 1],...
    'String', -2);

uicontrol(...
    'Style', 'pushbutton',...
    'Parent', findobj(h(1),'Tag','trackKineticsPanel'),...
    'Units','normalized',...
    'Position', [0.05 0.08 0.4 0.17],...
    'FontSize', 8,...
    'FontUnits', 'normalized',...
    'String', 'STATE HISTOGRAM',...
    'Callback', @ensembleStateAnalysis,...
    'Enable', 'off');

%%
setappdata(1, 'handles', h)
setappdata(1, 'searchPath', cd)

end
function addFile(src, event, hList)

[stackname, stackpath, isOK] = uigetfile('*.mat',...
    'Select Tracking Data', getappdata(1,'searchPath'), 'MultiSelect', 'on');
if isOK
    setappdata(1, 'searchPath', stackpath)
    content = get(hList, 'String');
    content = [content',...
        cellstr(strcat(stackpath, stackname))];
    set(hList, 'String', content, 'Value', 1)
else
    return
end %if
end
function delFile(src, event, hList)

bad = get(hList, 'Value');
content = get(hList, 'String');
if isempty(content)
    return
else
    content(bad) = [];
    set(hList, 'String', content, 'Value', 1)
end %if
end
function loadData(src, event)
 
h = getappdata(1, 'handles');

switch get(src, 'Value')
    case 1
        set(findobj(h(1), 'Style',...
            'pushbutton'), 'Enable', 'on')
        set(h(3), 'Enable', 'off')
        set(h(4), 'Enable', 'off')
        
        contents = get(h(2), 'String');
        if isempty(contents)
            set(findobj(h(1), 'Style',...
                'pushbutton'), 'Enable', 'off')
            set(h(3), 'Enable', 'on')
            set(h(4), 'Enable', 'on')
            set(src, 'Value', 0)
            return
        elseif numel(contents) == 1
            
            %%% rename the files by changing '.' or '-' to '_' in the filenames to avoid errors
%            [path, f,ext] = fileparts(contents{1});
%             
%              f1=strrep(f,'-','_');
%              f1=strrep(f1,'.','_');
%              dirname=[path,'\renamedFiles']
%             if ~exist(dirname)
%              mkdir( dirname)
%             end
%              fname2=[fullfile( dirname,f1),ext]
%          
%              movefile(contents{1},fname2);
%              contents1{1}=fname2
             set(h(2), 'String', contents{1})
             %%%%
             %[pathname,filnameRad,ext]=fileparts(contents{1})
            
            FileName=contents{1};
           
            VV=load(contents{1});
            v.data = VV.data.tr;
            
            %num2str(max(VV.trackLength))
            %set(h(7),'String',num2str(max(VV.trackLength)));
         
            v.settings =VV.settings;
            v.detectionsPerFrame = VV.par_per_frame;
            
        else
            setNr = 0;
            temp = [];
            for N = 1:numel(contents)
                VV = load(contents{N});
                for n = 1:numel(VV.data.tr)
                    v.data = VV.data.tr;
                    v.settings =VV.settings;
                    VV.data.tr{n}(:,4) = VV.data.tr{n}(:,4)+setNr;
                end
                setNr = VV.data.tr{n}(1,4);
                setData{N} = VV.data.tr;
                
                %setVV.settingsTrackingAlgorithm{N} = VV.settings.TrackingAlgorithm;
                setVV.settingsFrames(N) = VV.settings.Frames;
                setVV.settingsWidth(N) = VV.settings.Width;
                setVV.settingsHeigth(N) = VV.settings.Height;
                setVV.settingsDelay(N) = VV.settings.Delay;
                if isfield(VV.settings,'Magnification') %for backward compatibility
                    setVV.settingsMagnification{N} = VV.settings.Magnification;
                else
                    setVV.settingsPx2Micron(N) = VV.settings.px2micron;
                end
                
                setPPF{N} = VV.par_per_frame;
                
                if exist('trackActiv','var')
                    temp = [temp trackActiv];
                else
                    temp = [temp true(1,numel(VV.data.tr))];
                end %if
            end
            trackActiv = temp;
            
            v.data = horzcat(setData{:});
            
            v.settings = VV.settings;
            v.settings.Frames = max(setVV.settingsFrames);
            v.settings.Width = max(setVV.settingsWidth);
            v.settings.Height = max(setVV.settingsHeigth);
            if all(setVV.settingsDelay == setVV.settingsDelay)
                v.settings.Delay = setVV.settingsDelay(1);
            else
                errordlg('Timelag not equal', 'Error', 'modal');
            end
            if isfield(VV.settings,'Magnification') %for backward compatibility
                if all(strcmp(cellstr(setVV.settingsMagnification),...
                        cellstr(setVV.settingsMagnification)))
                    v.settings.Magnification = setVV.settingsMagnification{1};
                else
                    errordlg('Magnification not equal', 'Error', 'modal');
                end
                
            else
                if all(setVV.settingsPx2Micron == setVV.settingsPx2Micron)
                    v.settings.px2micron = setVV.settingsPx2Micron(1);
                else
                    errordlg('Magnification not equal', 'Error', 'modal');
                end
            end %if
            v.detectionsPerFrame = nansum(padcat(setPPF{:}));
        end
        if isfield(VV.settings,'Magnification') %for backward compatibility
            % conversion [px] to [?m]
            switch v.settings.Magnification
                case '60, 1x'
                    v.px2micron = 0.267;
                case '60, 1.6x'
                    v.px2micron = 0.180;
                case '150, 1x'
                    v.px2micron = 0.105;
                case '150, 1.6x'
                    v.px2micron = 0.071;
                case 'Simulation'
                    v.px2micron = 0.099;
            end %switch
        else
            v.px2micron = v.settings.px2micron;
        end %if
        
        v.tracksTotal = numel(v.data);
        v.trackIndex = 1:v.tracksTotal;
        v.trackLength = cellfun('size', v.data, 1);
        v.trackLifeTime = cell2mat(cellfun(@(x) (x(end,3)-x(1,3))+1,...
            v.data, 'Un',0));
       
%         v.track = v.trackLength >= 3;
%         v.trackList = vertcat(v.data{v.track});
%         if exist('trackActiv','var')
%             v.trackActiv = trackActiv;
%         else
%             v.trackActiv = true(1,v.tracksTotal);
%         end %if
%         
%         %     set(h.openFilenameText, 'String', [pathname file],...
%         %         'ToolTipString', '', 'UserData', [])
%         set(h(6), 'String', 3)
%         set(h(7), 'String', 100)
%         set(h(8), 'String', ...
%             round(sum(v.trackLength(~v.track))/sum(v.trackLength)*100))
%         set(h(19), 'String',...
%             cellstr(num2str(transpose(find(v.track)))),...
%             'Value', 1)
        
        v.track = v.trackLength >= 3 &...
            v.trackLength <= 100;
        
        if exist('trackActiv','var')
            v.trackActiv = trackActiv;
        else
            v.trackActiv = true(1,v.tracksTotal);
        end %if
        
        v.trackList = vertcat(v.data{v.track & v.trackActiv});
        v.trackList

        set(h(6), 'String', 3)
        %set(h(7), 'String', 100)
        set(h(7), 'String', max( v.trackLength));
        set(h(8), 'String', ...
            round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
            sum(v.trackLength)*100))
        set(h(19), 'String',...
            cellstr(num2str(transpose(find(v.track & v.trackActiv)))))

        %icon grafics
        v.xlsExportIcon = repmat(...
            [NaN,0,NaN,NaN,0,NaN,0,0,0,0,NaN,0,0,0,NaN,NaN;
            NaN,0,NaN,NaN,0,NaN,0,NaN,NaN,0,NaN,0,NaN,NaN,0,NaN;
            NaN,0,NaN,NaN,0,NaN,0,0,0,0,NaN,0,0,0,NaN,NaN;
            NaN,NaN,0,0,NaN,NaN,0,NaN,NaN,0,NaN,0,NaN,NaN,0,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,0,0,0,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,0,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,0,0,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,0,0,0,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,0,NaN,0,NaN,NaN,0,NaN,NaN,NaN,NaN,0,0,0,0,NaN;
            NaN,NaN,0,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN;
            NaN,NaN,0,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,0,0,0,0,NaN;
            NaN,0,NaN,0,NaN,NaN,0,NaN,NaN,NaN,NaN,NaN,NaN,NaN,1,NaN;
            0,NaN,NaN,NaN,0,NaN,0,0,0,0,NaN,0,0,0,0,NaN;], [1 1 3]);
        
        setappdata(1, 'values', v)
        
       
    case 0
        set(findobj(h(1), 'Style',...
            'pushbutton'), 'Enable', 'off')
        set(h(3), 'Enable', 'on')
        set(h(4), 'Enable', 'on')
        
        set(h(6), 'String', '')
        set(h(7), 'String', '')
        set(h(8), 'String', '')
        set(h(19), 'String','empty', 'Value', 1)
        
        v = [];
        
        %icon grafics
        v.xlsExportIcon = repmat(...
            [NaN,0,NaN,NaN,0,NaN,0,0,0,0,NaN,0,0,0,NaN,NaN;
            NaN,0,NaN,NaN,0,NaN,0,NaN,NaN,0,NaN,0,NaN,NaN,0,NaN;
            NaN,0,NaN,NaN,0,NaN,0,0,0,0,NaN,0,0,0,NaN,NaN;
            NaN,NaN,0,0,NaN,NaN,0,NaN,NaN,0,NaN,0,NaN,NaN,0,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,0,0,0,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,0,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,0,0,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,NaN,NaN,0,0,0,0,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;
            NaN,0,NaN,0,NaN,NaN,0,NaN,NaN,NaN,NaN,0,0,0,0,NaN;
            NaN,NaN,0,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN;
            NaN,NaN,0,NaN,NaN,NaN,0,NaN,NaN,NaN,NaN,0,0,0,0,NaN;
            NaN,0,NaN,0,NaN,NaN,0,NaN,NaN,NaN,NaN,NaN,NaN,NaN,1,NaN;
            0,NaN,NaN,NaN,0,NaN,0,0,0,0,NaN,0,0,0,0,NaN;], [1 1 3]);
        
        setappdata(1, 'values', v)
end %switch
end
function changeVisMode(src, event)
        h = getappdata(1, 'handles');
        
        switch get(src, 'String')
            case '1'
                if get(src, 'Value')
                    set(h(14), 'Visible', 'on')
                    set(h(18), 'Visible', 'off')
                    set(h(13), 'Value', 0)
                else
                    set(h(12), 'Value', 1)
                end %if
            case '2'
                if get(src, 'Value')
                    set(h(14), 'Visible', 'off')
                    set(h(18), 'Visible', 'on')
                    set(h(12), 'Value', 0)
                else
                    set(h(13), 'Value', 1)
                end %if
        end %switch
    end
function setMinTrackLength(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')

minLength = str2double(get(h(6), 'String'));
maxLength = str2double(get(h(7), 'String'));
if minLength < 1
    warndlg('min. track length must be 6', 'Warning', 'modal');
    minLength = 6;
elseif maxLength < minLength
    warndlg('max. track length must be >= min. track length',...
        'Warning', 'modal');
    maxLength = minLength;
end %if

v.track = v.trackLength >= minLength &...
    v.trackLength <= maxLength;
v.trackList = vertcat(v.data{v.track & v.trackActiv});

set(h(6), 'String', minLength)
set(h(7), 'String', maxLength)
set(h(8), 'String', ...
    round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
    sum(v.trackLength)*100))
set(h(19), 'String',...
    cellstr(num2str(transpose(find(v.track & v.trackActiv)))))

setappdata(1, 'values', v)
end
function setMaxTrackLength(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')

minLength = str2double(get(h(6), 'String'));
maxLength = str2double(get(h(7), 'String'));

if maxLength > max(v.trackLength)
    maxLength = max(v.trackLength);
elseif maxLength < minLength
    warndlg('max. track length must be >= min. track length', 'Warning', 'modal');
    maxLength = minLength;
end %if

v.track = v.trackLength >= minLength &...
    v.trackLength <= maxLength;
v.trackList = vertcat(v.data{v.track & v.trackActiv});

set(h(7), 'String', maxLength)
set(h(8), 'String', ...
    round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
    sum(v.trackLength)*100))
set(h(19), 'String',...
    cellstr(num2str(transpose(find(v.track & v.trackActiv)))))

setappdata(1, 'values', v)
end
function removeTrack(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')

fig =...
    figure(...
    'Units', 'normalized',...
    'Position', [0.3000 0.0900 0.3656 0.6500],...
    'Toolbar', 'figure',...
    'MenuBar', 'none',...
    'NumberTitle', 'off',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'Name', 'remove Track from further Analysis');
ax =...
    axes(...
    'Parent', fig,...
    'FontSize', 15);

hToolBar = findall(fig,'Type','uitoolbar');
hToggleList = findall(hToolBar);
delete(hToggleList([2 3 4 5 6 7 8 9 10 13 14 16 17 ]))

%plot tracks ensemble at once
line(cell2mat(cellfun(@(x) [x(:,1);nan],...
    v.data(v.track)', 'Un',0)),...
    cell2mat(cellfun(@(x) [x(:,2);nan],...
    v.data(v.track)', 'Un',0)), 'Color', 'b',...
    'Parent', ax);

line(cell2mat(cellfun(@(x) [x(:,1);nan],...
    v.data(~v.trackActiv)', 'Un',0)),...
    cell2mat(cellfun(@(x) [x(:,2);nan],...
    v.data(~v.trackActiv)', 'Un',0)), 'Color', 'r',...
    'LineWidth', 2, 'Parent', ax);

axis('equal', 'ij',...
    [0 v.settings.Width 0 v.settings.Height])
xlabel('x-coordinate [px]'); ylabel('y-coordinate [px]');
 %hcmenu= uimenu('Label','Setup');
hcmenu = uicontextmenu;
uimenu(hcmenu, 'Label', 'activate all','Callback', @selectEnsemble);
uimenu(hcmenu, 'Label', 'remove all','Callback', @selectEnsemble);

set(fig, 'UIContextMenu', hcmenu)
set(ax, 'ButtonDownFcn', @selectTrack)

    function selectTrack(src, event)
      
        [x,y] = ginput(1);
        neighbor = (v.trackList(:,1) - x).^2 +...
            (v.trackList(:,2) - y).^2;
        trackID = v.trackList(neighbor == min(neighbor),4);
        
        %             v = getappdata(1, 'values')
        v.trackActiv(trackID) = false;
        save(char(get(h(2), 'String')),...
            '-struct', 'v', 'trackActiv', '-append')
        
        v.trackList(v.trackList(:,4) == trackID,:) = [];
        
        set(h(8), 'String', ...
            round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
            sum(v.trackLength)*100))
        set(h(19), 'String',...
            cellstr(num2str(transpose(find(v.track & v.trackActiv)))),...
            'Value', 1)
        
        line(v.data{trackID}(:,1),v.data{trackID}(:,2),...
            'Color', 'g', 'LineWidth', 2, 'Parent', ax)
        
        setappdata(1, 'values', v)
    end
    function selectEnsemble(src,event)
       
        switch get(src,'Label')
            case 'activate all'
                v.trackActiv(:) = true;
                v.trackList = vertcat(v.data{v.track});
                
            case 'remove all'
                v.trackActiv(:) = false;
                v.trackList = [];
        end %switch
        save(char(get(h(2), 'String')),...
            '-struct', 'v', 'trackActiv', '-append')
        
        set(h(8), 'String', ...
            round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
            sum(v.trackLength)*100))
        set(h(19), 'String',...
            cellstr(num2str(transpose(find(v.track & v.trackActiv)))),...
            'Value', 1)
        
        setappdata(1, 'values', v)
    end
end
function trackLengthHist(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')
varList = {'Track Lengths', 'Bin Centers',...
    'Frequency Counts'};

fig =...
    figure(...
    'Units', 'normalized',...
    'Position', figPos(1),...
    'Name', 'Track Lifetime Histogram',...
    'NumberTitle', 'off',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'MenuBar', 'none',...
    'ToolBar', 'figure');

hToolBar = findall(fig,'Type','uitoolbar');
hToggleList = findall(hToolBar);
% delete(hToggleList([2 3 5 6 7 9 10 11 12 16 17]))

uipushtool(hToolBar,...
    'CData', v.xlsExportIcon,...
    'ClickedCallback', {@varExport, fig, varList})

ax =...
    axes(...
    'Parent', fig,...
    'FontSize', 15,...
    'NextPlot','add');

minLength = str2double(get(h(6), 'String'));
maxLength = str2double(get(h(7), 'String'));

if 1
    %based on lifetime (includes blinking)
    selection = v.trackLifeTime >= minLength...
        & v.trackLifeTime <= maxLength;
    tracksAnalysed = sum(selection);
    data = v.trackLifeTime(selection);
else
    %based on number of detection (excludes blinking)
    selection = v.trackLength >= minLength...
        & v.trackLength <= maxLength;
    tracksAnalysed = sum(selection);
    data = v.trackLength(selection);
end
if 0
[freq bin] = hist(data, calcnbins(data,'fd'));
else
[freq bin] = ksdensity(data,'function','survivor');
end
%calculate track half-life time
fitHalfLife = fit(bin',freq','exp2');
yhat = feval(fitHalfLife,bin);

bar(ax,bin,freq,'hist');
plot(bin,yhat,'color','r','linewidth',2)
legend(sprintf('Average Lifetime ~ %.0f Frames',...
    -1/fitHalfLife.b))

axis tight
title(['Analyzing ' num2str(tracksAnalysed) ' out of ' ...
    num2str(v.tracksTotal) ' Trajectories']);
xlabel('Trajectory Lifetime [Frames]'); ylabel('Frequency');
end
function changeDiffMode(src, event)
        h = getappdata(1, 'handles');
        
        switch get(src, 'String')
            case '1'
                if get(src, 'Value')
                    set(h(25), 'Visible', 'on')
                    set(h(35), 'Visible', 'off')
                    set(h(24), 'Value', 0)
                else
                    set(h(23), 'Value', 1)
                end %if
            case '2'
                if get(src, 'Value')
                    set(h(25), 'Visible', 'off')
                    set(h(35), 'Visible', 'on')
                    set(h(23), 'Value', 0)
                else
                    set(h(24), 'Value', 1)
                end %if
        end %switch
    end

function exportTracks(src,event)

v = getappdata(1, 'values')
h = getappdata(1, 'handles');
    contents = get(h(2), 'String');
        [filename,pathname,isOK] =...
            uiputfile('.txt' ,...
            'Save Tracking Tables to',...
            ...contents{1}(1:end-4));
            contents(1:end-4));
if isOK
data = vertcat(v.data{v.track & v.trackActiv});
dlmwrite([pathname filename], data,...
    'delimiter', '\t','precision',8, 'newline', 'pc')
msgbox('Done!');

end
end

function showData(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')

% plot track map
fig =...
    figure(...
    'Units', 'normalized',...
    'Position', figPos(1),...
    'Name', 'Ensemble Data Overview',...
    'NumberTitle', 'off',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'MenuBar', 'none',...
    'ToolBar', 'figure');

hToolBar = findall(fig,'Type','uitoolbar');
hToggleList = findall(hToolBar);
uitoggletool(...
        'Parent', hToolBar,...
        'CData', repmat(rand(16), [1 1 3]),...
        'ClickedCallback', @putBackground)
delete(hToggleList([2 3 6 7 8 9 10 13 16 17]))

ax =...
    axes(...
    'Parent', fig,...
    'FontSize', 15,...
    'NextPlot','add');

binFactor = str2double(get(h(16), 'String'));
switch get(h(15), 'Value')
    case 1
        % colorcode by frame
        cmap = jet(v.settings.Frames);
        endPoints = [cumsum(v.trackLength(v.track & v.trackActiv))...
            size(v.trackList,1)];
        for frame = 1:v.settings.Frames-1
            iStart = find(v.trackList(:,3) == frame);
            iStart = iStart(~ismember(iStart,endPoints));
            iEnd = find(v.trackList(:,3) == frame+1 & ...
                ismember(v.trackList(:,4),v.trackList(iStart,4)));
            good = ismember(iStart,iEnd-1);
            x = [v.trackList(iStart(good),1),v.trackList(iEnd,1), nan(sum(good),1)]';
            y = [v.trackList(iStart(good),2),v.trackList(iEnd,2), nan(sum(good),1)]';
            line(1+ x(:)/binFactor, 1+ y(:)/binFactor,...
                'Color', cmap(frame,:), 'Parent', ax);
            if ~all(good)
                iBlink = iStart(good == 0);
                iBlink = iBlink(ismember(v.trackList(iBlink,4),v.trackList(1+iBlink,4)));
                x = [v.trackList(iBlink,1),v.trackList(1+iBlink,1), nan(size(iBlink))]';
                y = [v.trackList(iBlink,2),v.trackList(1+iBlink,2), nan(size(iBlink))]';
                line(1+ x(:)/binFactor, 1+ y(:)/binFactor,...
                    'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5, 'Parent', ax);
            end %if
        end %for
        
        hCbar = colorbar(ax);
        set(hCbar,'YTick', 0:5:65)
        set(hCbar,'YTickLabel', round(v.settings.Frames/14:...
            v.settings.Frames/14:v.settings.Frames))
        label = 'Frame';
    case 2
        % colorcode by track
        cmap = lines(sum(v.track & v.trackActiv));
        xCoords = nan(v.settings.Frames,numel(v.track & v.trackActiv));
        yCoords = nan(v.settings.Frames,numel(v.track & v.trackActiv));
        n = 1;
        for N = find(v.track & v.trackActiv)
            xCoords(v.data{N}(:,3),n) = v.data{N}(:,1);
            yCoords(v.data{N}(:,3),n) = v.data{N}(:,2);
            n = n +1;
        end %for
        for N = 2:v.settings.Frames
            xCoords(N,isnan(xCoords(N,:))) = xCoords(N-1,isnan(xCoords(N,:)));
            yCoords(N,isnan(yCoords(N,:))) = yCoords(N-1,isnan(yCoords(N,:)));
        end %for
        line(xCoords/binFactor +1,yCoords/binFactor +1, 'Parent', ax);
        
        hCbar = colorbar(ax);
        colormap(cmap)
        label = 'Track [id]';
    case 3
        % colorcode by track length
        cmap = jet(max(v.trackLength(v.track & v.trackActiv)));
        xCoords = nan(v.settings.Frames,numel(v.track & v.trackActiv));
        yCoords = nan(v.settings.Frames,numel(v.track & v.trackActiv));
        n = 1;
        for N = find(v.track & v.trackActiv)
            xCoords(v.data{N}(:,3),n) = v.data{N}(:,1);
            yCoords(v.data{N}(:,3),n) = v.data{N}(:,2);
            n = n +1;
        end %for
        for N = 2:v.settings.Frames
            xCoords(N,isnan(xCoords(N,:))) = xCoords(N-1,isnan(xCoords(N,:)));
            yCoords(N,isnan(yCoords(N,:))) = yCoords(N-1,isnan(yCoords(N,:)));
        end %for
        for N = 1:max(v.trackLength(v.track & v.trackActiv))
            good = ismember(v.trackLength(v.track & v.trackActiv), N);
            line(xCoords(:,good)/binFactor +1, yCoords(:,good)/binFactor +1,...
                'Color', cmap(N,:), 'Parent', ax);
        end %for
        
        hCbar = colorbar;
        colormap(jet)
        set(hCbar,'YTick', 0:5:65)
        set(hCbar,'YTickLabel', round(max(v.trackLength)/14:...
            max(v.trackLength)/14:max(v.trackLength)))
        label = 'Length [frames]';
    case 4
        %detection density map
        ctrs{1} = 0.5*binFactor:1*binFactor:v.settings.Height;
        ctrs{2} = 0.5*binFactor:1*binFactor:v.settings.Width;
        frequency_matrix = hist3([v.trackList(:,2) v.trackList(:,1)],ctrs);
        imagesc(log(frequency_matrix+1));
        
        hCbar = colorbar;
        colormap(flipud(gray(256)))
        set(hCbar,'YTickLabel', round(exp(get(hCbar, 'YTick')) -1))
        label = 'Detectiondensity';
    case 5
        %Local Diff Coeff
        ensembleWinAnalysis(ax)
        label = 'Local Diff. Coeff.';
end %switch

xlabel('x-coordinate [px]'); ylabel('y-coordinate [px]');
axis equal ij
xlim ([0 v.settings.Width/binFactor]);
ylim([0 v.settings.Height/binFactor])
cbar = colorbar(ax);
%cbfreeze;
freezeColors(ax)
cblabel(cbar,label)
function putBackground(src,event)
[filename, pathname, isOK] = uigetfile(...
    '*.tif', 'Select Background Images',...
    getappdata(1,'searchPath'));
if isOK
    setappdata(1, 'searchPath', pathname)
    
    im = imread([pathname filename],1);
    imshow(im, [min(min(im)) max(max(im))],'Parent',ax);
    set(ax,'Children', flipud(get(ax,'Children')))
end %if
    end
end
function selectTrackFromMap(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values');

% plot track map
fig =...
    figure(...
    'Units', 'normalized',...
    'Position', figPos(1),...
    'Toolbar', 'figure',...
    'MenuBar', 'none',...
    'NumberTitle', 'off',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'Name', 'select Track for further Analysis');
ax =...
    axes(...
    'Parent', fig,...
    'FontSize', 15);

hToolBar = findall(fig,'Type','uitoolbar');
hToggleList = findall(hToolBar);
...delete(hToggleList([2 3 4 5 6 7 8 9 10 13 14 16 17]))
    delete(hToggleList([]))

xCoords = nan(v.settings.Frames,numel(v.track & v.trackActiv));
yCoords = nan(v.settings.Frames,numel(v.track & v.trackActiv));
n = 1;
for N = find(v.track & v.trackActiv)
    xCoords(v.data{N}(:,3),n) = v.data{N}(:,1);
    yCoords(v.data{N}(:,3),n) = v.data{N}(:,2);
    n = n +1;
end %for
for N = 2:v.settings.Frames
    xCoords(N,isnan(xCoords(N,:))) = xCoords(N-1,isnan(xCoords(N,:)));
    yCoords(N,isnan(yCoords(N,:))) = yCoords(N-1,isnan(yCoords(N,:)));
end %for
line(xCoords +1,yCoords +1, 'Parent', ax);

axis equal ij
xlim ([0 v.settings.Width]); ylim([0 v.settings.Height])
xlabel('x-coordinate [px]'); ylabel('y-coordinate [px]');

set(gca, 'ButtonDownFcn', @selectTrack)

    function selectTrack(~, event)
        
        [x,y] = ginput(1);
        neighbor = (v.trackList(:,1) - x).^2 + (v.trackList(:,2) - y).^2;
        trackID = v.trackList(neighbor == min(neighbor),4);
        
        contents = get(h(19), 'String');
        set(h(19), 'Value',...
            find(str2num(vertcat(contents{:})) == trackID))
        showOverview(src, event)
    end
end
function selectTrackFromList(src, event)

v = getappdata(1, 'values');

figure(...
    'Units', 'normalized',...
    'Position', [0 0 1 1],...
    'MenuBar', 'none',...
    'Toolbar', 'none',...
    'NextPlot', 'add',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'Name', 'Trajectory List',...
    'NumberTitle', 'off');
S={'Details','PayMovie','SaveMovie','apply filter'}

for i=1:size(S,2); 
    
    cbh(i) = uicontrol('Style','checkbox','Parent',gcf,'Units', 'Normalized','String',S{i}, ...
                       'Value',0,'Position',[0.001 0.8+0.04*i 0.04    0.02]);
                  CBHValue(i)=get(cbh(i),'Value')
end


stepSize = 1/floor(sum(v.track)/20);
if isinf(stepSize)
    stepSize = 0;
end %if

 hSlider=uicontrol(...
    'Style', 'slider',...
    'Units', 'normalized',...
    'Position', [0.98 0 0.01 1],...
    'Min', 0,...
    'Max', ceil(sum(v.track)/20)-1,...
    'Value', ceil(sum(v.track)/20)-1,....
    'SliderStep', [stepSize stepSize],...
    'CreateFcn', @showList,...
    'Callback', @showList);

 try    % R2013b and older
   addlistener(hSlider,'ActionEvent', @showList);
catch  % R2014a and newer
   addlistener(hSlider,'ContinuousValueChange', @showList);
end
%        jButton = findjobj(hButton);
%        jButton.MouseWheelMovedCallback = @showList;
    function showList(src, event)
        
        h = getappdata(1, 'handles');
        v = getappdata(1, 'values');
        
        delete(findobj(gcf, 'Type', 'axes',...
            '-or', 'Style', 'popupmenu'))
        count = 1+(ceil(sum(v.track)/20)-...
            round(get(src, 'Value'))-1)*20;
        idx = find(v.track);
        for n = 0.8:-0.25:0
            for m = 0:0.2:0.8
                if count > numel(idx)
                    return
                end %if
                axes(...
                    'Position', [0 0 1 1],...
                    'OuterPosition', [m n 0.2 0.2],...
                    'NextPlot', 'replace',...
                    'DataAspectRatio', [1 1 1]);
                
                hold on
               h(50)= plot(v.data{idx(count)}(:,1)-min(v.data{idx(count)}(:,1)),...
                    v.data{idx(count)}(:,2)-min(v.data{idx(count)}(:,2)),...
                    'LineWidth', 1);
                set(h(50),'Tag',num2str(idx(count))) ;
                                   
                set( h(50),'ButtonDownFcn',{@ChooseStudy,cbh,h})
               
                 title(['Track Nr: ' num2str(idx(count))],'userdata', idx(count));

                axis ij tight off
                ax = axis;
                line([ax(1),ax(1)+1], [ax(3),ax(3)], 'Color', 'r',...
                    'LineWidth', 4);
              % [ '%%%%',idx(count)]
               %set(hi, 'ButtonDownFcn', @setSelection,'ButtonDownFcn', @showOverview)
                setappdata(1, 'values', v);
                switch v.trackActiv(idx(count))
                    case 1
                        status = 1;
                        color = [0 1 0];
                    case 0
                        status = 2;
                        color = [1 0 0];
                end %switch
                uicontrol(...
                    'Style', 'popupmenu',...
                    'Units', 'normalized',...
                    'Position', [m+0.05 n 0.1 0.02],...
                    'String', {'active', 'excluded'},...
                    'FontSize', 9,...
                    'Value', status,...
                    'UserData', idx(count),...
                    'BackgroundColor', color,...
                    'Callback', {@setTraceStatus, h});
                
                count = count +1;
            end %for
        end %for
    end
%     function setSelection(src, event,TID,h)
%            v = getappdata(1, 'values');
%            h = getappdata(1, 'handles');
%           selection = (str2double(get(h(19),'String')) == TID);
%           set(h(19),'value',find(selection));
%     
%      
%     end
    function setTraceStatus(src, event, h)
        
        v = getappdata(1, 'values');
        
        trackID = get(src, 'UserData');
        switch get(src, 'Value')
            case 1
                set(src, 'BackgroundColor', [0 1 0]);
                v.trackActiv(trackID) = true;
                v.trackList = vertcat(v.data{v.track & v.trackActiv});
            case 2
                set(src, 'BackgroundColor', [1 0 0]);
                v.trackActiv(trackID) = false;
                v.trackList(v.trackList(:,4) == trackID,:) = [];
        end %switch
        save(char(get(h(2), 'String')),...
            '-struct', 'v', 'trackActiv', '-append')
        
        set(h(8), 'String', ...
            round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
            sum(v.trackLength)*100))
        set(h(19), 'String',...
            cellstr(num2str(transpose(find(v.track & v.trackActiv)))),...
            'Value', 1)
        
        %             setappdata(1, 'handles', h)
        setappdata(1, 'values', v)
    end
end
function ChooseStudy(src, event,cbh,h)
 v = getappdata(1, 'values');
 h = getappdata(1, 'handles');
if strcmp(get(src,'type'),'line') 
CBHS=get(cbh,'String');
CBHV=get(cbh,'Value');
I=cellfun(@isequal, CBHV,{[1];[1];[1];[1]});
%switch CBHV
     if  I(1)
   showOverview(src, event,cbh);
    %set( h(50),'ButtonDownFcn',{@ChooseStudy,cbh})
    
     elseif I(2)
        TID=get(src,'Tag');
  selection = (str2double(get(h(19),'String')) == str2double(TID));
          set(h(19),'value',find(selection));
          PlayMovie(src, event,  str2double( TID), cbh(4), v, h);
     elseif I(3)
         TID=get(src,'Tag');
  selection = (str2double(get(h(19),'String')) == str2double(TID));
          set(h(19),'value',find(selection));
        
    SaveMovie(src, event,  str2double( TID), cbh(4), v, h);
     else
        
         warndlg('Select an option before !!');
         
   end
end

end
function showOverview(src, event,cbh)
if strcmp(get(src,'type'),'line') 
CBHS=get(cbh,'String');
CBHV=get(cbh,'Value');
end
get(src,'userdata');
h = getappdata(1, 'handles');
v = getappdata(1, 'values');

if strcmp(get(src,'type'),'line') 
%     selection = ...
%         str2double(get(h(19),'String')) == get(src,'userdata');
%     set(h(19),'value',find(selection))
    TID=get(src,'Tag');
  selection = (str2double(get(h(19),'String')) == str2double(TID));
          set(h(19),'value',find(selection));
    
end %if
trackID = get(h(19), {'String', 'Value'});
% if index(3)
%   
%  PlayMovie(src,event,TID, cbh(4), v, h)
%     return
% end
%if index(1)
    % if cbhV
    % @PlayMovie,...
    %     trackID, movieFilter, v, h}
    switch get(src, 'Tag')
        case 'previous'
            if trackID{2} > 1
                trackID{2} = trackID{2} -1;
                set(h(19), 'Value', trackID{2})
                clf
            end %if
        case 'next'
            if trackID{2} < numel(trackID{1})
                trackID{2} = trackID{2} +1;
                set(h(19), 'Value', trackID{2})
                clf
            end %if
        otherwise
            figure(...
                'Units', 'normalized',...
                'Position', [0 0 1 1],...
                'Color', get(0,'defaultUicontrolBackgroundColor'),...
                'ToolBar', 'none',...
                'MenuBar', 'none',...
                'Name', 'Trajectory Overview',...
                'NumberTitle', 'off');
%              movieFilter =...
%         uicontrol(...
%         'Style', 'checkbox',...
%         'Units','normalized',...
%         'Position', [0.262 0.95 0.05 0.03],...
%         'FontSize', 8,...
%         'FontUnits', 'normalized',...
%         'String', 'apply filter',...
%         'Value', 0);
    %global movieFilter
    end %switch
    trackID = str2double(cell2mat(trackID{1}(trackID{2})));
    
    x = repmat(v.data{trackID}(:,1),1,v.trackLength(trackID));
    y = repmat(v.data{trackID}(:,2),1,v.trackLength(trackID));
    frame = repmat(v.data{trackID}(:,3),1,v.trackLength(trackID));
    
    good = tril(true(v.trackLength(trackID)),-1);
    dxPos = (x(good)-x(flipud(good))).*v.px2micron;
    dyPos = (y(good)-y(flipud(good))).*v.px2micron;
    
    singleTrackSD = dxPos.^2 + dyPos.^2;
    stepLength = frame(good)-frame(flipud(good));
    
    singleTrackMSD = nonzeros(accumarray(stepLength,...
        singleTrackSD,[],@nanmean));
    
    nObs = nonzeros(accumarray(stepLength,1));
    n = unique(stepLength);
    if 1
        %Quian et al.
        take = nObs >= max(nObs)/2;
        errMSD(take,1) = sqrt((4*n(take).^2.*nObs(take)+2.*nObs(take)+n(take)-n(take).^3)./(6.*n(take).*nObs(take).^2));
        errMSD(~take,1) = sqrt(1+(nObs(~take).^3-4.*n(~take).*nObs(~take).^2+4.*n(~take)-nObs(~take))./(6.*n(~take).^2.*nObs(~take)));
        errMSD = singleTrackMSD.*errMSD;
    else
        errMSD = accumarray(stepLength,...
            singleTrackSD,[],@nanstd);
        errMSD = errMSD(n)./nObs;
    end
    %preallocate space
    moment = mat2cell(zeros(v.trackLength(trackID),6),...
        v.trackLength(trackID),ones(1,6));
    
    % mean moment displacements (mmd)
    moment{1} = log(nonzeros(accumarray(stepLength,abs(dxPos)...
        + abs(dyPos),[],@mean)));
    moment{2} = log(singleTrackMSD);
    moment{3} = log(nonzeros(accumarray(stepLength,abs(dxPos.^3)...
        + abs(dyPos.^3),[],@mean)));
    moment{4} = log(nonzeros(accumarray(stepLength,dxPos.^4 ...
        + dyPos.^4,[],@mean)));
    moment{5} = log(nonzeros(accumarray(stepLength,abs(dxPos.^5)...
        + abs(dyPos.^5),[],@mean)));
    moment{6} = log(nonzeros(accumarray(stepLength,dxPos.^6 ...
        + dyPos.^6,[],@mean)));
    
    logTime = log(unique(stepLength)*v.settings.Delay);
    
    % calculate a robust fit (log(mmd) vs log(t)) for 1/3 (max 10 steps) of track
    trackCutOff = 5;
    fitMoments = cell2mat(cellfun(@(x) robustfit(logTime(1:trackCutOff),...
        x(1:trackCutOff)),moment,'Un',0));
    
    % theoretical diffuison constant (considering a free diffusion model)
    singleTrackD = 0.25*exp(fitMoments(3));
    
    % fitting mean scaling spectrum vs. moments
    s = fitoptions('Method', 'LinearLeastSquares',...
        'Lower',[-1,-Inf],...
        'Upper', [1,Inf],...
        'Robust', 'on');
    
    f = fittype({'moment','1'},...
        'coefficients', {'slope','intercept'},...
        'options', s,...
        'independent', 'moment');
    
    [fitMSS, statsMSS] = fit ((1:6)',fitMoments(2,1:6)',f);
    
    singleTrackMSS = fitMSS.slope;
    singleTrackMSSadjrsquare = statsMSS.adjrsquare;
    
    % angle between steps (theta(n+1) - theta(n), neg. deg. = left turn)
    singleTrackStepAngle = [nan; diff(atan2(dyPos(1:v.trackLength(trackID)),...
        dxPos(1:v.trackLength(trackID))))*180/pi];
    singleTrackStepAngle(singleTrackStepAngle < -180) = ...
        singleTrackStepAngle(singleTrackStepAngle < -180) + 360;
    singleTrackStepAngle(singleTrackStepAngle > 180) = ...
        singleTrackStepAngle(singleTrackStepAngle > 180) - 360;
    
    singleTrackStepAngleMedians = ...
        [median(singleTrackStepAngle(singleTrackStepAngle < 0)),...
        median(singleTrackStepAngle(singleTrackStepAngle > 0))];
    
    trackIndex = 1:v.trackLength(trackID);
    blinkIndex = [stepLength(1:v.trackLength(trackID)-1) > 1; false];
    
    %MSS Plot
    hSub(2) = axes(...
        'Position', [0.050, 0.11, 0.2368, 0.34]);
    plot(fitMSS,'r',(1:6),fitMoments(2,1:6), 'o')
    axis tight
    title(['MSS: ' num2str(fitMSS.slope,'%.3f') ' (R^2: ' ...
        num2str(statsMSS.adjrsquare,'%.3f') ')'])
    xlabel('Moment'); ylabel('Gamma')
    ylim([0 5])
    legend off
    
    %Trajectory Plot
    hSub(1) = axes('Position', [0.050, 0.5682, 0.2368, 0.34]);
    minX = min(v.data{trackID}(:,1));
    minY = min(v.data{trackID}(:,2));
    hold on
    plot(1000*v.px2micron*(v.data{trackID}(:,1)-minX),...
        1000*v.px2micron*(v.data{trackID}(:,2)-minY))
    h = plot(1000*v.px2micron*([v.data{trackID}(blinkIndex,1)';...
        v.data{trackID}([false; blinkIndex(1:end-1)],1)']-minX),...
        1000*v.px2micron*([v.data{trackID}(blinkIndex,2)';...
        v.data{trackID}([false; blinkIndex(1:end-1)],2)']-minY), 'r');
                     
    trackPlotBlink = hggroup;
    set(h,'Parent',trackPlotBlink)
    set(get(get(trackPlotBlink,'Annotation'),'LegendInformation'),...
        'IconDisplayStyle','on');
    plot(1000*v.px2micron*(v.data{trackID}(1,1)-minX),...
        1000*v.px2micron*(v.data{trackID}(1,2)-minY),'ro')
    hold off
    % legend('Track', 'Blink', 'Start', 'Orientation', 'horizontal')
    axis equal tight ij
    title(['Track Nr: ' num2str(trackID)])
    xlabel('x Position [nm]'); ylabel('y Position [nm]')
    
     c = uicontextmenu;
     hl=findobj(gcf,'Type','line')
     set(hl,'UIContextMenu', c);
     
    %MSD vs. Time Plot
    hSub(3) = axes('Position', [0.3491, 0.7673, 0.6109, 0.1577]);
    hold on
    errorbar(unique(stepLength)*v.settings.Delay,...
        singleTrackMSD,errMSD, 'o:')
    plot(unique(stepLength)*v.settings.Delay,...
        smooth(singleTrackMSD), 'r')
    plot([trackCutOff*v.settings.Delay ...
        trackCutOff*v.settings.Delay],...
        [min(singleTrackMSD-errMSD)...
        max(singleTrackMSD+errMSD)], 'r:')
    text(trackCutOff*v.settings.Delay , ...
        max(singleTrackMSD+errMSD),...
        sprintf('\n  cut off'), 'Color', 'r', 'FontSize', 13)
    hold off
    axis tight
    title(['Diffusion Coefficient: ' num2str(singleTrackD,'%.3f') ' ?m^2/s; ' ...
        'alpha = ' num2str(fitMoments(4),'%.2f')])
    xlabel('Time [s]'); ylabel('MSD [?m^2]')
    
    %OneStep Displacement vs. Position Plot
    hSub(4) = axes('Position', [0.3491, 0.5482, 0.35, 0.1577]);
    data = [sqrt(singleTrackSD(1:v.trackLength(trackID)-1))*1000; nan];
    hold on
    plot(trackIndex, data, 'bo:')
    plot(trackIndex(blinkIndex), data(blinkIndex), 'rx')
    plot(trackIndex, smooth(data),'r')
    % legend ('Displacement', 'Blink', 'Smooth', 'Orientation', 'horizontal')
    axis tight
    xlabel('Vector Position'); ylabel('Displacement [nm]')
    
    hSub(5) = axes('Position', [0.76, 0.5482, 0.2, 0.1577]);
    hist(sqrt(singleTrackSD(1:v.trackLength(trackID)))*1000,...
        calcnbins(sqrt(singleTrackSD(1:v.trackLength(trackID)))*1000, 'fd'))
    xlabel('Displacement [nm]'); ylabel('Frequency')
    axis tight
    
    %Intensity vs. Position Plot
    hSub(8) = axes('Position', [0.3491, 0.1100, 0.35, 0.1577]);
    %         photons = (v.data{trackID}(:,5)/(sqrt(pi)*imageBin.psf))*...
    %             2*pi*imageBin.psf^2*imageBin.cnts2photon;
    volume = v.data{trackID}(:,5)/...
        (sqrt(pi)*v.settings.TrackingOptions.GaussianRadius)*...
        2*pi.*v.settings.TrackingOptions.GaussianRadius.^2; %counts
    hold on
    plot(trackIndex, volume, 'bo:')
    plot(trackIndex, smooth(volume), 'r')
    hold off
    axis tight
    xlim([0 v.trackLength(trackID)])
    xlabel('Track Position'); ylabel('Signal [counts]')
    % legend('Intensity', 'Offset', 'Orientation', 'horizontal')
    
    hSub(9) = axes('Position', [0.76, 0.1100, 0.2, 0.1577]);
    precision =...
        calcLocPrecision(v.settings.TrackingOptions.GaussianRadius,...
        v.px2micron, volume, sqrt(v.data{trackID}(:,6)));
    
    hist(precision*1000, calcnbins(precision, 'fd'))
    xlabel('Localization Precision [nm]'); ylabel('Frequency')
    axis tight
    
    %Angle vs. Position Plot
    hSub(6) = axes('Position', [0.3491, 0.3291, 0.35, 0.1577]);
    hold on
    plot(trackIndex, singleTrackStepAngle, 'bo:')
    % line([0, 0; v.trackLength(trackID), v.trackLength(trackID)],...
    %     repmat(singleTrackStepAngleMedians,2,1), 'Color', 'r')
    plot(trackIndex(singleTrackStepAngle > 0), ...
        smooth(singleTrackStepAngle(singleTrackStepAngle > 0)), 'r')
    plot(trackIndex(singleTrackStepAngle < 0), ...
        smooth(singleTrackStepAngle(singleTrackStepAngle < 0)), 'r')
    hold off
    axis tight
    xlim([0 v.trackLength(trackID)]); ylim([-180 180])
    xlabel('Track Position'); ylabel('Vectors Angle [deg]')
    set(gca, 'YTick', [-180 -90 0 90 180])
    
    % hLabel = (get([hSub(:)], {'YLabel', 'XLabel', 'Title'}));
    % set(hLabel(:), 'FontSize', 13)
    % a=findobj(gcf,'type','axe');
    % set(get(a,'xlabel'),'FontSize', 13);
    hSub(7) = axes('Position', [0.76, 0.3291, 0.2, 0.1577]);
    bar(-180:45:180, histc(singleTrackStepAngle, -180:45:180), 'histc')
    xlabel('Vectors Angle [deg]'); ylabel('Frequency')
    xlim([-180 180])
    
    linkaxes([hSub([4,6,8])], 'x')
    set([hSub(:)],'ButtonDownFcn', @increaseAx)
    
    uicontrol(...
        'Style', 'pushbutton',...
        'Tag', 'previous',...
        'Units', 'normalized',...
        'Position', [0.048 0.475 0.025 0.05],...
        'String', '<',...
        'FontSize', 10,...
        'Callback', @showOverview)
    
    uicontrol(...
        'Style', 'pushbutton',...
        'Tag', 'next',...
        'Units', 'normalized',...
        'Position', [0.262 0.475 0.025 0.05],...
        'String', '>',...
        'FontSize', 10,...
        'Callback', @showOverview)
    
    
%     uicontrol(...
%         'Style', 'pushbutton',...
%         'Units', 'normalized',...
%         'Position', [0.012 0.95 0.075 0.03],...
%         'String', 'show position',...
%         'FontSize', 10,...
%         'Callback', {@localizeTrackOnMap, trackID})
    
%     uicontrol(...
%         'Style', 'pushbutton',...
%         'Tag', 'subTrackAnalysis',...
%         'Units', 'normalized',...
%         'Position', [0.097 0.95 0.075 0.03],...
%         'String', 'Window Analysis',...
%         'FontSize', 10,...
%         'Callback', {@trackWinAnalysis, v.data{trackID}(:,1),...
%         v.data{trackID}(:,2),v.data{trackID}(:,3),...
%         16,v.settings.Delay,v.settings.px2micron,...
%         v.data{trackID}(:,8)})
%     
    movieFilter =...
        uicontrol(...
        'Style', 'checkbox',...
        'Units','normalized',...
        'Position', [0.262 0.95 0.05 0.03],...
        'FontSize', 8,...
        'FontUnits', 'normalized',...
        'String', 'apply filter',...
        'Value', 0);
    m1 = uimenu(c,'Label','Show Movie','Callback',{@PlayMovie,...
         trackID, movieFilter, v, h});
     m2=uimenu(c,'Label','Window Analysis','Callback',...
     {@trackWinAnalysis, v.data{trackID}(:,1),...
        v.data{trackID}(:,2),v.data{trackID}(:,3),...
        16,v.settings.Delay,v.settings.px2micron,...
        v.data{trackID}(:,8)});
     m3=uimenu(c,'Label','show position',...       
        'Callback', {@localizeTrackOnMap, trackID})
     m4 = uimenu(c,'Label','Save Movie','Callback',{@SaveMovie,...
         trackID, movieFilter, v, h});
%     uicontrol(...
%         'Style', 'pushbutton',...
%         'Units','normalized',...
%         'Position', [0.182 0.95 0.075 0.03],...
%         'FontSize', 10,...
%         'FontUnits', 'normalized',...
%         'String', 'Track Movie',...
%         'Callback', {@PlayMovie,...
%         trackID, movieFilter, v, h});
    
%     uicontrol(...
%         'Style', 'pushbutton',...
%         'Tag', 'subTrackAnalysis',...
%         'Units', 'normalized',...
%         'Position', [0.167 0.95 0.075 0.03],...
%         'String', 'Window Analysis',...
%         'FontSize', 10,...
%         'Callback', @ensembleWinAnalysis)
    

    function localizeTrackOnMap(src, event, trackID)
    
    
    fig =...
        figure(...
        'Units', 'normalized',...
        'Position', figPos(1),...
        'Toolbar', 'none',...
        'MenuBar', 'none',...
        'NextPlot', 'add',...
        'Color', get(0,'defaultUicontrolBackgroundColor'),...
        'Name', 'Localization Map',...
        'NumberTitle', 'off');
    
    ax =....
        axes('Parent', fig,...
        'FontSize', 15);
    
    %plot tracks ensemble at once
    line(cell2mat(cellfun(@(x) [x(:,1);nan],...
        v.data(v.track)', 'Un',0)),...
        cell2mat(cellfun(@(x) [x(:,2);nan],...
        v.data(v.track)', 'Un',0)));
    
    line(v.data{trackID}(:,1), v.data{trackID}(:,2),...
        'Color', 'r', 'LineWidth', 2.5)
    
    axis('equal', 'ij',...
        [0 v.settings.Width 0 v.settings.Height])
    xlabel('x-coordinate [px]'); ylabel('y-coordinate [px]');
    end
    function increaseAx(src, event)
    
    fig =...
        figure(...
        'Units','normalized',...
        'Position', [0 0 1 1],...
        'NumberTitle', 'off',...
        'Color', get(0,'defaultUicontrolBackgroundColor'),...
        'MenuBar', 'none',...
        'ToolBar', 'figure');
    hToolBar = findall(fig,'Type','uitoolbar');
    hToggleList = findall(hToolBar);
    delete(hToggleList([2 3 4 5 6 7 8 9 10 16 17]))
    
    hObj = copyobj(src,fig);
    set(hObj, 'OuterPosition', [0 0 1 1],...
        'Position', [0.13 0.11 0.775 0.815])
    end
    function precision =...
        calcLocPrecision(psfStd, pxSize, photons, noise)
    %calculates the localization uncertainty based on
    %   psfStd, pxSize, photons, noise. (Thompson and Webb)
    
    psfStd = psfStd*pxSize; % px -> ?m
    precision = sqrt((psfStd.^2+pxSize^2/12)./photons+...
        8*pi.*psfStd.^4.*noise.^2/pxSize^2./photons.^2); %[?m]
    end
end


function ensembleStateAnalysis(src,event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values');

w = str2double(get(h(47),'string'));
yThresh = str2double(get(h(48),'string'));

good = find(v.track & v.trackActiv);
for N = good
    [nrSeg idxSeg ptsSeg lifeTime w] =...
        segmentTrack(v.data{N}(:,3),w);
    
    x = accumarray(1+v.data{N}(:,3)-v.data{N}(1,3),...
        v.data{N}(:,1),[lifeTime 1],[],nan);
    y = accumarray(1+v.data{N}(:,3)-v.data{N}(1,3),...
        v.data{N}(:,2),[lifeTime 1],[],nan);
    frame = (1:lifeTime)';
    
    [data take] =...
        evalLocalDiff(...
        x,...
        y,...
        frame,...
        w,...
        nrSeg,...
        idxSeg,...
        v.settings.Delay,...
        v.px2micron);
    
    [beginEvent endEvent lengthEvent{N}...
        beginGround endGround lengthGround{N}] =...
        getConfBounds(data(take)',...
        yThresh, 1);
    
    %filter eventstate
    if ~isempty(lengthEvent{N})
        if lengthEvent{N} == numel(data(take))
            %discard if no transition
            lengthEvent{N} = [];
        else
            if any(beginEvent == 1)
                %discard if beginn of event is not observed
                lengthEvent{N}(1) = [];
            end %if
            if any(endEvent == numel(data(take)))
                %discard if end of event is not observed
                lengthEvent{N}(end) = [];
            end %if
        end %if
    end %if
    %filter groundstate
    if ~isempty(lengthGround{N})
        if lengthGround{N} == numel(data(take))
            %discard if no transition
            lengthGround{N} = [];
        else
            if any(beginGround == 1)
                %discard if beginn of event is not observed
                lengthGround{N}(1) = [];
            end %if
            if any(endGround == numel(data(take)))
                %discard if end of event is not observed
                lengthGround{N}(end) = [];
            end %if
        end %if
    end %if
    
    %ROC Curve
%     measureBinary = data(take)' <= yThresh;
%     simBinary = v.data{N}(take,8) > 1.5;
%     TP{N} = sum(measureBinary & simBinary);
%     TN{N} = sum(~measureBinary & ~simBinary);
%     FN{N} = sum(~measureBinary & simBinary);
%     FP{N} = sum(measureBinary & ~simBinary);
        
        %count # missed detections
%     [beginEventSim endEventSim lengthEventSim...
%         beginGroundSim endGroundSim lengthGroundSim] =...
%         getConfBounds(v.data{N}(take,8),...
%         1.5, 1);

%     errCnt{N} = [0 0];
%     detectCnt{N} = 0;
%     if isempty(lengthGround{N})
%         errCnt{N}(2) = 10;
%     else
%             detections = numel(lengthGround{N});
%             isFalseDetected = true(1,detections);
% 
%         for pulse = 1:10
%             pulseDetected = false;
%             coveredFramesSim = beginEventSim(pulse):endEventSim(pulse);
%             
%             for detection = 1:detections
%                 coveredFrames = beginGround(detection):endGround(detection);
%                 good = ismember(coveredFramesSim,coveredFrames);
%                 if any(good)
%                     detectCnt{N} = detectCnt{N} + 1;
%                     
%                     %simulated pulse has been detected
%                     pulseDetected = true;
%                     
%                     %current detection is true detection
%                     isFalseDetected(detection) = false;
%                     
%                     %calculate ratio of measured tau to simulated tau
%                     detectionAcc{N}(detectCnt{N}) =...
%                         lengthGround{N}(detection)/lengthEventSim(5);
%                 end
%             end
%             
%             % # pulses not detected
%             if ~pulseDetected
%                errCnt{N}(2) = errCnt{N}(2) + 1;
%             end
%             
%         end
%         % # of false detection
%         errCnt{N}(1) = sum(isFalseDetected);
%     end

end %for
lengthEvent = vertcat(lengthEvent{:});
lengthGround = vertcat(lengthGround{:});

% Save the Ground and Free states for the building transitions histograms
if 1
           [filename,pathname,isOK] =...
            uiputfile('' ,'Save Data',getappdata(1,'searchPath'));
        fid = fopen([pathname, filename '_lengthEvent.txt'],'w+');
        fprintf(fid,'%g \t\n', lengthEvent)
        fclose(fid)
        fid = fopen([pathname, filename 'lengthGround.txt'],'w+');
        fprintf(fid,'%g \t\n', lengthGround)
fclose(fid)
end

% End of save the Ground and Free states for the building transitions histograms

% if 1
%     errCnt = sum(vertcat(errCnt{:}))./[1 1000];
%     horzcat(detectionAcc{:})
% end

figure;
hold on
% [f(:,1) xi(:,1)] = ksdensity(lengthGround,'function',@exppdf);
% [f(:,2) xi(:,2)] = ksdensity(lengthEvent*...
%     v.settings.Delay,'kernel','epanechnikov','support','positive','function','survivor');
% h = bar(xi, f);

ctrs = (1:max(max(lengthGround),max(lengthEvent)));
% ctrs = linspace(v.settings.Delay,...
%     max(max(lengthGround),max(lengthEvent))*v.settings.Delay,100)
h = bar(ctrs, [hist(lengthGround,ctrs);...
    hist(lengthEvent,ctrs)]','hist');

[fitGround ciGround] = expfit(lengthGround*v.settings.Delay)
[fitEvent ciEvent] = expfit(lengthEvent*v.settings.Delay)

try
fitGround = fit(ctrs',hist(lengthGround,ctrs)','exp1');
plot(ctrs,feval(fitGround,ctrs),'b-',...
    'DisplayName', sprintf('A0 = %.1f; tau = %.1f sec',...
    fitGround.a,-1/fitGround.b),'LineWidth', 2)
catch
    sprintf('fitting ground state failed')
end
try
fitEvent = fit(ctrs',hist(lengthEvent,ctrs)','exp1');
plot(ctrs,feval(fitEvent,ctrs),'r-',...
    'DisplayName', sprintf('A0 = %.1f; tau = %.1f sec',...
    fitEvent.a,-1/fitEvent.b),'LineWidth', 2)
catch
    sprintf('fitting event state failed')
end
set(h(1), 'EdgeColor', 'b', 'DisplayName', 'Ground')
set(h(2), 'EdgeColor', 'r', 'DisplayName', 'Event')

legend('Location', 'NorthEast')
axis tight
xlabel('Time [s]'); ylabel('Frequency');

end
function ensembleWinAnalysis(ax)

h = getappdata(1, 'handles');
v = getappdata(1, 'values');

w = str2double(get(h(47),'string'));

ymin = inf; ymax = -inf;
good = find(v.track & v.trackActiv);
for N = good
    [nrSeg idxSeg ptsSeg lifeTime] =...
        segmentTrack(v.data{N}(:,3),w);
    
    x{N,1} = accumarray(1+v.data{N}(:,3)-v.data{N}(1,3),...
        v.data{N}(:,1),[lifeTime 1],[],nan);
    y{N,1} = accumarray(1+v.data{N}(:,3)-v.data{N}(1,3),...
        v.data{N}(:,2),[lifeTime 1],[],nan);
    frame = (1:lifeTime)';
    
    [data{N} take{N}] =...
        evalLocalDiff(...
        x{N},...
        y{N},...
        frame,...
        w,...
        nrSeg,...
        idxSeg,...
        v.settings.Delay,...
        v.px2micron);
    ymin = min(min(data{N}(take{N})),ymin);
    ymax = max(max(data{N}(take{N})),ymax);
    
end %for

cmap = jet(256);
set(ax,...
    'CLim', [ymin ymax],...
    'Fontsize', 15);

for N = good
    take{N} = find(take{N});
    
    [unused cIdx{N}] = histc(data{N}(take{N}),...
        linspace(ymin,ymax,256));
    
    %plot trajectory            
    hLine{N} = plot([x{N}(take{N}),x{N}([take{N}(2:end) take{N}(end)+1])]',...
        [y{N}(take{N}),y{N}([take{N}(2:end) take{N}(end)+1])]',...
        'Parent', ax(1));
end
hLine = vertcat(hLine{:});
    set(hLine,{'Color'},mat2cell(cmap(horzcat(cIdx{:}),:),...
        ones(numel(horzcat(take{:})),1),3))
end

function trackWinAnalysis(src,event,x,y,frame,w,lagTime,px2micron,trueBinary)
h = getappdata(1, 'handles');

w = str2double(get(h(47),'string'));
yThresh = str2double(get(h(48),'string'));

[nrSeg idxSeg ptsSeg lifeTime w] = segmentTrack(frame,w);

x = accumarray(1+frame-frame(1),x,[lifeTime 1],[],nan);
y = accumarray(1+frame-frame(1),y,[lifeTime 1],[],nan);
frame = (1:lifeTime)';

[data take] =...
    evalLocalDiff(...
    x,...
    y,...
    frame,...
    w,...
    nrSeg,...
    idxSeg,...
    lagTime,...
    px2micron);

%         plot(x,y,'k')
%     [unused cIdx] = histc(log(Dlocal(2,:)),...
%         linspace(min(log(Dlocal(2,:))),...
%         max(log(Dlocal(2,:))),256));
%     seg = 1;
%                hSeg = plot(x(idxSeg(:,seg)),y(idxSeg(:,seg)),...
%                'Color', cmap(cIdx(seg),:),...
%                'LineWidth', 2);
%     while ishandle(hfig)
%            seg = seg+1;
%            set(hSeg,...
%                'XData', x(idxSeg(:,seg)),...
%                'YData', y(idxSeg(:,seg)),...
%                'Color', cmap(cIdx(seg),:))
%            pause(0.01)
%            if seg == nrSeg
%                seg = 0;
%            end
%     end %for

% data = [data{:}];
% take = logical([take{:}]);
take = find(take);
ymin = min(data(take));
ymax = max(data(take));

cmap = jet(256);
[unused cIdx] = histc(data(take),...
    linspace(ymin,ymax,256));

figure(...
    'Color', get(0,'defaultUicontrolBackgroundColor'));
ax(1) = axes(...
    'OuterPosition', [0 0.3 1 0.7],...
    'CLim', [ymin ymax],...
    'Fontsize', 15);

ax(2) = axes(...
    'OuterPosition', [0 0 1 0.3],...
    'NextPlot', 'add',...
    'Fontsize', 15);

%plot trajectory
hLine = line(px2micron*[x(take),x([take(2:end) take(end)+1])]',...
    px2micron*[y(take),y([take(2:end) take(end)+1])]',...
    'Parent', ax(1));
set(hLine,{'Color'},mat2cell(cmap(cIdx,:),...
    ones(numel(take),1),3))
axis(ax(1),'image', 'ij')
xlabel(ax(1), 'x Position [?m]')
ylabel(ax(1), 'y Position [?m]')

%generate colorbar
x = [zeros(1,256); ones(1,256)*lifeTime-2];
y = repmat(linspace(min(data(take)),...
    max(data(take)),256),2,1);
vertices = [x(:) y(:) zeros(512,1)];
face = repmat([1 3 4 2],255,1)+...
    repmat((0:2:508)',1,4);

patch('Faces',face,'Vertices',vertices,...
    'FaceVertexCData', jet(255),...
    'FaceColor', 'flat',...
    'FaceAlpha', 0.5,...
    'EdgeColor', 'none',...
    'Parent', ax(2));

%plot running window analysis
plot(take,data(take),...
    'Color', [0 0 0],...
    'LineWidth', 2,...
    'Parent', ax(2))

dataBinary(data(take) >= yThresh) = ymax;
dataBinary(data(take) < yThresh) = ymin;
stairs(take,dataBinary,...
    'Color', [0.75 0 0.75],...
    'LineWidth', 2,...
    'LineStyle', '-',...
    'Parent', ax(2))

%show simulated state sequence
% trueBinary = trueBinary(take);
% trueBinary(trueBinary == 1) = ymax;
% trueBinary(trueBinary == 2) = ymin;
% stairs(take,trueBinary,...
%     'Color', [1 1 0],...
%     'LineWidth', 3,...
%     'LineStyle', '--',...
%     'Parent', ax(2))

axis(ax(2),'tight')
xlabel(ax(2), 'Position')
ylabel(ax(2), 'D(local) [?m^2/s]')

%Dlocal(ptsSeg < w/2) = nan; %discard if less than w/2 ponts inside w
end
function [output, take] =...
    evalLocalDiff(x,y,frame,w,nrSeg,idxSeg,lagTime,px2micron)

%Calculates the local Diffusion inside moving timewindow
%
%
% INPUT:
%           x (Vector; x-coordinates [px])
%           y (Vector; y-coordinates [px])
%           lagTime(scalar; [s])
%           w (scalar; calculation Window [Frames])
%
% OUTPUT:
%           D (Vector of Diffusion Coefficients)
%
% written by C.P.Richter
% version 10.06.12

iMat = repmat(idxSeg(:,1),1,w);
good = tril(true(w),-1);
ii = iMat(good);
iii = iMat(flipud(good));

iSeg = repmat(0:nrSeg-1,sum(idxSeg(1:end-1,1)),1);
ii = repmat(ii,1,nrSeg)+iSeg;
iii = repmat(iii,1,nrSeg)+iSeg;

for moment = 2
    sd = ((x(ii)-x(iii)).^moment +...
        (y(ii)-y(iii)).^moment)*px2micron^moment;
    stepLength = frame(ii)-frame(iii);
    
    stepLength = stepLength(w:6*w-21,:); %analyse 2:6 steps
    sd = sd(w:6*w-21,:);
    
    subs = bsxfun(@plus,stepLength,0:5:(nrSeg-1)*5)-1;
    mmd = reshape(accumarray(subs(:),...
        sqrt(sd(:).^2),[],@nanmean), 5, nrSeg);
    %     t = 4*(2:6)'*lagTime;
    
    t = [ones(5,1) log(4*(2:6)*lagTime)'];
    % mean moment displacement = Dlocal*4t^AnomalousCoeff
    yHat = t\log(mmd);
    Dlocal(moment,:) = exp(yHat(1,:));
    AnomalousCoeff(moment,:) = yHat(2,:);
    
    %     for seg = 1:nrSeg
    %     result = fit(4*(2:6)'*lagTime,mmd(:,seg),'power2');
    %     fitPower2(:,seg) = coeffvalues(result);
    %     result = fit(4*(2:6)'*lagTime,mmd(:,seg),'poly1');
    %     fitLin(:,seg) = coeffvalues(result);
    %
    %     fig = figure;
    %     hold on
    %     title(num2str(seg))
    %     plot(4*(2:6)'*lagTime,mmd(:,seg),'ko')
    %     plot(4*(2:6)'*lagTime,...
    %         4*fitLin(1,seg)*(2:6)'*lagTime+fitLin(2,seg),'g-')
    %     plot(4*(2:6)'*lagTime,...
    %         Dlocal(moment,seg)*(4*(2:6)'*lagTime).^AnomalousCoeff(moment,seg),'b-')
    %     plot(4*(2:6)'*lagTime,...
    %         fitPower2(1,seg)*(4*(2:6)'*lagTime).^fitPower2(2,seg)+fitPower2(3,seg),'r-')
    %     waitforbuttonpress
    %     delete(fig)
    %     end %for
    
    %     SST = sum(bsxfun(@minus,log(mmd),...
    %         mean(log(mmd))).^2);
    %     SSR = sum((log(mmd)-...
    %         t*yHat).^2);
    %     Rsquare = 1-SSR./SST;
    %     Dlocal(moment,Rsquare < 0.9) = nan;
    
end

%calculate degree of self similarity
%     mss = [ones(5,1) (1:5)']\AnomalousCoeff;
%
%     SST = sum(bsxfun(@minus,AnomalousCoeff,...
%         mean(AnomalousCoeff)).^2);
%     SSR = sum((AnomalousCoeff-...
%         [ones(5,1) (1:5)']*mss).^2);
%     Rsquare = 1-SSR./SST;

mode = 'Local Diff. Coeff.';
switch mode
    case 'Local Diff. Coeff.'
        datasrc = log10(Dlocal(moment,:));
    case 'AnomalousCoeff'
        datasrc = AnomalousCoeff(2,:);
    case 'Rsquare Statistics'
        datasrc = Rsquare;
end

jump = idxSeg(w/2,1);
while isnan(x(jump))
    jump = jump -1;
end
jumpEnd = 1;
while jump < idxSeg(w/2,end)+1
    while isnan(x(jump+jumpEnd)-x(jump))
        jumpEnd = jumpEnd+1;
    end
    [unused good] = find(any(ismember(idxSeg,...
        jump:jump+jumpEnd-1)));
    output(jump) = nanmedian(datasrc(good));
    
    jump = jump+jumpEnd;
    jumpEnd = 1;
end %for
output = [output zeros(1,w/2)];
take = output ~= 0;
end
function PlayMovie(src,event,trackID,filter,v,h)
h = getappdata(1, 'handles');
%v = getappdata(1, 'values');

 ext ='.mldatx_tracked.mat';

           k = strfind(get(h(2),'String'),ext);
           fileTrait=h(2).String;
            FName=fileTrait(1:k-1);
             
 MyFile=[FName,'.tif'];
 [pathname,filename , ext] =fileparts(MyFile);

 if ~isfile( MyFile)
     warningMessage = sprintf('Warning: file does not exist:\n%s', MyFile);
     uiwait(errordlg(warningMessage));
     [filename, pathname, isOK] = uigetfile(...
         '*.tif', 'Select Background Images',...
         getappdata(1,'searchPath'));
     
 else
     setappdata(1,'searchPath',pathname)
     
     fig =...
        figure(...
        'Tag', 'figBuildTrackMovie',...
        'Units','normalized',...
        'Position', [0.25 0.25 0.5 0.5],...
        'Color', get(0,'defaultUicontrolBackgroundColor'),...
        'Name', 'Track Movie',...
        'NumberTitle', 'off',...
        'MenuBar', 'none',...
        'ToolBar', 'none');
    ax =...
        axes(...
        'Tag', 'axBuildTrackMovie',...
        'Units','normalized',...
        'Position', [0 0 1 1],...
        'NextPlot','add');
    
    
    
min([v.data{trackID}(:,1)])
    xmin = max(floor(min([v.data{trackID}(:,1)]))-10,1);
    xmax = ceil(max([v.data{trackID}(:,1)]))+10;
    ymin = max(floor(min([v.data{trackID}(:,2)]))-10,1);
    ymax = ceil(max([v.data{trackID}(:,2)]))+10;
    startPnt = v.data{trackID}(1,3);
    endPnt = v.data{trackID}(end,3);
    
    %initialize movie
    raw = double(imread(MyFile,startPnt,...
        'PixelRegion', {[ymin ymax],[xmin xmax]}));
    if get(filter,'Value')
        raw = wiener2(raw);
    end %if
    
    hIm = imshow(raw,[min(raw(:)) max(raw(:))],...
        'Parent',ax);
 axis 'tight'
    
    hLine = line(v.data{trackID}(v.data{trackID}(:,3)<=startPnt,1)-xmin+2,...
        v.data{trackID}(v.data{trackID}(:,3)<=startPnt,2)-ymin+2,...
        'Parent', ax, 'Color', [1 0 0], 'LineWidth', 2,'Marker','.','MarkerSize',3,'MarkerEdgeColor','r');
    
    colormap gray
   
    %axis image
    drawnow
    mov(1) = getframe(ax);
   fps = 4;
    for frame = startPnt+1:endPnt
        raw = double(imread(MyFile,frame,...
            'PixelRegion', {[ymin ymax],[xmin xmax]}));
        if get(filter,'Value')
            %raw = wiener2(raw);
             raw = imgaussfilt(raw);
        end %if
        
        set(hIm,'CData',raw)
        set(hLine,'XData',v.data{trackID}(v.data{trackID}(:,3)<=frame,1)-xmin+2,...
            'YData',v.data{trackID}(v.data{trackID}(:,3)<=frame,2)-ymin+2)
       
        drawnow
     
        mov(frame-startPnt+1) = getframe(ax);
          
    end %for
   
    fps = 4;
    while ishandle(fig)
        cla
       
        movie(ax,mov,3,fps)
        
        %fps = abs(fps - 6);
    end
    
%     answer = questdlg('Save to Disk?','','Yes','No','No');
%     if strcmp(answer,'Yes')
%         [filename,pathname,isOK] =...
%             uiputfile('.tif' ,'Save Track Movie',...
%             [pathname filename(1:end-4)...
%             '_track_' num2str(trackID) '.tif']);
%         if isOK
%             for frame = 1:numel(mov)
%                 imwrite(mov(frame).cdata,[pathname filename],...
%                     'compression','none','writemode','append')
%             end %for
%         end %if
%     end %if
end %if
    end
 
   function SaveMovie(src,event,trackID,filter,v,h)
h = getappdata(1, 'handles');
%v = getappdata(1, 'values');

 ext ='.mldatx_tracked.mat';

           k = strfind(get(h(2),'String'),ext);
           fileTrait=h(2).String;
            FName=fileTrait(1:k-1);
             
 MyFile=[FName,'.tif'];
 [pathname,filename , ext] =fileparts(MyFile);
% [filename, pathname, isOK] = uigetfile(...
%     '*.tif', 'Select Background Images',...
%     getappdata(1,'searchPath'));
if  isfile( MyFile)
    setappdata(1,'searchPath',pathname);
    
    fig =...
        figure(...
        'Tag', 'figBuildTrackMovie',...
        'Units','normalized',...
        'Position', [0.25 0.25 0.5 0.5],...
        'Color', get(0,'defaultUicontrolBackgroundColor'),...
        'Name', 'Track Movie',...
        'NumberTitle', 'off',...
        'MenuBar', 'none',...
        'ToolBar', 'none');
    ax =...
        axes(...
        'Tag', 'axBuildTrackMovie',...
        'Units','normalized',...
        'Position', [0 0 1 1],...
        'NextPlot','add');
min([v.data{trackID}(:,1)])
    xmin = max(floor(min([v.data{trackID}(:,1)]))-10,1);
    xmax = ceil(max([v.data{trackID}(:,1)]))+10;
    ymin = max(floor(min([v.data{trackID}(:,2)]))-10,1);
    ymax = ceil(max([v.data{trackID}(:,2)]))+10;
    startPnt = v.data{trackID}(1,3);
    endPnt = v.data{trackID}(end,3);
    
    %initialize movie
    raw = double(imread(MyFile,startPnt,...
        'PixelRegion', {[ymin ymax],[xmin xmax]}));
    if get(filter,'Value')
        raw = wiener2(raw);
    end %if
    
    hIm = imshow(raw,[min(raw(:)) max(raw(:))],...
        'Parent',ax);
    
    hLine = line(v.data{trackID}(v.data{trackID}(:,3)<=startPnt,1)-xmin+2,...
        v.data{trackID}(v.data{trackID}(:,3)<=startPnt,2)-ymin+2,...
        'Parent', ax, 'Color', [1 0 0], 'LineWidth', 3);
    
    colormap gray
    axis image
    drawnow
    mov(1) = getframe(ax);
  
    for frame = startPnt+1:endPnt
        raw = double(imread(MyFile,frame,...
            'PixelRegion', {[ymin ymax],[xmin xmax]}));
        if get(filter,'Value')
            raw = wiener2(raw);
        end %if
        
        set(hIm,'CData',raw)
        set(hLine,'XData',v.data{trackID}(v.data{trackID}(:,3)<=frame,1)-xmin+2,...
            'YData',v.data{trackID}(v.data{trackID}(:,3)<=frame,2)-ymin+2)
        drawnow
        
        mov(frame-startPnt+1) = getframe(ax);
    end %for
    
    fps = 20;
    while ishandle(fig)
        cla
        movie(ax,mov,3,fps)
        fps = abs(fps - 6);
    end
    
    answer = questdlg('Save to Disk?','','Yes','No','No');
    if strcmp(answer,'Yes')
        [filename,pathname,isOK] =...
            uiputfile('.tif' ,'Save Track Movie',...
            [pathname filename(1:end-4)...
            '_track_' num2str(trackID) '.tif']);
        if isOK
            for frame = 1:numel(mov)
                imwrite(mov(frame).cdata,[pathname filename],...
                    'compression','none','writemode','append')
            end %for
        end %if
    end %if
end %if
    end



function analyseDiffusionOne(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values');

varList = {...
    'CDF(radius^2)',...
    'CDF(probability)',...
    'fitted CDF(radius^2)',...
    'fitted CDF(probability)',...
    'mobile Fractions + Err',...
    'Timevector',...
    'max MSDs + Err',...
    'fit D(upper limit)',...
    'D(upper limit) + Err',...
    'D(upper limit) Residuals',...
    'mobile MSDs + Err',...
    'fit D(short range)',...
    'D(short range) + Err',...
    'D(short range) Residuals',...
    'fit D(long range)',...
    'D(long range) + Err',...
    'D(long range) Residuals',...
    'immobile MSDs + Err',...
    'fit D(immobile)',...
    'D(immobile) + Err',...
    'D(immobile) Residuals'};

shortRange = str2double(get(h(27), 'String')):...
    str2double(get(h(28), 'String'));
longRange = str2double(get(h(30), 'String')):...
    str2double(get(h(31), 'String'));

if get(h(29), 'Value') %long range diffusion checked
    steps2analyse = longRange;
else
    steps2analyse = shortRange;
end %if

[singleTrackSD maxSD unused stepLength] =...
    calcSD(find(v.track & v.trackActiv), 1, 0);

stepLength = vertcat(stepLength{:});
singleTrackSD = vertcat(singleTrackSD{:});

%preallocate space
P = cell(1,max(steps2analyse));
rsquare = cell(1,max(steps2analyse));
fitPar = zeros(max(steps2analyse),3);
fitParErr = zeros(max(steps2analyse),3);

hProgressbar = waitbar(0,'Calculating  Diffusion Constant','Color',...
    get(0,'defaultUicontrolBackgroundColor'));
for step = steps2analyse
    
    % calculating probability for increasing square displacements
    [P{step},rsquare{step}] = ecdf(singleTrackSD(stepLength == step));
    
    % fitting P vs. rsquare (Sch?tz et al. 1997, Biophys. J. 73:1073-1080)
    %     s = fitoptions('Method', 'NonlinearLeastSquares',...
    %         'Lower',[0,0,0],...
    %         'Upper', [1,Inf,Inf],...
    %         'StartPoint', [0.5 0.01 0.001],...
    %         'Robust', 'on');
    
    %     f = fittype('1-(a*exp(-x/b)+(1-a)*exp(-x/c))',...
    %         'options', s,...
    %         'independent', 'x');
    %
    %     fitMSD = fit (rsquare{step},P{step},f);
    %     fitPar(step,1:3) = coeffvalues(fitMSD);
    %     fitParErr(step,1:3) = diff(confint(fitMSD,0.68))/2;
    
    s = fitoptions('Method', 'NonlinearLeastSquares',...
        'Lower',[0],...
        'Upper', [inf],...
        'StartPoint', [5],...
        'Robust', 'on');
    
    f = fittype('1-(exp(-x/b))',...
        'options', s,...
        'independent', 'x');
    
    fitMSD = fit (rsquare{step},P{step},f);
    fitPar(step,2) = coeffvalues(fitMSD);
    fitParErr(step,2) = diff(confint(fitMSD,0.68))/2;
    
    fitSampling{step,1} = linspace(min(rsquare{step}),max(rsquare{step}),1000);
    yCumFit{step} = feval(fitMSD,fitSampling{step,1});
    
    %     modelfun = @(x,a,b,c) 1-(a*exp(-x/b)+...
    %         (1-a)*exp(-x/c));
    %     [hypo(step),prob(step),stats] = chi2gof(...
    %         singleTrackSD(stepLength == step),...
    %         'cdf', {modelfun,fitMSD.a,fitMSD.b,fitMSD.c},...
    %         'nparams', 3, 'nbins', 100);
    
    waitbar(step/max(steps2analyse),hProgressbar,...
        'Calculating Diffusion Constant','Color',...
        get(0,'defaultUicontrolBackgroundColor'));
end %for
delete(hProgressbar)

dt = (1:step)'*v.settings.Delay;

fig =...
    figure(...
    'Units', 'normalized',...
    'Position', [0 0 1 1],...
    'MenuBar', 'none',...
    'ToolBar', 'figure',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'Name', 'Two Fraction Diffusion Fit',...
    'NumberTitle', 'off');

hToolBar = findall(fig,'Type','uitoolbar');
hToggleList = findall(hToolBar);
delete(hToggleList([2 3 5 6 7 9 10 16 17]))

hSub(1) =...
    axes(...
    'position',[0.1 0.4 0.8 0.5],...
    'FontSize', 15,...
    'NextPlot', 'add',...
    'XTickLabel', '');

% calculating diffusion constant with mean maximum excursion model
maxSD = padcat(maxSD{v.track & v.trackActiv});
meanMaxSD = nanmean(maxSD,2);
stdMaxSD = nanstd(maxSD,[],2);
[Dmax DmaxStats] = robustfit(4*dt(shortRange),meanMaxSD(shortRange));
yDmaxFit = 4*Dmax(2)*dt+Dmax(1);
if get(h(32), 'Value')
    %     hPlot = errorbar(dt(shortRange),meanMaxSD(shortRange),...
    %             stdMaxSD(shortRange),'ko');
    hPlot = plot(dt,yDmaxFit,'m--');
    set(hPlot, 'DisplayName', ['upper diffusion limit: D = ' num2str(Dmax(2),'%.3f')...
        ' \pm ' num2str(DmaxStats.se(2),'%.3f') '?m^2/s; c = '...
        num2str(Dmax(1),'%.3f') '?m^2'])
end

% calculating max diffusion constant
[fitShortRange shortRangeStats] = robustfit(4*dt(shortRange),...
    fitPar(shortRange,2));
DiffCoeffResiduals = shortRangeStats.resid;
yDshortFit = 4*fitShortRange(2)*dt+fitShortRange(1);

if get(h(26), 'Value') %short range diffusion checked
    if ~get(h(29), 'Value')
        hPlot = errorbar(dt(shortRange),fitPar(shortRange,2),...
            fitParErr(shortRange,2),'ko');
        set(hPlot, 'DisplayName', [num2str(mean(fitPar(shortRange))*100,...
            '%.1f') ' \pm ' num2str(std(fitPar(shortRange))*100,'%.1f') '% mobile'])
    end %if
    hPlot = plot(dt,yDshortFit,'b');
    set(hPlot, 'DisplayName', ['short range diffusion: D = '...
        num2str(fitShortRange(2),'%.3f')...
        ' \pm ' num2str(shortRangeStats.se(2),'%.3f') '?m^2/s; c = '...
        num2str(fitShortRange(1),'%.3f') '?m^2'])
end %if

switch get(h(33), 'Value')
    case 1
        % calculating diffusion constant with normal diffusion model
        s = fitoptions('Method', 'LinearLeastSquares',...
            'Lower', [0,0],...
            'Robust', 'on');
        
        f = fittype({'4*t','1'},...
            'coefficients', {'D','c'},...
            'options', s,...
            'independent', 't');
        
        [fitDiffusion, statsDiffusion, outputDiffusion] = ...
            fit(dt(steps2analyse),fitPar(steps2analyse,2),f);
        DiffCoeffStd = diff(confint(fitDiffusion,0.68))/2;
        yDlongFit = 4*fitDiffusion.D*dt+fitDiffusion.c;
        
        if get(h(29), 'Value') %long range diffusion checked
            DiffCoeffResiduals = outputDiffusion.residuals;
            
            hPlot(1) = errorbar(dt(longRange),fitPar(longRange,2),...
                fitParErr(longRange,2),'ko');
            hPlot(2) = plot(dt,yDlongFit,'r');
            set(hPlot(1), 'DisplayName', [num2str(mean(fitPar(longRange,1)*100),'%.1f')...
                ' \pm ' num2str(std(fitPar(longRange))*100,'%.1f') '% mobile'])
            set(hPlot(2), 'DisplayName', ['long range diffusion: D = ' num2str(fitDiffusion.D,'%.3f') ' \pm '...
                num2str(DiffCoeffStd(1),'%.3f') '?m^2/s; c = ' num2str(fitDiffusion.c,'%.3f')...
                '?m^2'])
        end
    case 2
        % calculating diffusion constant with anonmalous diffusion model
        s = fitoptions('Method', 'NonlinearLeastSquares',...
            'Lower', [0,0,-Inf],...
            'Upper', [Inf,1,Inf],...
            'StartPoint', [1, 0.5, 0],...
            'Robust', 'on');
        
        f = fittype('4*D*t^a+c',...
            'options', s,...
            'independent', 't');
        
        [fitDiffusion, statsDiffusion, outputDiffusion] = ...
            fit(dt(steps2analyse),fitPar(steps2analyse,2),f);
        
        DiffCoeffStd = diff(confint(fitDiffusion,0.68))/2;
        yDlongFit = 4*fitDiffusion.D*dt.^fitDiffusion.a+fitDiffusion.c;
        
        if get(h(29), 'Value') %long range diffusion checked
            DiffCoeffResiduals = outputDiffusion.residuals;
            
            hPlot(1) = errorbar(dt(longRange),fitPar(longRange,2),...
                fitParErr(longRange,2),'ko');
            hPlot(2) = plot(dt,yDlongFit,'r');
            set(hPlot(1), 'DisplayName', [num2str(mean(fitPar(longRange,1)*100),'%.1f') '% mobile'])
            set(hPlot(2), 'DisplayName', ['long range diffusion: D = ' num2str(fitDiffusion.D,'%.3f') ' \pm '...
                num2str(DiffCoeffStd(1),'%.3f') '?m^2/s; ' '\alpha = ' num2str(fitDiffusion.a,'%.3f')...
                '; c = ' num2str(fitDiffusion.c,'%.3f') '?m^2'])
        end
    case 3
        % calculating diffusion constant with Transport model
        s = fitoptions('Method', 'NonlinearLeastSquares',...
            'Lower', [0,0],...
            'Upper', [Inf,1],...
            'StartPoint', [1 .5],...
            'Robust', 'on');
        
        f = fittype('4*D*t+(V*t)^2',...
            'options', s,...
            'independent', 't');
        
        [fitDiffusion, statsDiffusion, outputDiffusion] = ...
            fit(dt(steps2analyse),fitPar(steps2analyse,2),f);
        
        DiffCoeffStd = diff(confint(fitDiffusion,0.68))/2;
        DiffCoeffV = fitDiffusion.V;
        yDlongFit = 4*fitDiffusion.D*dt+(fitDiffusion.V*dt).^2;
        
        if get(h(29), 'Value') %long range diffusion checked
            DiffCoeffResiduals = outputDiffusion.residuals;
            
            hPlot(1) = errorbar(dt(longRange),fitPar(longRange,2),...
                fitParErr(longRange,2),'ko');
            hPlot(2) = plot(dt,yDlongFit,'r-');
            set(hPlot(1), 'DisplayName', [num2str(mean(fitPar(longRange,1)*100),'%.1f') '% mobile'])
            set(hPlot(2), 'DisplayName', ['long range diffusion: D = ' num2str(fitDiffusion.D,'%.3f') ' \pm '...
                num2str(DiffCoeffStd(1),'%.3f') '?m^2/s; V = ' num2str(DiffCoeffV,'%.3f')...
                '?m/s'])
        end
        
    otherwise
end %switch

% calculating diffusion constant with normal diffusion model
[immobileD immobileDstats] = robustfit(4*dt(steps2analyse),fitPar(steps2analyse,3));

hPlot = errorbar(dt(steps2analyse),fitPar(steps2analyse,3),...
    fitParErr(steps2analyse,3),'ko');
set(hPlot, 'DisplayName', [num2str(100-mean(fitPar(steps2analyse,1)*100),'%.1f') '% immobile'])
yDimmFit = 4*immobileD(2)*dt+immobileD(1);
hPlot = plot(dt,yDimmFit,'g');
set(hPlot, 'DisplayName', ['immobile: D = ' num2str(immobileD(2),'%.3f')...
    ' \pm ' num2str(immobileDstats.se(2),'%.3f') '?m^2/s; c = ' num2str(immobileD(1),'%.3f') '?m^2'])

hold off
ylabel('MSD [?m^2]');
% axis(axis.*[0 1 1 1])

legend('Location', 'NorthWest');

% plot residues of mobile
hSub(2) =...
    axes(...
    'position',[0.1 0.1 0.8 0.2],...
    'FontSize', 15);

stem(hSub(2),dt(steps2analyse), DiffCoeffResiduals)

% [ax, h1, h2] = plotyy(dt(steps2analyse), DiffCoeffResiduals,...
%     dt(steps2analyse), prob(steps2analyse), 'stem', 'plot');
% set(ax, 'FontSize', 15)
% ylabel(ax(1), 'Residuals'); ylabel(ax(2), 'p-value (X^2 test)')
% set(h2, 'LineStyle', ':', 'Marker', 'o')

xlabel('Time [s]'); ylabel('Residuals')
linkaxes(hSub, 'x')

% temp = accumarray(stepLength,singleTrackSD,[],@(x){x});
toExport = {...
    padcat(rsquare{:}),...
    padcat(P{:}),...
    padcat(fitSampling{:})',...
    padcat(yCumFit{:}),...
    [fitPar(:,1) fitParErr(:,1)],...
    dt,...
    [meanMaxSD stdMaxSD],...
    yDmaxFit,...
    [Dmax(2) DmaxStats.se(2); Dmax(1) DmaxStats.se(1)],...
    DmaxStats.resid,...
    [fitPar(:,2) fitParErr(:,2)],...
    yDshortFit,...
    [fitShortRange(2) shortRangeStats.se(2); fitShortRange(1) shortRangeStats.se(1)],...
    shortRangeStats.resid,...
    yDlongFit,...
    [fitDiffusion.D DiffCoeffStd(1); fitDiffusion.c DiffCoeffStd(2)],...
    DiffCoeffResiduals,...
    [fitPar(:,3) fitParErr(:,3)],...
    yDimmFit,...
    [immobileD(2) immobileDstats.se(2); immobileD(1) immobileDstats.se(1)],...
    immobileDstats.resid};
bad = [];
if ~get(h(32), 'Value')
    bad = [bad 7 8 9 10];
end
if ~get(h(26), 'Value')
    bad = [bad 12 13 14];
end
if ~get(h(29), 'Value')
    bad = [bad 15 16 17];
end
if ~isempty(bad)
    varList(bad) = [];
    toExport(bad) = [];
end
uipushtool(hToolBar,...
    'CData', v.xlsExportIcon,...
    'ClickedCallback', {@varExport, fig, varList})

setappdata(fig, 'variables', toExport)
%     function fx = schuetzModel(x,a,b,c)
%         fx = 1-(a*exp(-x/b)+(1-a)*exp(-x/c));
%     end
end
function analyseDiffusionTwo(src, event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')

[singleTrackSD unused unused stepLength] =...
    calcSD(find(v.track & v.trackActiv), 0, 0);
stepLength = vertcat(stepLength{:});
singleTrackSD = sqrt(vertcat(singleTrackSD{:}));

switch get(h(36), 'Value')
    case 1
        steps2analyse = str2double(get(h(37), 'String'));
        varList = {...
            'Diff. Constants + Err',...
            'Fractions + Err',...
            'Timestep',...
            'PDF(radius)',...
            'PDF(probability)',...
            'fitted Curve(radius)',...
            'fitted SumCurve(probability)'};
    case 2
        steps2analyse = str2double(get(h(38), 'String')):...
            str2double(get(h(39), 'String'));
        varList = {...
            'Diff. Constants + Err',...
            'Fractions + Err',...
            'Timevector',...
            'PDF(radius)',...
            'PDF(probability)',...
            'fitted Curve(radius)',...
            'fitted SumCurve(probability)'};
end %switch
fractions = str2double(get(h(40), 'String'));
for n = 1:fractions
    varList = [varList cellstr(['fitted Curve(fraction' num2str(n) ')'])];
end %for

fig =...
    figure(...
    'Units', 'normalized',...
    'Position', figPos(1),...
    'ToolBar', 'figure',...
    'MenuBar', 'none',...
    'Color', get(0,'defaultUicontrolBackgroundColor'),...
    'Name', 'Multiple Fraction Diffusion Fit',...
    'NumberTitle', 'off');

hToolBar = findall(fig,'Type','uitoolbar');
hToggleList = findall(hToolBar);
delete(hToggleList([2 3 5 6 7 8 9 10 13 14 16 17]))

uipushtool(hToolBar,...
    'CData', v.xlsExportIcon,...
    'ClickedCallback', {@varExport, fig, varList})

bins = str2double(get(h(41), 'String'));
cmap = lines(fractions);

%preallocate
[x,y] = deal(cell(steps2analyse(end),1));
fitPar = zeros(steps2analyse(end),2*fractions);
fitParErr = zeros(steps2analyse(end),2*fractions);
% hypo = zeros(steps2analyse(end),1);
% prob = zeros(steps2analyse(end),1);

for step = steps2analyse
    %     [P{step},r{step}] = ecdf(singleTrackSD(stepLength == step));
    %     [y{step}, x{step}] = ecdfhist(P{step},r{step},bins);
    %     [y{step}, x{step}] = hist(singleTrackSD(stepLength == step),...
    %         linspace(0,max(singleTrackSD(stepLength == step)),bins));
    %     y{step} = y{step}/sum(y{step}*(x{step}(2)-x{step}(1)));
    %
    [y{step}, x{step}] = ksdensity(singleTrackSD(stepLength == step),...
        linspace(0,max(singleTrackSD(stepLength == step)),bins));
    
    equation = ['((N1/(4*pi*D1*' num2str(v.settings.Delay*step)...
        '))*exp(-x.^2/(4*D1*' num2str(v.settings.Delay*step) '))*2*pi.*x)'];
    
    if fractions > 1
        for n = 2:fractions
            equation = [equation '+((N' num2str(n) '/(4*pi*D' num2str(n) ...
                '*' num2str(v.settings.Delay*step) '))*exp(-x.^2/(4*D' num2str(n)...
                '*' num2str(v.settings.Delay*step) '))*2*pi.*x)'];
        end %for
    end %if
    
    %     startPnt = [0.4 1 0.8 0.2];
    %     lb = [0.25 0.9 0 0];
    %     ub = [0.45 1.5 1 1];
    %     s = fitoptions('Method', 'NonlinearLeastSquares',...
    %         'Lower', lb,...
    %         'Upper', ub,...
    %         'StartPoint', startPnt);
    
    s = fitoptions('Method', 'NonlinearLeastSquares',...
        'Lower', zeros(1, fractions*2),...
        'Upper', [repmat(inf, 1, fractions), repmat(1, 1, fractions)],...
        'StartPoint', [10.^-(1:fractions), repmat(1/fractions, 1, fractions)]);
    
    f = fittype(equation,...
        'options', s,...
        'independent', 'x');
    
    %plot results
    
    switch get(h(36), 'Value')
        case 1
            [fitStepLength statsStepLength outputStepLength] =...
                fit(x{step}',y{step}',f);
            fitPar = coeffvalues(fitStepLength);
            fitParErr = diff(confint(fitStepLength,0.68))/2;
            
            %chisquare test
            %             [hypo,prob,stats] = chi2gof(x{step},...
            %                 'ctrs', x{step}, 'frequency', y{step},...
            %                 'expected', feval(fitStepLength,x{step}),...
            %                 'nparams', fractions*2, 'emin', 0);
            
            hSub(1) =...
                axes(...
                'position',[0.1 0.4 0.8 0.5],...
                'FontSize', 15,...
                'NextPlot', 'add');
            
            
            bar(x{step},y{step},'hist');
            
            fitSampling{step,1} = linspace(min(x{step}),max(x{step}),bins*10);
            ySumFit{step} = feval(fitStepLength,fitSampling{step,1});
            hPlot = plot(fitSampling{step,1}, ySumFit{step},...
                'color', 'm', 'linewidth', 2);
            
            %             if hypo
            %                 chiTestResult = 'H0 rejected';
            %             else
            %                 chiTestResult = ['H0 accepted, p-Value = ' num2str(prob,'%.1f')];
            %             end %if
            
            set(hPlot, 'DisplayName',...
                sprintf('%s', [num2str(sum(fitPar(fractions+1:2*fractions))*100,...
                '%.1f') '% Sum Function']));
            
            for n = 1:fractions
                yFractionFit{n}{step} = ((fitPar(n+fractions)/(4*pi*fitPar(n)*v.settings.Delay*...
                    step)))*exp(-fitSampling{step,1}.^2/(4*fitPar(n)*v.settings.Delay*...
                    step))*2*pi.*fitSampling{step,1};
                plot(fitSampling{step,1},yFractionFit{n}{step}, 'Color', cmap(n,:),...
                    'linewidth', 2, 'DisplayName',...
                    [num2str(fitPar(n+fractions)*100','%.1f') ' \pm '...
                    num2str(fitParErr(n+fractions)*100','%.1f') '%; D = '...
                    num2str(fitPar(n),'%.3f') ' \pm ' num2str(fitParErr(n),'%.3f') '?m^2/s']);
            end %for
            
            legend('Location', 'NorthEast')
            ylabel('Probability Density'); xlabel('Step Length [?m]');
            
            % plot residues
            hSub(2) =...
                axes(...
                'position',[0.1 0.1 0.8 0.2],...
                'FontSize', 15);
            stem (x{step},outputStepLength.residuals,'Color','r',...
                'DisplayName', ['RMSE = ' num2str(statsStepLength.rmse, '%.3f')])
            legend('Location', 'NorthEast')
            ylabel('Residuals'); xlabel('Step Length [?m]');
            
            linkaxes(hSub,'x')
        case 2
            
            [fitStepLength statsStepLength outputStepLength] = fit(x{step}',y{step}',f);
            fitPar(step,:) = coeffvalues(fitStepLength);
            fitParErr(step,:) = diff(confint(fitStepLength,0.68))/2;
            
            fitSampling{step,1} = linspace(min(x{step}),max(x{step}),bins*10);
            ySumFit{step} = feval(fitStepLength,fitSampling{step,1});
            
            %chisquare test
            %             [hypo(step),prob(step),stats] = chi2gof(x{step},...
            %                 'ctrs', x{step}, 'frequency', y{step},...
            %                 'expected', feval(fitStepLength,x{step}),...
            %                 'nparams', fractions*2, 'emin', 0);
            
            if step == steps2analyse(1)
                ax(1) =...
                    subplot(2,1,1);
                ax(2) =...
                   subplot(2,1,2);
                set(ax, 'NextPlot', 'add',...
                    'FontSize', 15)
            end %if
            
            for n = 1:fractions
                yFractionFit{n}{step} = ((fitPar(step,n+fractions)/(4*pi*fitPar(step,n)*v.settings.Delay*...
                    step)))*exp(-fitSampling{step,1}.^2/(4*fitPar(step,n)*v.settings.Delay*...
                    step))*2*pi.*fitSampling{step,1};
                
                %                 if hypo(step)
                %                     errorbar(ax(1), step*v.settings.Delay,...
                %                         fitPar(step,n), fitParErr(step,n), 'Color', cmap(n,:),...
                %                         'LineStyle', 'none', 'Marker', '*', 'MarkerSize', 15)
                %                     errorbar(ax(2), step*v.settings.Delay, fitPar(step,n+fractions),...
                %                         fitParErr(step,n+fractions), 'Color', cmap(n,:), 'LineStyle', 'none',...
                %                         'Marker', '*', 'MarkerSize', 15)
                %                 else
                errorbar(ax(1), step*v.settings.Delay,...
                    fitPar(step,n), fitParErr(step,n),'Color', cmap(n,:),...
                    'LineStyle', 'none', 'Marker', 'o')
                errorbar(ax(2),step*v.settings.Delay, fitPar(step,n+fractions),...
                    fitParErr(step,n+fractions), 'Color', cmap(n,:), 'LineStyle', 'none',...
                    'Marker', 'o')
                %                 end %if
            end %for
            
            if step == steps2analyse(end)
                ylim([0 1])
                %                 plot(ax(2), steps2analyse*v.settings.Delay, prob(steps2analyse),...
                %                     'Color', 'k', 'Marker', 'x', 'MarkerSize', 15, 'LineStyle', ':')
                plot(ax(2), steps2analyse*v.settings.Delay,...
                    sum(fitPar(steps2analyse,fractions+1:2*fractions),2), 'mo')
                
                ylabel(ax(1), 'D [?m^2/s]'); xlabel(ax(1), 'Time [s]');
                ylabel(ax(2), 'Fraction'); xlabel(ax(2), 'Time [s]');
                linkaxes(ax,'x');
                set(ax, 'YMinorGrid','on')
            end %if
    end %if
    axis tight
end %for
% toExport = {...
%     [fitPar(:,1:fractions) fitParErr(:,1:fractions)],...
%     [fitPar(:,1+fractions:end) fitParErr(:,1+fractions:end)],...
%     steps2analyse'*v.settings.Delay,...
%     padcat(x{:})',...
%     padcat(y{:})',...
%     padcat(fitSampling{:})',...
%     padcat(ySumFit{:})};
% for n = 1:fractions
%     toExport = [toExport padcat(yFractionFit{n}{:})'];
% end %for
% setappdata(fig, 'variables', toExport)
end
function diffCoeffHist(src,event)

h = getappdata(1, 'handles');
v = getappdata(1, 'values')

winSize = str2double(...
    inputdlg(...
    'Window Size [frames]',...
    '',1));

good = find(v.track & v.trackActiv);
[Dlocal AnomalousCoeff] = deal(cell(1,max(good)));
for N = good
    [Dlocal{N} AnomalousCoeff{N}] =...
        calcDlocal(v.data{N}(:,1),...
        v.data{N}(:,2),...
        v.data{N}(:,3),...
        winSize,...
        v.settings.Delay,...
        v.px2micron);
end %for

fig =...
    figure(...
    'Units','normalized',...
    'Position', [0.2 0.2 0.6 0.6],...
    'Name', 'Diffusion Coefficient Distribution',...
    'NumberTitle', 'off',...
    'MenuBar', 'figure',...
    'ToolBar', 'figure');

hToolBar = findall(fig,'Type','uitoolbar');
    uipushtool(...
        'Parent', hToolBar,...
        'CData', repmat(rand(16), [1 1 3]),...
        'ClickedCallback', @excludeByPosteriori)

hToggleList = findall(hToolBar);
delete(hToggleList([2 3 4 5 6 7 8 9 10 13 14 16 17 ]))

ax =...
    axes(...
    'Parent', fig,...
    'Units','normalized',...
    'FontSize', 20,...
    'NextPlot', 'add');

switch get(src, 'String')
    case 'D HISTOGRAM'
        data =  log10(horzcat(Dlocal{:}))';
    otherwise
        data =  horzcat(AnomalousCoeff);
end %switch

[freq, ctrs] = hist(data,...
    linspace(min(data),max(data),150));
% [freq, ctrs] = hist(data,...
%     linspace(min(data),max(data),100));

bar(ctrs,freq,'hist');

options = statset('MaxIter',1000);
fractions = str2double(get(h(40), 'String'));
mixComponents = gmdistribution.fit(data,fractions,...
    'Options', options);

%                                     AIC = zeros(1,fractions);
%                             mixComponents = cell(1,fractions);
%                             for k = 1:fractions
%                                 mixComponents{k} = ...
%                                     gmdistribution.fit(log10(Dlocal),k,...
%                                     'Options', options);
%                                 AIC(k)= mixComponents{k}.AIC;
%                             end
%                             [minAIC,fractions] = min(AIC);
%                             mixComponents = mixComponents{fractions};

%calculate 0.05 alpha threshold for each population
% [prob dD]  = ecdf(data);
% alpha(1) = interp1(prob,dD,0.01)
% alpha(2) = interp1(prob,dD,0.05)
% for fraction = 1:fractions
%     alpha(fraction) = min(norminv(0.05,...
%         mixComponents.mu(fraction),...
%         sqrt(mixComponents.Sigma(fraction))))
% end %for

results = [trapz(ctrs,freq)*mixComponents.PComponents'./...
    sqrt(2*pi*mixComponents.Sigma(:)),...
    mixComponents.mu,...
    sqrt(mixComponents.Sigma(:))];

gauss = @(x,a,b,c) a*exp(-((x-b).^2/(2*c^2)));
ctrsInterp = linspace(min(ctrs),max(ctrs),10*numel(ctrs))';
freqSub = zeros(fractions,numel(ctrsInterp));
for N = 1:fractions
    freqSub(N,:) = gauss(ctrsInterp,...
        results(N,1),results(N,2),results(N,3));
    plot(ax, ctrsInterp, freqSub(N,:), 'r', 'Tag', 'fit',...
        'Displayname', sprintf('%.0f%%; ? = %.2f',...
        mixComponents.PComponents(N)*100,mixComponents.mu(N)))
end %for
plot(ax, ctrsInterp, sum(freqSub,1), 'm', 'Tag', 'fit',...
    'Displayname', 'gaussian mixture model')

% hThresh = line([alpha;alpha],...
%     [zeros(1,fractions); repmat(max(freq),1,fractions)],...
%     'Color', 'k', 'LineWidth', 2);
% hGroup = hggroup;
% set(hThresh, 'Parent', hGroup)
% set(get(get(hGroup,'Annotation'),'LegendInformation'),...
%     'IconDisplayStyle','on');
% set(hGroup,'Displayname', 'threshold (alpha 0.05)')

legend(ax,'show')
axis tight
ylabel('Frequency');

hToolBar = findall(fig,'Type','uitoolbar');
    uipushtool(...
        'Parent', hToolBar,...
        'CData', repmat(rand(16), [1 1 3]),...
        'ClickedCallback',@excludeByPosteriori)

    function excludeByPosteriori(src,event)
       
        h = getappdata(1, 'handles');
        v = getappdata(1, 'values')

        [prob loglike] = posterior(mixComponents,data);
        
        [unused, popIdx] = min(mixComponents.mu);
        v.trackActiv(good(prob(:,popIdx) > 0.05)) = false;
        v.trackList = [];
        
        set(h(8), 'String', ...
            round(sum(v.trackLength(~(v.trackActiv & v.track)))/...
            sum(v.trackLength)*100))
        set(h(19), 'String',...
            cellstr(num2str(transpose(find(v.track & v.trackActiv)))),...
            'Value', 1)
        
        setappdata(1, 'values', v)
    end
end

function confinementAnalysis(src, event)

h = getappdata(1, 'handles');

hconf.type = 'group';
figure(...
    'Units', 'normalized',...
    'Position', [0 0 1 1],...
    'Toolbar', 'figure',...
    'Color', get(0,'defaultUicontrolBackgroundColor'));

h(49) =...
    uipanel(...
    'Position', [0 0 0.3 1]);
% hconf.AxesPanel = uipanel('Position', [0.3 0 0.7 1]);
hconf.Axes =...
    axes(...
    'Parent', gcf,...
    'Position', [0.4 0.1 0.5 0.8]);

setappdata(hconf.Axes, 'showBackground', 0)
setappdata(hconf.Axes, 'showControl', 1)
setappdata(hconf.Axes, 'backgroundType', 'none')

setappdata(hconf.Axes, 'calcWindowVal',7)
setappdata(hconf.Axes, 'confThreshVal',50)
setappdata(hconf.Axes, 'minTimeVal',8)

switch get(h(47), 'Value');
    case 1
        method = 'varM';
    case 2
        method = 'conf';
    otherwise
end %switch
%setappdata(hconf.Axes, 'method', method)

uicontrol(...
    'Parent', h(49),...
    'Style', 'text',...
    'Position', [0.15 0.85 0.7 0.05],...
    'String', 'VV.settings:',...
    'FontSize', 25)

uicontrol(...
    'Parent', h(49),...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [0.15 0.7 0.7 0.05],...
    'String', 'Type:',...
    'FontSize', 15)

uicontrol(...
    'Parent', h(49),...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [0.15 0.38 0.2 0.05],...
    'String', 'Window',...
    'FontSize', 15)

hconf.calcWindowLabel =...
    uicontrol(...
    'Parent', h(49),...
    'Style', 'edit',...
    'Tag' , 'calcWindowLabel',...
    'Units', 'normalized',...
    'Position', [0.2 0.05 0.1 0.05],...
    'String', 7,...
    'FontSize', 10,...
    'Callback', {@setCalcWindowVal, hconf});

uicontrol(...
    'Parent', h(49),...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [0.4 0.38 0.2 0.05],...
    'String', 'Thresh',...
    'FontSize', 15)

hconf.confThreshLabel =...
    uicontrol(...
    'Parent', h(49),...
    'Style', 'edit',...
    'Tag' , 'confThreshLabel',...
    'Units', 'normalized',...
    'Position', [0.45 0.05 0.1 0.05],...
    'String', 50,...
    'FontSize', 10,...
    'Callback', {@setConfThreshVal, hconf});

uicontrol(...
    'Parent', h(49),...
    'Style', 'text',...
    'Units', 'normalized',...
    'Position', [0.65 0.38 0.2 0.05],...
    'String', 'Time',...
    'FontSize', 15)

hconf.minTimeLabel =...
    uicontrol(...
    'Parent', h(49),...
    'Style', 'edit',...
    'Tag' , 'minTimeLabel',...
    'Units', 'normalized',...
    'Position', [0.7 0.05 0.1 0.05],...
    'String', 8,...
    'FontSize', 10,...
    'Callback', {@setMinTimeVal, hconf});

uicontrol(...
    'Parent', h(49),...
    'Style', 'slider',...
    'Tag' , 'calcWindow',...
    'Units', 'normalized',...
    'Position', [0.2 0.1 0.1 0.3],...
    'Max', 100,...
    'Min', 7,...
    'SliderStep', [0.01 0.1],...
    'Value', 7,...
    'Callback', {@setCalcWindowVal, hconf});

uicontrol(...
    'Parent', h(49),...
    'Style', 'slider',...
    'Tag' , 'confThresh',...
    'Units', 'normalized',...
    'Position', [0.45 0.1 0.1 0.3],...
    'Max', 1000,...
    'Min', 1,...
    'SliderStep', [0.001 0.01],...
    'Value', 50,...
    'Callback', {@setConfThreshVal, hconf});

uicontrol(...
    'Parent', h(49),...
    'Style', 'slider',...
    'Tag' , 'minTime',...
    'Units', 'normalized',...
    'Position', [0.7 0.1 0.1 0.3],...
    'Max', 100,...
    'Min', 1,...
    'SliderStep', [0.01 0.1],...
    'Value', 8,...
    'Callback', {@setMinTimeVal, hconf});

uicontrol(...
    'Parent', h(49),...
    'Style', 'popupmenu',...
    'Tag', 'groupConfMapPlotType',...
    'Units', 'normalized',...
    'Position', [0.15 0.5 0.7 0.2],...
    'String', {'Index', 'Trajectory Map', 'Conf. Distribution', 'Diffusion', 'Conf. Lifetime'},...
    'Value', 1,...
    'FontSize', 10,...
    'CreateFcn', {@ConfMapCalc, hconf},...
    'Callback', {@ConfChangePlot, hconf});
end
function setCalcWindowVal(src, event, hconf)

if strcmp(get(src, 'Style'),'edit')
    x = round(str2double(get(src, 'String')));
    if x < 7
        x = 7;
        uiwait(warndlg('Calculation Window must be > 7','Warning','modal'));
    end %if
    set(src, 'String', x)
    setappdata(hconf.Axes, 'calcWindowVal', x)
    set(findobj('Tag', 'calcWindow'), 'Value', x)
else
    x = round(get(src, 'Value'));
    set(src, 'Value', x)
    setappdata(hconf.Axes, 'calcWindowVal', x)
    set(findobj('Tag', 'calcWindowLabel'), 'String', x)
end %if
ConfMapCalc(src, event, hconf)
end
function setConfThreshVal(src, event, hconf)

if strcmp(get(src, 'Style'),'edit')
    x =  str2double(get(src, 'String'));
    setappdata(hconf.Axes, 'confThreshVal', x)
    set(findobj('Tag', 'confThresh'), 'Value', x)
else
    x = round(get(src, 'Value'));
    set(src, 'Value', x)
    setappdata(hconf.Axes, 'confThreshVal', x)
    set(findobj('Tag', 'confThreshLabel'), 'String', x)
end %if
ConfMapUpdate(src, event, hconf)
end
function setMinTimeVal(src, event, hconf)
if strcmp(get(src, 'Style'),'edit')
    x =  str2double(get(src, 'String'));
    setappdata(hconf.Axes, 'minTimeVal', x)
    set(findobj('Tag', 'minTime'), 'Value', x)
else
    x = round(get(src, 'Value'));
    set(src, 'Value', x)
    setappdata(hconf.Axes, 'minTimeVal', x)
    set(findobj('Tag', 'minTimeLabel'), 'String', x)
end %if
ConfMapUpdate(src, event, hconf)
end
function ConfMapCalc(src, event, hconf)
h = getappdata(1, 'handles');
v = getappdata(1, 'values')

switch hconf.type
    case 'group'
        tracks2analyse = find(v.track & v.trackActiv);
        [singleTrackSD  SDmax unused stepLength] = calcSD(tracks2analyse, 1, 0);
        if get(h(46), 'Value')
            ensembleMME = nanmean(padcat(SDmax{tracks2analyse}),2);
            Dmax = 4*(2:6)'*v.settings.Delay\ensembleMME(2:6);
        else
            Dmax = str2double(get(h(45), 'String'));
        end %if
    case 'single'
        %         trackID = get(handles.singleTrackSelected, {'String', 'Value'});
        %         trackID = str2double(cell2mat(trackID{1}(trackID{2})));
        %         tracks2analyse = trackID;
        %         [singleTrackSD  SDmax unused stepLength] = calcSD(tracks2analyse, 1, 0);
        %         ensembleMME = SDmax{tracks2analyse};
end %switch

%preallocate space
[Dlocal iConf refPoint displacement beginConf endConf lengthconf...
    beginFree endFree lengthFree trackListFree trackListConf pntConf pntFree] =...
    deal(cell(numel(tracks2analyse),1));

nrFree = 0; nrConf = 0;
hProgressbar = waitbar(0,'Calculating...','Color',...
    get(0,'defaultUicontrolBackgroundColor'));
for N = tracks2analyse
    Dlocal{N} = calcDlocal(v.data{N}(:,1),...
        v.data{N}(:,2),...
        v.data{N}(:,3),getappdata(hconf.Axes, 'calcWindowVal'),...
        v.settings.Delay, v.px2micron);
    
    [iConf{N} refPoint{N} displacement{N}] = calcConf(Dmax,...
        v.data{N}(:,1), v.data{N}(:,2), v.data{N}(:,3),...
        v.settings.Delay, getappdata(hconf.Axes, 'calcWindowVal'),...
        getappdata(hconf.Axes, 'method'),v.px2micron);
    [beginConf{N} endConf{N} lengthconf{N}...
        beginFree{N} endFree{N} lengthFree{N}] =...
        getConfBounds(iConf{N},getappdata(hconf.Axes, 'confThreshVal'),...
        getappdata(hconf.Axes, 'minTimeVal'));
    
    [trackListFree{N} trackListConf{N} pntFree{N} pntConf{N}] = getConfPeriods(v.data{N},...
        beginConf{N},endConf{N},lengthconf{N},beginFree{N},...
        endFree{N},lengthFree{N},getappdata(hconf.Axes, 'calcWindowVal'),...
        nrFree, nrConf);
    
    nrFree = max(nrFree, trackListFree{N}(end,9));
    nrConf = max(nrConf, trackListConf{N}(end,9));
    
    waitbar(N/numel(tracks2analyse),hProgressbar,...
        'Calculating...','Color',...
        get(0,'defaultUicontrolBackgroundColor'));
end %for
delete(hProgressbar)

control = simBrown(0,0,numel(vertcat(iConf{:})),1,...
    Dmax,v.settings.Delay, v.px2micron);
iConfControl = calcConf(Dmax,...
    control(:,1), control(:,2),...
    control(:,3),v.settings.Delay,...
    getappdata(hconf.Axes, 'calcWindowVal'),...
    getappdata(hconf.Axes, 'method'),v.px2micron);

setappdata(hconf.Axes, 'Dmax', Dmax)
setappdata(hconf.Axes, 'confIndex', iConf)
setappdata(hconf.Axes, 'localD', Dlocal)
setappdata(hconf.Axes, 'refPoint', refPoint)
setappdata(hconf.Axes, 'displacement', displacement)
setappdata(hconf.Axes, 'confControl', iConfControl)
setappdata(hconf.Axes, 'beginConf', beginConf)
setappdata(hconf.Axes, 'endConf', endConf)
setappdata(hconf.Axes, 'lengthconf', lengthconf)
setappdata(hconf.Axes, 'lengthFree', lengthFree)
setappdata(hconf.Axes, 'trackListConf', trackListConf)
setappdata(hconf.Axes, 'trackListFree', trackListFree)
setappdata(hconf.Axes, 'pntConf', pntConf)
setappdata(hconf.Axes, 'pntFree', pntFree)


ConfChangePlot(src, event, hconf)
end
function ConfMapUpdate(src, event, hconf)
v = getappdata(1, 'values')

switch hconf.type
    case 'group'
        tracks2analyse = find(v.track & v.trackActiv);
    case 'single'
        trackID = get(handles.singleTrackSelected, {'String', 'Value'});
        trackID = str2double(cell2mat(trackID{1}(trackID{2})));
        tracks2analyse = trackID;
end %switch

%preallocate space
[beginConf endConf lengthconf beginFree endFree lengthFree...
    trackListFree trackListConf pntConf pntFree] =...
    deal(cell(numel(tracks2analyse),1));

nrFree = 0; nrConf = 0;
iConf = getappdata(hconf.Axes, 'confIndex');
for N = tracks2analyse
    [beginConf{N} endConf{N} lengthconf{N}...
        beginFree{N} endFree{N} lengthFree{N}] =...
        getConfBounds(iConf{N},...
        getappdata(hconf.Axes, 'confThreshVal'),...
        getappdata(hconf.Axes, 'minTimeVal'));
    
    [trackListFree{N} trackListConf{N} pntFree{N} pntConf{N}] = getConfPeriods(v.data{N},...
        beginConf{N},endConf{N},lengthconf{N},beginFree{N},...
        endFree{N},lengthFree{N},getappdata(hconf.Axes, 'calcWindowVal'),...
        nrFree, nrConf);
    
    nrFree = sum(cellfun('size',beginFree,1));
    nrConf = sum(cellfun('size',beginConf,1));
end

setappdata(hconf.Axes, 'beginConf', beginConf)
setappdata(hconf.Axes, 'endConf', endConf)
setappdata(hconf.Axes, 'trackListConf', trackListConf)
setappdata(hconf.Axes, 'trackListFree', trackListFree)
setappdata(hconf.Axes, 'pntConf', pntConf)
setappdata(hconf.Axes, 'pntFree', pntFree)

ConfChangePlot(src, event, hconf)
end
function ConfChangePlot(src, event, hconf)
h = getappdata(1, 'handles');
v = getappdata(1, 'values')

delete([findobj('Tag', 'groupConf');...
    findobj('Tag', 'axesLocalD')])
cla(hconf.Axes, 'reset')
set(hconf.Axes, 'Position', [0.4 0.1 0.5 0.8])

switch get(findobj('-regexp', 'Tag', 'ConfMapPlotType'), 'Value')
    case 1
        switch hconf.type
            case 'group'
                
                uicontrol(...
                    'Parent', h(49),...
                    'Style', 'popupmenu',...
                    'Tag', 'groupConf',...
                    'Units', 'normalized',...
                    'Position', [0.15 0.4 0.7 0.2],...
                    'String', ['all'; get(h(19), 'String')],...
                    'Value', 1,...
                    'FontSize', 10,...
                    'CreateFcn', {@ConfMapIndex, hconf},...
                    'Callback', {@ConfMapIndex, hconf});
                
            case 'single'
                
                Lc = getappdata(hconf.Axes, 'confIndex');
                localD = getappdata(hconf.Axes, 'localD');
                beginConf = getappdata(hconf.Axes, 'beginConf');
                endConf = getappdata(hconf.Axes, 'endConf');
                track = get(handles.singleTrackSelected, {'String', 'Value'});
                track = str2double(track{1}(track{2}));
                
                set(hconf.Axes, 'Position', [0.4 0.1 0.5 0.39])
                set(hconf.Axes, 'ButtonDownFcn', {@selectData, track, hconf})
                hold on
                if ~isempty(beginConf{track})
                    patch([beginConf{track} beginConf{track} endConf{track} endConf{track}]',...
                        repmat([0; max(Lc{track}); max(Lc{track}); 0],1,numel(beginConf{track})),...
                        [0.85 0.85 0.85], 'EdgeColor', [1 1 1], 'DisplayName', 'confinement');
                end %if
                if getappdata(hconf.Axes, 'showControl')
                    control = simBrown(0,0,v.trackLifeTime(track),1,...
                        getappdata(hconf.Axes, 'Dmax'),v.settings.Delay,...
                        v.px2micron);
                    iConfControl = calcConf(getappdata(hconf.Axes, 'Dmax'),...
                        control(:,1), control(:,2), control(:,3),v.settings.Delay,...
                        getappdata(hconf.Axes, 'calcWindowVal'), getappdata(hconf.Axes, 'method'),...
                        v.px2micron);
                    area(iConfControl,'FaceColor', 'b',...
                        'EdgeColor', 'b', 'DisplayName', 'control')
                end %if
                plot(Lc{track},'Color', 'r', 'LineWidth', 0.5, 'DisplayName', 'data')
                plot(smooth(Lc{track},100),'g','LineWidth',3, 'DisplayName', 'smoothed data')
                line([0 numel(Lc{track})], [getappdata(hconf.Axes, 'confThreshVal')...
                    getappdata(hconf.Axes, 'confThreshVal')], 'Color', 'k',...
                    'LineWidth', 3, 'DisplayName', 'threshhold')
                axis tight
                legend(hconf.Axes,'show')
                xlabel('Window Position'); ylabel('Confinement Index');
                
                axes('Tag', 'axesLocalD', 'Position', [0.4 0.51 0.5 0.39],...
                    'ButtonDownFcn', {@selectData, track, hconf})
                hold on
                if ~isempty(beginConf{track})
                    patch([beginConf{track} beginConf{track} endConf{track} endConf{track}]',...
                        repmat([0; max(localD{track}); max(localD{track}); 0],1,numel(beginConf{track})),...
                        [0.85 0.85 0.85], 'EdgeColor', [0.85 0.85 0.85], 'DisplayName', 'confinement');
                end %if
                plot(localD{track},'Color', 'r', 'LineWidth', 0.5, 'DisplayName', 'data')
                plot(smooth(localD{track},100),'g','LineWidth',3, 'DisplayName', 'smoothed data')
                axis tight
                ylabel('Local Diffusion [?m^2/s]');
                set(gca, 'XTick', [])
                
                linkaxes([gca, hconf.Axes],'x');
        end
        
        uicontrol(...
            'Parent', h(49),...
            'Style', 'checkbox',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.35 0.5 0.3 0.05],...
            'String', 'show Control',...
            'FontSize', 10,...
            'Value', getappdata(hconf.Axes, 'showControl'),...
            'Callback', {@ConfMapControl, hconf})
        
        zoom reset
    case 2
        
        if getappdata(hconf.Axes, 'showBackground')
            cla(hconf.Axes, 'reset')
            imagesc(getappdata(hconf.Axes, 'background'))
            colormap(gray(256))
            hold on
        end %if
        
        switch hconf.type
            case 'single'
                
                track = get(h(19), {'String', 'Value'});
                track = str2double(track{1}(track{2}));
                
                x = v.data{track}(:,1);
                y = v.data{track}(:,2);
                plot(x +1,y +1,'b', 'LineWidth', 1,...
                    'DisplayName', 'free');
                
            case 'group'
                
                x = cellfun(@(x) [x(:,1); nan],v.data(v.track & v.trackActiv),'Un',0);
                y = cellfun(@(x) [x(:,2); nan],v.data(v.track & v.trackActiv),'Un',0);
                
                switch getappdata(hconf.Axes, 'backgroundType')
                    case 'palm'
                        if getappdata(hconf.Axes, 'showBackground')
                            exf = getappdata(hconf.Axes, 'expansionFactor');
                            plot(vertcat(x{:}).*exf+exf*.5,vertcat(y{:}).*exf+exf*.5,'b',...
                                'LineWidth', 1, 'DisplayName', 'free');
                        else
                            plot(vertcat(x{:}) +1,vertcat(y{:}) +1,'b', 'LineWidth', 1,...
                                'DisplayName', 'free');
                            xlim([0 v.settings.Width]); ylim([0 v.settings.Height])
                        end %if
                    otherwise
                        plot(vertcat(x{:}) +1,vertcat(y{:}) +1,'b', 'LineWidth', 1,...
                            'DisplayName', 'free');
                        xlim([0 v.settings.Width]); ylim([0 v.settings.Height])
                end %switch
        end %switch
        
        hold on
        trackListConf = cell2mat(getappdata(hconf.Axes, 'trackListConf'));
        trackListConf(isnan(trackListConf(:,9)),:) = [];
        if ~isempty(trackListConf)
            xConf = accumarray(trackListConf(:,9), trackListConf(:,1),...
                [max(trackListConf(:,9)) 1], @(x) {x});
            yConf = accumarray(trackListConf(:,9), trackListConf(:,2),...
                [max(trackListConf(:,9)) 1], @(x) {x});
            if numel(xConf) == 1
                xConf = xConf{:};
                yConf = yConf{:};
            else
                xConf = padcat(xConf{:});
                yConf = padcat(yConf{:});
            end %if
            
            switch getappdata(hconf.Axes, 'backgroundType')
                case 'palm'
                    if getappdata(hconf.Axes, 'showBackground')
                        h = plot(xConf.*exf+exf*.5,yConf.*exf+exf*.5,'r', 'LineWidth', 2);
                    else
                        h = plot(xConf +1,yConf +1,'r', 'LineWidth', 2);
                    end %if
                otherwise
                    h = plot(xConf +1,yConf +1,'r', 'LineWidth', 2);
            end %switch
            handleGroup(1) = hggroup;
            set(h,'Parent',handleGroup(1))
            set(get(get(handleGroup(1),'Annotation'),'LegendInformation'),...
                'IconDisplayStyle','on');
            set(handleGroup(1), 'DisplayName', 'confinement')
        end
        
        legend(hconf.Axes, 'show')
        xlabel('x-coordinate [px]'); ylabel('y-coordinate [px]');
        axis equal ij
        
        uicontrol(...
            'Parent', h(49),...
            'Style', 'checkbox',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.3 0.6 0.4 0.05],...
            'String', 'show Background',...
            'FontSize', 10,...
            'Value', getappdata(hconf.Axes, 'showBackground'),...
            'Callback', {@ConfMapBackground, hconf})
        
        zoom reset
    case 3
        
        colormap('default')
        Lc = getappdata(hconf.Axes, 'confIndex');
        Lc = vertcat(Lc{:});
        Lc(isnan(Lc) | isinf(Lc)) = [];
        Lcontrol = getappdata(hconf.Axes, 'confControl');
        
        bins = calcnbins(nonzeros(Lc), 'fd');
        binWidth = max(nonzeros(Lc))/bins;
        binCtrs = linspace(binWidth, max(nonzeros(Lc)),bins);
        histLc = histc(nonzeros(Lc), binCtrs);
        histLcontrol = histc(nonzeros(Lcontrol), binCtrs);
        
        hold on
        %         h = bar(binCtrs,log([histLcontrol histLc]), 'BarWidth', 1);
        %         colormap([0 0 1; 1 0 0])
        %         set(h(1), 'EdgeColor', 'b', 'DisplayName', 'control')
        %         set(h(2), 'EdgeColor', 'r', 'DisplayName', 'data')
        stem(binCtrs,log(histLc),'r', 'DisplayName', 'data')
        stem(binCtrs,log(histLcontrol),'b', 'DisplayName', 'control')
        
        yLim = get(gca, 'YLim');
        line([getappdata(hconf.Axes, 'confThreshVal'),...
            getappdata(hconf.Axes, 'confThreshVal')],...
            [0 yLim(2)], 'Color', 'k', 'LineWidth', 3, 'DisplayName', 'threshhold')
        text(getappdata(hconf.Axes, 'confThreshVal'), yLim(2),...
            sprintf('\n  min confinement'), 'Color', 'k', 'FontSize', 13)
        axis tight
        legend(hconf.Axes, 'show')
        xlabel('Confinement Index'); ylabel('ln Frequency');
        
        zoom reset
    case 4
        
        trackListConf = cell2mat(getappdata(hconf.Axes, 'trackListConf'));
        trackListConf(isnan(trackListConf(:,9)),:) = [];
        if ~isempty(trackListConf)
            indexVector = 1:size(trackListConf,1);
            iMatrix = accumarray(trackListConf(:,9), indexVector, [],...
                @(x) {repmat(x,1,numel(x))});
            ii = cellfun(@(x) x(tril(true(size(x)),-1)), iMatrix, 'Un', 0);
            iii = cellfun(@(x) x(flipud(tril(true(size(x)),-1))), iMatrix, 'Un', 0);
            confDisplacement = trackListConf(vertcat(ii{:}),1:3) - trackListConf(vertcat(iii{:}),1:3);
            confDisplacement(:,4) = sqrt(sum(confDisplacement(:,1:2).^2,2))*v.px2micron;
            setappdata(hconf.Axes, 'confDisplacement', confDisplacement)
        end %if
        
        trackListFree = cell2mat(getappdata(hconf.Axes, 'trackListFree'));
        trackListFree(isnan(trackListFree(:,9)),:) = [];
        if ~isempty(trackListFree)
            indexVector = 1:size(trackListFree,1);
            iMatrix = accumarray(trackListFree(:,9), indexVector, [],...
                @(x) {repmat(x,1,numel(x))});
            ii = cellfun(@(x) x(tril(true(size(x)),-1)), iMatrix, 'Un', 0);
            iii = cellfun(@(x) x(flipud(tril(true(size(x)),-1))), iMatrix, 'Un', 0);
            freeDisplacement = trackListFree(vertcat(ii{:}),1:3) - trackListFree(vertcat(iii{:}),1:3);
            freeDisplacement(:,4) = sqrt(sum(freeDisplacement(:,1:2).^2,2))*v.px2micron;
            setappdata(hconf.Axes, 'freeDisplacement', freeDisplacement)
        end %if
        
        uicontrol(...
            'Parent', h(49),...
            'Style', 'text',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.15 0.53 0.4 0.05],...
            'String', 'Time Step:',...
            'FontSize', 15);
        
        hconf.deltaT =...
            uicontrol(...
            'Parent', h(49),...
            'Style', 'edit',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.6 0.53 0.2 0.05],...
            'String', '5',...
            'FontSize', 15);
        
        uicontrol(...
            'Parent', h(49),...
            'Style', 'text',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.15 0.58 0.4 0.05],...
            'String', 'Subfractions:',...
            'FontSize', 15);
        
        hconf.fractions =...
            uicontrol(...
            'Parent', h(49),...
            'Style', 'edit',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.6 0.58 0.2 0.05],...
            'String', '1',...
            'FontSize', 15);
        
        uicontrol(...
            'Parent', h(49),...
            'Style', 'pushbutton',...
            'Tag', 'groupConf',...
            'Units', 'normalized',...
            'Position', [0.15 0.45 0.7 0.05],...
            'String', 'Diffusion Constant',...
            'FontSize', 10,...
            'CreateFcn', {@ConfMapDiffusion, hconf},...
            'Callback', {@ConfMapDiffusion, hconf})
        
        zoom reset
        
    case 5
        
        lengthFree = cell2mat(getappdata(hconf.Axes, 'lengthFree'));
        lengthconf = cell2mat(getappdata(hconf.Axes, 'lengthconf'));
        
        ctrs = linspace(1,max([lengthFree;lengthconf]),...
            calcnbins(lengthFree, 'fd'));
        h = bar(ctrs, [hist(lengthFree,ctrs); hist(lengthconf,ctrs)]');
        set(h(1), 'EdgeColor', 'b', 'DisplayName', 'Free')
        set(h(2), 'EdgeColor', 'r', 'DisplayName', 'Confined')
        
        legend('Location', 'NorthEast')
        axis tight
        xlabel('Time [s]'); ylabel('Frequency');
        
        zoom reset
        
    otherwise
end %switch
end
function ConfMapDiffusion(src, event, hconf)
v = getappdata(1, 'values')

cla (hconf.Axes, 'reset')

deltaT = str2double(get(hconf.deltaT, 'String'));
subfractions = str2double(get(hconf.fractions, 'String'));

dFree = getappdata(hconf.Axes, 'freeDisplacement');
if ~isempty(dFree)
    [pFree,rFree] = ecdf(dFree(dFree(:,3) == deltaT,4));
    [yFree, xFree] = ecdfhist(pFree,rFree,100);
end %if

dConf = getappdata(hconf.Axes, 'confDisplacement');
if ~isempty(dConf)
    [pConf,rConf] = ecdf(dConf(dConf(:,3) == deltaT,4));
    if isempty(dFree)
        [yConf, xConf] = ecdfhist(pConf,rConf,100);
    else
        [yConf, xConf] = ecdfhist(pConf,rConf,xFree);
    end %if
end %if

hold on
if ~isempty(dFree) && ~isempty(dConf)
    h = bar(xFree,[yFree' yConf'], 'BarWidth', 1);
    colormap([0 0 1; 1 0 0])
    set(h(1), 'EdgeColor', 'b', 'DisplayName', 'Free')
    set(h(2), 'EdgeColor', 'r', 'DisplayName', 'Confined')
elseif ~isempty(dFree)
    h = bar(xFree,yFree', 'BarWidth', 1);
    colormap([0 0 1])
    set(h, 'EdgeColor', 'b', 'DisplayName', 'Free')
elseif ~isempty(dConf)
    h = bar(xConf,yConf', 'BarWidth', 1);
    colormap([1 0 0])
    set(h, 'EdgeColor', 'r', 'DisplayName', 'Confined')
end %if


lower = repmat([0 0], 1, subfractions);
upper = repmat([1 1], subfractions, 1);
upper = upper(:);
start = [(1:subfractions)/1000, repmat(1/subfractions, 1, subfractions)];

s = fitoptions('Method', 'NonlinearLeastSquares',...
    'Lower', lower,...
    'Upper', upper,...
    'StartPoint', start);

equation = ['((N1/(4*pi*D1*' num2str(v.settings.Delay*deltaT)...
    '))*exp(-x^2/(4*D1*' num2str(v.settings.Delay*deltaT) '))*2*pi*x)'];

if subfractions > 1
    for n = 2:subfractions
        equation = [equation '+((N' num2str(n) '/(4*pi*D' num2str(n) ...
            '*' num2str(v.settings.Delay*deltaT) '))*exp(-x^2/(4*D' num2str(n)...
            '*' num2str(v.settings.Delay*deltaT) '))*2*pi*x)'];
    end %for
end %if

f = fittype(equation,...
    'options', s,...
    'independent', 'x');

if subfractions == 1
    if ~isempty(dFree)
        [fitDfree statsDfree outputDfree] = fit(xFree',yFree',f);
        h = plot(fitDfree, 'b');
        set(h, 'DisplayName', ['D = ' num2str(fitDfree.D1, '%.3f')...
            ' (adjR^2 = ' num2str(statsDfree.adjrsquare, '%.3f') ')'])
    end %if
    
    if ~isempty(dConf)
        [fitDconf statsDconf outputDconf] = fit(xConf',yConf',f);
        h = plot(fitDconf, 'r');
        set(h, 'DisplayName', ['D = ' num2str(fitDconf.D1, '%.3f')...
            ' (adjR^2 = ' num2str(statsDconf.adjrsquare, '%.3f') ')'])
    end %if
else
    if ~isempty(dFree)
        [fitDfree statsDfree outputDfree] = fit(xFree',yFree',f);
        h = plot(fitDfree, 'b');
        set(h, 'DisplayName', ['Sum Function (adjR^2 = ' num2str(statsDfree.adjrsquare, '%.3f') ')'])
    end %if
    
    if ~isempty(dConf)
        [fitDconf statsDconf outputDconf] = fit(xConf',yConf',f);
        h = plot(fitDconf, 'r');
        set(h, 'DisplayName', ['Sum Function (adjR^2 = ' num2str(statsDconf.adjrsquare, '%.3f') ')'])
    end %if
    for n = 1:subfractions
        if ~isempty(dFree)
            freeD(n) = eval(['fitDfree.D' num2str(n)]);
            freeN(n) = eval(['fitDfree.N' num2str(n)]);
            h = plot(xFree,((freeN(n)/(4*pi*freeD(n)*v.settings.Delay*...
                deltaT)))*exp(-xFree.^2/(4*freeD(n)*v.settings.Delay*...
                deltaT))*2*pi.*xFree, 'b:');
            
            set(h, 'DisplayName', [num2str(freeN(n)*100','%.1f')...
                '% D = ' num2str(freeD(n),'%.3f') ' ?m^2/s'])
        end %if
        
        if ~isempty(dConf)
            confD(n) = eval(['fitDconf.D' num2str(n)]);
            confN(n) = eval(['fitDconf.N' num2str(n)]);
            h = plot(xFree,((confN(n)/(4*pi*confD(n)*v.settings.Delay*...
                deltaT)))*exp(-xFree.^2/(4*confD(n)*v.settings.Delay*...
                deltaT))*2*pi.*xFree, 'r:');
            
            set(h, 'DisplayName', [num2str(confN(n)*100','%.1f')...
                '% D = ' num2str(confD(n),'%.3f') ' ?m^2/s'])
        end %if
    end %for
end %if

legend('Location', 'NorthEast')
axis tight
xlabel('Step Length [?m]'); ylabel('Probability Density');
end
function ConfMapIndex(src, event, hconf)

cla(hconf.Axes, 'reset')
legend(hconf.Axes,'off')
delete(findobj('Tag', 'axesLocalD'))

track = get(src, {'String', 'Value'});
track = str2double(track{1}(track{2}));
Lc = getappdata(hconf.Axes, 'confIndex');
localD = getappdata(hconf.Axes, 'localD');
beginConf = getappdata(hconf.Axes, 'beginConf');
endConf = getappdata(hconf.Axes, 'endConf');

set(hconf.Axes, 'Position', [0.4 0.1 0.5 0.39])
if isnan(track)
    Lc = vertcat(Lc{:});
    localD = horzcat(localD{:})';
    %     beginConf = vertcat(beginConf{:});
    %     endConf = vertcat(endConf{:});
    hold on
    %     patch([beginConf beginConf endConf endConf]',...
    %         repmat([0; max(Lc); max(Lc); 0],1,numel(beginConf)),...
    %         [0.85 0.85 0.85], 'EdgeColor', [0.85 0.85 0.85], 'DisplayName', 'confinement');
    if getappdata(hconf.Axes, 'showControl')
        area(getappdata(hconf.Axes, 'confControl'),'FaceColor', 'b',...
            'EdgeColor', 'b', 'DisplayName', 'control')
    end %if
    plot(Lc,'Color', 'r', 'LineWidth', 0.5, 'DisplayName', 'data')
    plot(smooth(Lc,100),'g','LineWidth',3, 'DisplayName', 'smoothed data')
    line([0 numel(Lc)], [getappdata(hconf.Axes, 'confThreshVal')...
        getappdata(hconf.Axes, 'confThreshVal')], 'Color', 'k',...
        'LineWidth', 3, 'DisplayName', 'threshhold')
    axis tight
    legend(hconf.Axes,'show')
    xlabel('Track'); ylabel('Confinement Index');
    set(gca, 'XTick', [])
    
    axes('Tag', 'axesLocalD', 'Position', [0.4 0.51 0.5 0.39])
    hold on
    %     patch([beginConf beginConf endConf endConf]',...
    %         repmat([0; max(localD); max(localD); 0],1,numel(beginConf)),...
    %         [0.85 0.85 0.85], 'EdgeColor', [0.85 0.85 0.85], 'DisplayName', 'confinement');
    plot(localD,'Color', 'r', 'LineWidth', 0.5, 'DisplayName', 'data')
    plot(smooth(localD,100),'g','LineWidth',3, 'DisplayName', 'smoothed data')
    axis tight
    ylabel('Local Diffusion [?m^2/s]');
    set(gca, 'XTick', [])
    
    linkaxes([gca, hconf.Axes],'x');
else
    v = getappdata(1, 'values')
    
    %trackList =
    %vertcat(v.data{str2num(cell2mat(get(v.singleTrackSelected, 'String')))});
    beginConf = beginConf{track};
    endConf = endConf{track};
    
    axes(hconf.Axes)
    set(hconf.Axes, 'ButtonDownFcn', {@selectData, track, hconf})
    hold on
    if ~isempty(beginConf)
        patch([beginConf beginConf endConf endConf]',...
            repmat([0; max(Lc{track}); max(Lc{track}); 0],1,numel(beginConf)),...
            [0.85 0.85 0.85], 'EdgeColor', [1 1 1], 'DisplayName', 'confinement');
    end %if
    if getappdata(hconf.Axes, 'showControl')
        control = simBrown(0,0,v.trackLifeTime(track),1,...
            getappdata(hconf.Axes, 'Dmax'),v.settings.Delay,...
            v.px2micron);
        iConfControl = calcConf(getappdata(hconf.Axes, 'Dmax'),...
            control(:,1), control(:,2), control(:,3),v.settings.Delay,...
            getappdata(hconf.Axes, 'calcWindowVal'), getappdata(hconf.Axes, 'method'),...
            v.px2micron);
        area(iConfControl,'FaceColor', 'b',...
            'EdgeColor', 'b', 'DisplayName', 'control')
    end %if
    plot(Lc{track},'Color', 'r', 'LineWidth', 0.5, 'DisplayName', 'data')
    plot(smooth(Lc{track},100),'g','LineWidth',3, 'DisplayName', 'smoothed data')
    line([0 numel(Lc{track})], [getappdata(hconf.Axes, 'confThreshVal')...
        getappdata(hconf.Axes, 'confThreshVal')], 'Color', 'k',...
        'LineWidth', 3, 'DisplayName', 'threshhold')
    axis tight
    legend(hconf.Axes,'show')
    xlabel('Window Position'); ylabel('Confinement Index');
    
    axes('Tag', 'axesLocalD', 'Position', [0.4 0.51 0.5 0.39],...
        'ButtonDownFcn', {@selectData, track, hconf})
    hold on
    patch([beginConf beginConf endConf endConf]',...
        repmat([0; max(localD{track}); max(localD{track}); 0],1,numel(beginConf)),...
        [0.85 0.85 0.85], 'EdgeColor', [0.85 0.85 0.85], 'DisplayName', 'confinement');
    plot(localD{track},'Color', 'r', 'LineWidth', 0.5, 'DisplayName', 'data')
    plot(smooth(localD{track},100),'g','LineWidth',3, 'DisplayName', 'smoothed data')
    axis tight
    ylabel('Local Diffusion [?m^2/s]');
    set(gca, 'XTick', [])
    
    linkaxes([gca, hconf.Axes],'x');
end

zoom reset
end
function ConfMapBackground(src, event, hconf)
h = getappdata(1, 'handles');
v = getappdata(1, 'values')

if get(src, 'Value')
    setappdata(hconf.Axes, 'showBackground', 1)
    if isempty(getappdata(hconf.Axes, 'background'))
        answer = questdlg('Type of Background Image:','',...
            'Single Image', 'Image Stack', 'Palm Image', 'Single Image');
        
        [filename, pathname] =...
            uigetfile('*.tif', 'Select Image',getappdata(1,'searchPath'));
        
        switch answer
            case 'Single Image'
                
                I = imread([pathname filename],1);
                
                answer = questdlg('Visualisation Style:','',...
                    'gray scale', 'pseudo colored', 'gray scale');
                switch answer
                    case 'gray scale'
                        colormap('gray')
                        
                        answer = questdlg('Gray Scale Order:','',...
                            'normal', 'inverted', 'normal');
                        switch answer
                            case 'normal'
                                imagesc(I)
                            case 'inverted'
                                imagesc(imcomplement(I))
                        end %switch
                    case 'pseudo colored'
                end %switch
                
                graphOrderList = allchild(gca);
                set(gca, 'Children',...
                    [graphOrderList(2:end); graphOrderList(1)])
                
            case 'Image Stack'
                
                I = zeros(v.settings.Height,...
                    v.settings.Width,...
                    v.settings.Frames, 'uint16');
                
                info = imfinfo([pathname filename]);
                
                hProgressbar = waitbar(0,'Loading Stack','Color',...
                    get(0,'defaultUicontrolBackgroundColor'));
                for N = 1:v.settings.Frames
                    I(:,:,N) = imread([pathname filename],N, 'Info', info);
                    waitbar(N/v.settings.Frames,hProgressbar,...
                        'Loading Stack','Color',...
                        get(0,'defaultUicontrolBackgroundColor'));
                end %for
                delete(hProgressbar)
                
                answer = questdlg('Visualisation Style:','',...
                    'gray scale', 'pseudo colored', 'gray scale');
                switch answer
                    case 'gray scale'
                        colormap('gray')
                        
                        answer = questdlg('Stack Unification Method:','',...
                            'max', 'average', 'variance', 'average');
                        
                        switch answer
                            case 'max'
                                I = max(I,[],3);
                            case 'average'
                                I = mean(I,3);
                            case 'variance'
                                I = var(single(I),[],3);
                        end %switch
                        
                        answer = questdlg('Gray Scale Order:','',...
                            'normal', 'inverted', 'normal');
                        switch answer
                            case 'normal'
                                imagesc(I)
                            case 'inverted'
                                imagesc(imcomplement(I))
                        end %switch
                        
                    case 'pseudo colored'
                end %switch
                
                graphOrderList = allchild(gca);
                set(gca, 'Children',...
                    [graphOrderList(2:end); graphOrderList(1)])
                
            case 'Palm Image'
                
                cla reset
                I = imread([pathname filename],1);
                imagesc(I);
                colormap('gray')
                
                exf = str2double(cell2mat(inputdlg('Set PALM Expansion Factor:','',...
                    1,{'12'})));
                
                x = cellfun(@(x) [x(:,1); nan],v.data(v.track & v.trackActiv),'Un',0);
                y = cellfun(@(x) [x(:,2); nan],v.data(v.track & v.trackActiv),'Un',0);
                hold on
                plot(vertcat(x{:}).*exf+exf*.5,vertcat(y{:}).*exf+exf*.5,'b', 'LineWidth', 1,...
                    'DisplayName', 'free');
                axis equal ij
                
                trackListConf = cell2mat(getappdata(hconf.Axes, 'trackListConf'));
                trackListConf(isnan(trackListConf(:,10)),:) = [];
                if ~isempty(trackListConf)
                    xConf = accumarray(trackListConf(:,10), trackListConf(:,1),...
                        [max(trackListConf(:,10)) 1], @(x) {x});
                    yConf = accumarray(trackListConf(:,10), trackListConf(:,2),...
                        [max(trackListConf(:,10)) 1], @(x) {x});
                    if numel(xConf) == 1
                        xConf = xConf{:};
                        yConf = yConf{:};
                    else
                        xConf = padcat(xConf{:});
                        yConf = padcat(yConf{:});
                    end %if
                    
                    
                    h = plot(xConf.*exf+exf*.5,yConf.*exf+exf*.5,'r', 'LineWidth', 2);
                    handleGroup(1) = hggroup;
                    set(h,'Parent',handleGroup(1))
                    set(get(get(handleGroup(1),'Annotation'),'LegendInformation'),...
                        'IconDisplayStyle','on');
                    set(handleGroup(1), 'DisplayName', 'confinement')
                end
                zoom reset
                setappdata(hconf.Axes, 'backgroundType', 'palm')
                setappdata(hconf.Axes, 'expansionFactor', exf)
        end
        
        setappdata(hconf.Axes, 'background', I)
        
    else
        ConfChangePlot(src, event, hconf)
    end %if
else
    setappdata(hconf.Axes, 'showBackground', 0)
    ConfChangePlot(src, event, hconf)
end %if
end
function ConfMapControl(src, event, hconf)
if get(src, 'Value')
    setappdata(hconf.Axes, 'showControl', 1)
    ConfChangePlot(src, event,  hconf)
else
    setappdata(hconf.Axes, 'showControl', 0)
    ConfChangePlot(src, event,  hconf)
end %if
end

function [Dlocal AnomalousCoeff] = calcDlocal(x,y,frame,w,lagTime,px2micron)

%Calculates the local Diffusion inside moving timewindow
%
%
% INPUT:
%           x (Vector; x-coordinates [px])
%           y (Vector; y-coordinates [px])
%           lagTime(scalar; [s])
%           w (scalar; calculation Window [Frames])
%
% OUTPUT:
%           D (Vector of Diffusion Coefficients)
%
% written by C.P.Richter
% version 10.06.12
[nrSeg idxSeg ptsSeg lifeTime w] = segmentTrack(frame,w);

% Dlocal = zeros(nrSeg,1);
if nrSeg > 0
    x = accumarray(1+frame-frame(1),x,[lifeTime 1],[],nan);
    y = accumarray(1+frame-frame(1),y,[lifeTime 1],[],nan);
    frame = (1:lifeTime)';
    
    iMat = repmat(idxSeg(:,1),1,w);
    good = tril(true(w),-1);
    ii = iMat(good);
    iii = iMat(flipud(good));
        
    iSeg = repmat(0:nrSeg-1,sum(idxSeg(1:end-1,1)),1);
    ii = repmat(ii,1,nrSeg)+iSeg;
    iii = repmat(iii,1,nrSeg)+iSeg;
        
    sd = ((x(ii)-x(iii)).^2 +...
        (y(ii)-y(iii)).^2)*px2micron^2;
    stepLength = frame(ii)-frame(iii);
        
    stepLength = stepLength(w:6*w-21,:); %analyse 2:6 steps
    sd = sd(w:6*w-21,:);
        
    subs = bsxfun(@plus,stepLength,0:5:(nrSeg-1)*5)-1
        size(accumarray(subs(:),sd(:),[],@nanmean))
        
      5*nrSeg
     
    msd = reshape(accumarray(subs(:),sd(:),[],@nanmean), 5, nrSeg);
    t = [ones(5,1) log(4*(2:6)*lagTime)'];
    
    % mean moment displacement = Dlocal*4t^AnomalousCoeff
    yHat = t\log(msd);
    Dlocal = exp(yHat(1,:));
    AnomalousCoeff = yHat(2,:);
    
    %Dlocal(ptsSeg < w/2) = nan; %discard if less than w/2 ponts inside w
end
end
function [iConf refPoint displacement] =...
    calcConf(D, x ,y, frame, lagTime, w, method,px2micron)
%Calculates the Confinement Index inside moving time-window
%
%
% INPUT:
%           D (Scalar; Dmax [?m^2/s])
%           x (Vector; x-coordinates [px])
%           y (Vector; y-coordinates [px])
%           lagTime(scalar; [s])
%           w (scalar; calculation Window [Frames])
%           method (scalar, defines Algorithm)
%
% OUTPUT:
%           iConf (Vector of Confinement Indizes)
%
% written by C.P.Richter
% version 10.05.04

[nrSeg idxSeg ptsSeg lifeTime] = segmentTrack(frame,w);
iConf = zeros(nrSeg,1);
refPoint = zeros(nrSeg,1);
displacement = zeros(nrSeg,1);

if nrSeg > 0
    x = accumarray(1+frame-frame(1),x,[lifeTime 1],[],nan);
    y = accumarray(1+frame-frame(1),y,[lifeTime 1],[],nan);
    
    switch method
        
        case 'varM' %Meilhac
            
            refPoint = idxSeg(ceil(w/2),:);
            segMiddle = repmat(refPoint,w,1);
            displacement = nanvar(reshape(sqrt(((x(idxSeg)-x(segMiddle))*px2micron).^2 +...
                ((y(idxSeg)-y(segMiddle))*px2micron).^2),w,nrSeg),[],1);
            
            iConf(:) = D * w * lagTime ./ displacement;
            
        case 'conf' %Saxton
            
            refPoint = idxSeg(1,:);
            segStart = repmat(refPoint,w,1);
            displacement = max(reshape(sqrt(((x(idxSeg)-x(segStart))*px2micron).^2 +...
                ((y(idxSeg)-y(segStart))*px2micron).^2),w,nrSeg));
            psi = exp(0.2048 - (2.5117 * D * (w - 1 * lagTime))./...
                displacement);
            iConf(psi < 0.1) = -1*log(psi(psi < 0.1)) -1;
            
    end %switch
end %if
end

function [nrSeg idxSeg ptsSeg lifeTime w] = segmentTrack(frame,w)
%Segmentises a track using a constant moving time-window
%
% INPUT:
%           frame (Vector; Frames the particle was detected)
%           w (Scalar; Size of time-window [frames])
%
% OUTPUT:
%           nrSeg (Scalar; Number of segments)
%           idxSeg (Matrix; Indizes of segments as columnvectors)
%           ptsSeg (Vector; Number of detections in each segment)
%           lifeTime (Scalar; Time the particle was observed [frames])
%
% written by C.P.Richter
% version 10.06.18

lifeTime = 1+frame(end)-frame(1);

nrSeg = lifeTime-w+1;
if nrSeg < 1
    nrSeg = 1;
    w = lifeTime;
end %if

[segMat,wMat] = meshgrid(1:nrSeg ,0:w-1);
idxSeg = segMat + wMat;

frame = accumarray(1+frame-frame(1),frame,[lifeTime 1],[],nan);
ptsSeg = w-sum(isnan(frame(idxSeg)));
end
function [beginEvent endEvent lengthEvent...
    beginGround endGround lengthGround] =...
    getConfBounds(data, yThresh, xThresh)
%Quantifies Events in two State Trajectory
%
%
% INPUT:
%
% OUTPUT:
%
% written by C.P.Richter
% version 10.06.01

if isempty(data)
    
    beginEvent = [];
    endEvent = [];
    lengthEvent = [];
    beginGround = [];
    endGround = [];
    lengthGround = [];
    
else
    
    nrW = numel(data); %nr of calculated time-windows
    
    endEvent = find(diff(data >= yThresh) == -1); %transition 0 -> 1
    beginGround = endEvent + 1;
    
    endGround = find(diff(data >= yThresh) == +1); %transition 1 -> 0
    beginEvent = endGround + 1;
    
    %evaluate trajectory bounds
    if data(1) > yThresh %event starts
        beginEvent = [1; beginEvent];
    else
        beginGround = [1; beginGround];
    end
    
    if data(end) > yThresh %event ends
        endEvent = [endEvent; nrW];
    else
        endGround = [endGround; nrW];
    end
    
    lengthEvent = (endEvent-beginEvent)+1;
    %check if event is long enough
    goodEvent = lengthEvent >= xThresh;
    
    beginEvent = beginEvent(goodEvent);
    endEvent = endEvent(goodEvent);
    lengthEvent = lengthEvent(goodEvent);
    
    lengthGround = (endGround-beginGround)+1;
end
end
function [trackListGround trackListEvent pntGround pntEvent] = getConfPeriods(...
    track,beginEvent,endEvent,lengthEvent,beginGround,endGround,lengthGround,w,nrGround,nrEvent)
%Seperates Traces into two States
%
%
% INPUT:
%
% OUTPUT:
%
% written by C.P.Richter
% version 10.06.01

if isempty(beginEvent) %no events
    
    trackListGround = [track ones(size(track,1),1)+nrGround];
    trackListEvent = nan(1,9);
    pntEvent = zeros(size(track,1));
    pntGround = w-pntEvent;
    
elseif isempty(beginGround)
    
    trackListEvent = [track ones(size(track,1),1)+nrEvent];
    trackListGround = nan(1,9);
    pntEvent = ones(size(track,1))*w;
    pntGround = w-pntEvent;
    
else %both
    
    [nrSeg idxSeg unused unused] = segmentTrack(track(:,3),w);
    good = arrayfun(@(x) ge(x,beginEvent') &...
        le(x,endEvent'), idxSeg(1,:), 'Un',0);
    [good unused] = find(vertcat(good{:}));
    [pntEvent cnt] = hist(reshape(idxSeg(:,good),[],1),1:track(end,3));
    pntEvent = pntEvent(ismember(cnt,track(:,3)));
    pntGround = w-pntEvent;
    
    idxSeg = idxSeg+track(1,3)-1; %idx2frame transform
    EventBounds = [idxSeg(1,beginEvent); idxSeg(end,endEvent)];
    good = arrayfun(@(x) ge(x,EventBounds(1,:)) &...
        le(x,EventBounds(2,:)), track(:,3), 'Un',0);
    [good segment] = find(vertcat(good{:}));
    trackListEvent = [track(good,:) segment+nrEvent];
    
    GroundBounds = [idxSeg(1,beginGround); idxSeg(end,endGround)];
    good = arrayfun(@(x) ge(x,GroundBounds(1,:)) &...
        le(x,GroundBounds(2,:)), track(:,3), 'Un',0);
    [good segment] = find(vertcat(good{:}));
    trackListGround = [track(good,:) segment+nrGround];    
end
end
function data = simBrown(x0, y0, length, N, D, lagTime,px2micron)
%Simulates a set of brownian Diffuser
%
%
% INPUT:
%
% OUTPUT:
%
% written by C.P.Richter
% version 10.05.20

data = ones(length, 4, N);
data(:,3,:) = (1:length)'*ones(1,N);
data(:,4,:) = ones(length,1)*(1:N);

sigma = sqrt(2*(D/px2micron^2)*lagTime);
data(:,1:2,:) = cumsum([randn([length 1 N])...
    randn([length 1 N])]*sigma,1);

data(:,1,:) = data(:,1,:)+x0;
data(:,2,:) = data(:,2,:)+y0;

if N > 1
    data = squeeze(mat2cell(data, length, 4, ones(1,N)))';
end
end

%%global functions
function [SD maxSD minSD stepLength] = calcSD(track, calcMax, calcMin)
%Calculates the Square Displacement, max and min Square Displacement and
%timedifference between jumps
%
%
% INPUT:
%
% OUTPUT:
%
% written by C.P.Richter
% version 10.05.04
v = getappdata(1, 'values')

%preallocate space
[stepLength SD maxSD minSD] = deal(cell(1,v.tracksTotal));

for N = track
    x = repmat(v.data{N}(:,1),1,v.trackLength(N));
    y = repmat(v.data{N}(:,2),1,v.trackLength(N));
    f = repmat(v.data{N}(:,3),1,v.trackLength(N));
    
    good = tril(true(v.trackLength(N)),-1);
    
    SD{N} = ((x(good)-x(flipud(good))).^2 +...
        (y(good)-y(flipud(good))).^2)*v.px2micron^2;
    stepLength{N} = f(good)-f(flipud(good));
    
    if calcMax
        maxSD{N} = nonzeros(accumarray(stepLength{N}, SD{N},[],@max));
    end %if
    
    if calcMin
        minSD{N} = nonzeros(accumarray(stepLength{N}, SD{N},[],@min));
    end %if
    
end %for
end
function [hLine hText] = scalebar(px2micronFactor,...
    micronBarLength, barPos,...
    barColor, borderDistance, axesHandle)
%Plots a scalebar into specified axes showing microns as the distance
%metric using a defined transformationfactor for the data.
%
% INPUT:
%           px2micronFactor
%           micronBarLength (in micron)
%           barPos ('NW' for upper left and 'SW' for lower left)
%           barColor (1x3 Vektor or Matlab-specific Colorstring)
%           borderDistance (Percentage of Axisrange)
%           axesHandle
% OUTPUT:
%           hLine (handle to line object)
%           hText (handle to text object)
%
% written by C.P.Richter
% version 10.03.21

if nargin < 6
    axisLimits = get(gca,{'XLim','YLim'});
else
    axisLimits = get(axesHandle,{'XLim','YLim'});
end %if
if nargin < 5; borderDistance = 20; end %if
if nargin < 4; barColor = 'k'; end %if
if nargin < 3; barPos = 'SW'; end %if
if nargin < 2; micronBarLength = 5; end %if

switch px2micronFactor
    case '60, 1x'
        pxBarLength = micronBarLength/0.267;
    case '60, 1.6x'
        pxBarLength = micronBarLength/0.180;
    case '150, 1x'
        pxBarLength = micronBarLength/0.105;
    case '150, 1.6x'
        pxBarLength = micronBarLength/0.071;
end %switch

switch barPos
    case 'NW'
        hLine = line([axisLimits{1}(1) + (axisLimits{1}(2) - axisLimits{1}(1))/borderDistance ...
            axisLimits{1}(1) + (axisLimits{1}(2) - axisLimits{1}(1))/borderDistance + pxBarLength],...
            [axisLimits{2}(1) + (axisLimits{2}(2) - axisLimits{2}(1))/borderDistance ...
            axisLimits{2}(1) + (axisLimits{2}(2) - axisLimits{2}(1))/borderDistance]);
        
        hText = text(axisLimits{1}(1) + (axisLimits{1}(2) - axisLimits{1}(1))/borderDistance + pxBarLength/2,...
            axisLimits{2}(1) + (axisLimits{2}(2) - axisLimits{2}(1))/borderDistance, [num2str(micronBarLength),'?m']);
    case 'SW'
        hLine = line([axisLimits{1}(1) + (axisLimits{1}(2) - axisLimits{1}(1))/borderDistance ...
            axisLimits{1}(1) + (axisLimits{1}(2) - axisLimits{1}(1))/borderDistance + pxBarLength],...
            [axisLimits{2}(2) - (axisLimits{2}(2) - axisLimits{2}(1))/borderDistance ...
            axisLimits{2}(2) - (axisLimits{2}(2) - axisLimits{2}(1))/borderDistance]);
        
        hText = text(axisLimits{1}(1) + (axisLimits{1}(2) - axisLimits{1}(1))/borderDistance + pxBarLength/2,...
            axisLimits{2}(2) - (axisLimits{2}(2) - axisLimits{2}(1))/borderDistance, [num2str(micronBarLength),'?m']);
end %switch

set(hLine, 'Color', barColor, 'LineWidth', 3, 'LineStyle', '-')
set(hText, 'Color', barColor, 'FontSize', 10, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'Top')
end
function nbins = calcnbins(x, method, minimum, maximum)
% Calculate the "ideal" number of bins to use in a histogram, using a
% choice of methods.
%
% NBINS = CALCNBINS(X, METHOD) calculates the "ideal" number of bins to use
% in a histogram, using a choice of methods.  The type of return value
% depends upon the method chosen.  Possible values for METHOD are:
% 'fd': A single integer is returned, and CALCNBINS uses the
% Freedman-Diaconis method,
% based upon the inter-quartile range and number of data.
% See Freedman, David; Diaconis, P. (1981). "On the histogram as a density
% estimator: L2 theory". Zeitschrift f?r Wahrscheinlichkeitstheorie und
% verwandte Gebiete 57 (4): 453-476.

% 'scott': A single integer is returned, and CALCNBINS uses Scott's method,
% based upon the sample standard deviation and number of data.
% See Scott, David W. (1979). "On optimal and data-based histograms".
% Biometrika 66 (3): 605-610.
%
% 'sturges': A single integer is returned, and CALCNBINS uses Sturges'
% method, based upon the number of data.
% See Sturges, H. A. (1926). "The choice of a class interval". J. American
% Statistical Association: 65-66.
%
% 'middle': A single integer is returned.  CALCNBINS uses all three
% methods, then picks the middle (median) value.
%
% 'all': A structure is returned with fields 'fd', 'scott' and 'sturges',
% each containing the calculation from the respective method.
%
% NBINS = CALCNBINS(X) works as NBINS = CALCNBINS(X, 'MIDDLE').
%
% NBINS = CALCNBINS(X, [], MINIMUM), where MINIMUM is a numeric scalar,
% defines the smallest acceptable number of bins.
%
% NBINS = CALCNBINS(X, [], MAXIMUM), where MAXIMUM is a numeric scalar,
% defines the largest acceptable number of bins.
%
% Notes:
% 1. If X is complex, any imaginary components will be ignored, with a
% warning.
%
% 2. If X is an matrix or multidimensional array, it will be coerced to a
% vector, with a warning.
%
% 3. Partial name matching is used on the method name, so 'st' matches
% sturges, etc.
%
% 4. This function is inspired by code from the free software package R
% (http://www.r-project.org).  See 'Modern Applied Statistics with S' by
% Venables & Ripley (Springer, 2002, p112) for more information.
%
% 5. The "ideal" number of depends on what you want to show, and none of
% the methods included are as good as the human eye.  It is recommended
% that you use this function as a starting point rather than a definitive
% guide.
%
% 6. The wikipedia page on histograms currently gives a reasonable
% description of the algorithms used.
% See http://en.wikipedia.org/w/index.php?title=Histogram&oldid=232222820
%
% Examples:
% y = randn(10000,1);
% nb = calcnbins(y, 'all')
%    nb =
%             fd: 66
%          scott: 51
%        sturges: 15
% calcnbins(y)
%    ans =
%        51
% subplot(3, 1, 1); hist(y, nb.fd);
% subplot(3, 1, 2); hist(y, nb.scott);
% subplot(3, 1, 3); hist(y, nb.sturges);
% y2 = rand(100,1);
% nb2 = calcnbins(y2, 'all')
%    nb2 =
%             fd: 5
%          scott: 5
%        sturges: 8
% hist(y2, calcnbins(y2))
%
% See also: HIST, HISTX
%
% $ Author: Richard Cotton $		$ Date: 2008/10/24 $    $ Version 1.5 $

% Input checking
error(nargchk(1, 4, nargin));

if ~isnumeric(x) && ~islogical(x)
    error('calcnbins:invalidX', 'The X argument must be numeric or logical.')
end

if ~isreal(x)
    x = real(x);
    warning('calcnbins:complexX', 'Imaginary parts of X will be ignored.');
end

% Ignore dimensions of x.
if ~isvector(x)
    x = x(:);
    warning('calcnbins:nonvectorX', 'X will be coerced to a vector.');
end

nanx = isnan(x);
if any(nanx)
    x = x(~nanx);
    warning('calcnbins:nanX', 'Values of X equal to NaN will be ignored.');
end

if nargin < 2 || isempty(method)
    method = 'middle';
end

if ~ischar(method)
    error('calcnbins:invalidMethod', 'The method argument must be a char array.');
end

validmethods = {'fd'; 'scott'; 'sturges'; 'all'; 'middle'};
methodmatches = strmatch(lower(method), validmethods);
nmatches = length(methodmatches);
if nmatches~=1
    error('calnbins:unknownMethod', 'The method specified is unknown or ambiguous.');
end
method = validmethods{methodmatches};

if nargin < 3 || isempty(minimum)
    minimum = 1;
end

if nargin < 4 || isempty(maximum)
    maximum = Inf;
end

% Perform the calculation
switch(method)
    case 'fd'
        nbins = calcfd(x);
    case 'scott'
        nbins = calcscott(x);
    case 'sturges'
        nbins = calcsturges(x);
    case 'all'
        nbins.fd = calcfd(x);
        nbins.scott = calcscott(x);
        nbins.sturges = calcsturges(x);
    case 'middle'
        nbins = median([calcfd(x) calcscott(x) calcsturges(x)]);
end

% Calculation details
    function nbins = calcfd(x)
        h = diff(prctile0(x, [25; 75])); %inter-quartile range
        if h == 0
            h = 2*median(abs(x-median(x))); %twice median absolute deviation
        end
        if h > 0
            nbins = ceil((max(x)-min(x))/(2*h*length(x)^(-1/3)));
        else
            nbins = 1;
        end
        nbins = confine2range(nbins, minimum, maximum);
    end

    function nbins = calcscott(x)
        h = 3.5*std(x)*length(x)^(-1/3);
        if h > 0
            nbins = ceil((max(x)-min(x))/h);
        else
            nbins = 1;
        end
        nbins = confine2range(nbins, minimum, maximum);
    end

    function nbins = calcsturges(x)
        nbins = ceil(log2(length(x)) + 1);
        nbins = confine2range(nbins, minimum, maximum);
    end

    function y = confine2range(x, lower, upper)
        y = ceil(max(x, lower));
        y = floor(min(y, upper));
    end

    function y = prctile0(x, prc)
        % Simple version of prctile that only operates on vectors, and skips
        % the input checking (In particluar, NaN values are now assumed to
        % have been removed.)
        lenx = length(x);
        if lenx == 0
            y = [];
            return
        end
        if lenx == 1
            y = x;
            return
        end
        
        function foo = makecolumnvector(foo)
            if size(foo, 2) > 1
                foo = foo';
            end
        end
        
        sortx = makecolumnvector(sort(x));
        posn = prc.*lenx/100 + 0.5;
        posn = makecolumnvector(posn);
        posn = confine2range(posn, 1, lenx);
        y = interp1q((1:lenx)', sortx, posn);
    end
end
function [M, TF] = padcat(varargin)
% PADCAT - concatenate vectors with different lengths by padding with NaN
%
%   M = PADCAT(V1, V2, V3, ..., VN) concatenates the vectors V1 through VN
%   into one large matrix. All vectors should have the same orientation,
%   that is, they are all row or column vectors. The vectors do not need to
%   have the same lengths, and shorter vectors are padded with NaNs.
%   The size of M is determined by the length of the longest vector. For
%   row vectors, M will be a N-by-MaxL matrix and for column vectors, M
%   will be a MaxL-by-N matrix, where MaxL is the length of the longest
%   vector.
%
%   Examples:
%      a = 1:5 ; b = 1:3 ; c = [] ; d = 1:4 ;
%      padcat(a,b,c,d) % row vectors
%         % ->   1     2     3     4     5
%         %      1     2     3   NaN   NaN
%         %    NaN   NaN   NaN   NaN   NaN
%         %      1     2     3     4   NaN
%      CC = {d.' a.' c.' b.' d.'} ;
%      padcat(CC{:}) % column vectors
%         %      1     1   NaN     1     1
%         %      2     2   NaN     2     2
%         %      3     3   NaN     3     3
%         %      4     4   NaN   NaN     4
%         %    NaN     5   NaN   NaN   NaN
%
%   [M, TF] = PADCAT(..) will also return a logical matrix TF with the same
%   size as R having true values for those positions that originate from an
%   input vector. This may be useful if any of the vectors contain NaNs.
%
%   Example:
%       a = 1:3 ; b = [] ; c = [1 NaN] ;
%       [M,tf] = padcat(a,b,c)
%       % find the original NaN
%       [Vev,Pos] = find(tf & isnan(M))
%       % -> Vec = 3 , Pos = 2
%
%   Scalars will be concatenated into a single column vector.
%
%   See also CAT, RESHAPE, STRVCAT, CHAR, HORZCAT, VERTCAT, ISEMPTY
%            NONES, GROUP2CELL (Matlab File Exchange)

% for Matlab 2008
% version 1.0 (feb 2009)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (feb 2009) -

% Acknowledgements:
% Inspired by padadd.m (feb 2000) Fex ID 209 by Dave Johnson

error(nargchk(1,Inf,nargin)) ;

% check the inputs
SZ = cellfun(@size,varargin,'UniformOutput',false) ; % sizes
Ndim = cellfun(@ndims,varargin) ; %

if ~all(Ndim==2)
    error([mfilename ':WrongInputDimension'], ...
        'Input should be vectors.') ;
end

TF = [] ; % default second output so we do not have to check all the time

% for 2D matrices (including vectors) the size is a 1-by-2 vector
SZ = cat(1,SZ{:}) ;
maxSZ = max(SZ) ;    % probable size of the longest vector

if ~any(maxSZ == 1),  % hmm, not all elements are 1-by-N or N-by-1
    % 2 options ...
    if any(maxSZ==0),
        % 1) all inputs are empty
        M  = [] ;
        return
    else
        % 2) wrong input
        % Either not all vectors have the same orientation (row and column
        % vectors are being mixed) or an input is a matrix.
        error([mfilename ':WrongInputSize'], ...
            'Inputs should be all row vectors or all column vectors.') ;
    end
end

if nargin == 1,
    % single input, nothing to concatenate ..
    M = varargin{1} ;
else
    % If the input were row vectors stack them into one large column, for
    % column vectors stack them into one large row
    
    dim = (maxSZ(1)==1) + 1 ;      % Find out the dimension to work on
    X = cat(dim, varargin{:}) ;    % make one big list
    
    % we will use linear indexing, which operates along columns. We apply a
    % transpose at the end if the input were row vectors.
    
    if maxSZ(dim) == 1,
        % if all inputs are scalars, ...
        M = X ;   % copy the list
    elseif all(SZ(:,dim)==SZ(1,dim)),
        % all vectors have the same length
        M = reshape(X,SZ(1,dim),[]) ;% copy the list and reshape
    else
        % We do have vectors of different lengths.
        % Pre-allocate the final output array as a column oriented array. We
        % make it one larger to accommodate the largest vector as well.
        M = zeros([maxSZ(dim)+1 nargin]) ;
        % where do the fillers begin in each column
        M(sub2ind(size(M), SZ(:,dim).'+1, 1:nargin)) = 1 ;
        % Fillers should be put in after that position as well, so applying
        % cumsum on the columns
        % Note that we remove the last row; the largest vector will fill an
        % entire column.
        M = cumsum(M(1:end-1,:),1) ; % remove last row
        
        % If we need to return position of the non-fillers we will get them
        % now. We cannot do it afterwards, since NaNs may be present in the
        % inputs.
        if nargout>1,
            TF = ~M ;
            % and make use of this logical array
            M(~TF) = NaN ; % put the fillers in
            M(TF)  = X ;   % put the values in
        else
            M(M==1) = NaN ; % put the fillers in
            M(M==0) = X ;   % put the values in
        end
    end
    
    if dim == 2,
        % the inputs were row vectors, so transpose
        M = M.' ;
        TF = TF.' ; % was initialized as empty if not requested
    end
end % nargin == 1

if nargout > 1 && isempty(TF),
    % in this case, the inputs were all empty, all scalars, or all had the
    % same size.
    TF = true(size(M)) ;
end
end
function pos = figPos(ratio)

scrSize = get(0, 'ScreenSize');

if ratio > 1
    
    pos = [0.3 0.09...
        0.65*scrSize(4)/scrSize(3) 0.65/ratio];
    
elseif ratio < 1
    
    pos = [0.3 0.09...
        0.65*scrSize(4)/scrSize(3)*ratio 0.65];
    
else
    
    pos = [0.3 0.09...
        0.65*scrSize(4)/scrSize(3) 0.65];
    
end %if
end
function varExport(src, event, hFig, varList)
[selection, isSelected] =...
    listdlg(...
    'Name', 'Data 2 Excel',...
    'PromptString','Select a Variable:',...
    'OKString', 'Export',...
    'ListString',varList);
variables = getappdata(hFig, 'variables');

if isSelected
    [filename,pathname,isFile] =...
        uiputfile('.xls' ,'Save Variables to',...
        [getappdata(1,'searchPath') 'Variables.xls']);
    if isFile
        hProgressbar = waitbar(0,'Exporting...','Color',...
            get(0,'defaultUicontrolBackgroundColor'));
        warning off MATLAB:xlswrite:AddSheet
        for N = selection
            if iscell(variables{N})
                for M = 1:numel(variables{N})
                    xlswrite([pathname filename], variables{N}{M},...
                        [varList{N} num2str(M)])
                end %for
            else
                xlswrite([pathname filename], variables{N}, varList{N})
            end %if
            waitbar(N/numel(selection),hProgressbar,...
                'Exporting... ' ,'Color',...
                get(0,'defaultUicontrolBackgroundColor'));
        end %for
        delete(hProgressbar)
    end %if
end %if
end

function initializeVarList(src,event,id)
switch id
    case 'Track Movie'
        varList.saveas = 1;
        varList.visMode = false;
        varList.isScalebar = false;
        varList.valScalebar = 1000; %[nm]
        varList.isColormap = false;
        varList.isTimestamp = false;
        varList.valTimestamp = 0.032; %[s]
        varList.isRoi = false;
        varList.isShowDetect = false;
end %switch
setappdata(src,'varList',varList')
end
function settingsTrackMovie(src,event)
switch get(src,'Value')
    case 1
        varList = getappdata(src,'varList');
        
        fig =...
            figure(...
            'Tag', 'figSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.7 0.3 0.2 0.4],...
            'Color', get(0,'defaultUicontrolBackgroundColor'),...
            'Name', 'VV.settings Track Movie',...
            'NumberTitle', 'off',...
            'MenuBar', 'none',...
            'ToolBar', 'none',...
            'Resize', 'off',...
            'DeleteFcn', {@updateVarList,src,varList});
        
        uicontrol(...
            'Style', 'text',...
            'Parent', fig,...
            'Units','normalized',...
            'Position', [0.05 0.8 0.25 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'Save as:',...
            'HorizontalAlignment', 'left');
        
        uicontrol(...
            'Style', 'popupmenu',...
            'Parent', fig,...
            'Tag', 'saveasVarSetTrackMovie',...
            'Units', 'normalized',...
            'Position', [0.4 0.8 0.3 0.1],...
            'String', {'TIFF','AVI'},...
            'Value', varList.saveas,...
            'FontSize', 12,...
            'FontUnits', 'normalized');
        
        uicontrol(...
            'Style', 'checkbox',...
            'Parent', fig,...
            'Tag', 'visStyleVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.05 0.7 0.9 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'Trajactories are only visible',...
            'Value', varList.visMode);
        uicontrol(...
            'Style', 'text',...
            'Parent', fig,...
            'Units','normalized',...
            'Position', [0.15 0.6 0.8 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'during Particles ON-Time',...
            'HorizontalAlignment', 'left');
        
        uicontrol(...
            'Style', 'checkbox',...
            'Parent', fig,...
            'Tag', 'isShowDetectVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.05 0.5 0.9 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'Show Particle Detections',...
            'Value', varList.isShowDetect);
        
        uicontrol(...
            'Style', 'checkbox',...
            'Parent', fig,...
            'Tag', 'isRoiVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.05 0.4 0.9 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'Set Region of Interest',...
            'Value', varList.isRoi);
        
        uicontrol(...
            'Style', 'checkbox',...
            'Parent', fig,...
            'Tag', 'isScalebarVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.05 0.25 0.7 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'show Scalebar [nm]:',...
            'HorizontalAlignment', 'left',...
            'Value', varList.isScalebar);
        
        uicontrol(...
            'Style', 'edit',...
            'Parent', fig,...
            'Tag', 'valScalebarVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.75 0.25 0.2 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', varList.valScalebar);
        
        uicontrol(...
            'Style', 'checkbox',...
            'Parent', fig,...
            'Tag', 'isColormapVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.05 0.15 0.7 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'show Colormap',...
            'HorizontalAlignment', 'left',...
            'Value', varList.isColormap);
        
        uicontrol(...
            'Style', 'checkbox',...
            'Parent', fig,...
            'Tag', 'isTimestampVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.05 0.05 0.7 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', 'show Timestamp [s]:',...
            'HorizontalAlignment', 'left',...
            'Value', varList.isTimestamp);
        
        uicontrol(...
            'Style', 'edit',...
            'Parent', fig,...
            'Tag', 'valTimestampVarSetTrackMovie',...
            'Units','normalized',...
            'Position', [0.75 0.05 0.2 0.1],...
            'FontSize', 12,...
            'FontUnits', 'normalized',...
            'String', varList.valTimestamp);
    case 0
        delete(findobj(0,'Tag', 'figSetTrackMovie'))
end %switch

    function updateVarList(src,event,object,varList)
        varList.saveas = ...
            get(findobj(src,'Tag','saveasVarSetTrackMovie'),'Value');
        varList.visMode = ...
            get(findobj(src,'Tag','visStyleVarSetTrackMovie'),'Value');
        varList.isScalebar = ...
            get(findobj(src,'Tag','isScalebarVarSetTrackMovie'),'Value');
        varList.valScalebar = str2double(...
            get(findobj(src,'Tag','valScalebarVarSetTrackMovie'),'String'));
        varList.isColormap = ...
            get(findobj(src,'Tag','isColormapVarSetTrackMovie'),'Value');
        varList.isTimestamp = ...
            get(findobj(src,'Tag','isTimestampVarSetTrackMovie'),'Value');
        varList.valTimestamp = str2double(...
            get(findobj(src,'Tag','valTimestampVarSetTrackMovie'),'String'));
        varList.isRoi = ...
            get(findobj(src,'Tag','isRoiVarSetTrackMovie'),'Value');
        varList.isShowDetect = ...
            get(findobj(src,'Tag','isShowDetectVarSetTrackMovie'),'Value');
        
        setappdata(object,'varList', varList)
    end
end
function buildTrackMovie(src,event)
v = getappdata(1, 'values')
varList = ...
    getappdata(findobj(get(src,'Parent'),...
    'Tag','buttonSetTrackMovie'),'varList');

[filename, pathname, isOK] = uigetfile(...
    '*.tif', 'Select Background Images',getappdata(1,'searchPath'));
if isOK
    setappdata(1,'searchPath',pathname)
    info = imfinfo([pathname filename]);    
    [moviename,moviepath,isOK] =...
        uiputfile('' ,'Save Movie to',getappdata(1,'searchPath'));
    if isOK
        setappdata(1,'searchPath',moviepath)
        
        % colorcode by track
        cmap = rand(sum(v.track & v.trackActiv),3);
        
        fig =...
            figure(...
            'Tag', 'figBuildTrackMovie',...
            'Units','normalized',...
            'Position', [0.1 0.1 0.8 0.8],...
            'Color', get(0,'defaultUicontrolBackgroundColor'),...
            'Name', 'Track Movie',...
            'NumberTitle', 'off',...
            'MenuBar', 'none',...
            'ToolBar', 'none');
        ax =...
            axes(...
            'Tag', 'axBuildTrackMovie',...
            'Units','normalized',...
            'Position', [0 0 1 1],...
            'XTickLabel','',...
            'YTickLabel','',...
            'ColorOrder', cmap);
        axis image
        
        raw = double(imread([pathname filename],1,'info',info));
        imshow(raw,[min(raw(:)) max(raw(:))]);
        hImTool = imcontrast(ax);
        hAdjImButton = findobj(hImTool, 'String', 'Adjust Data');
        set(hAdjImButton, 'Callback', @getMinMax)
        uiwait(hImTool);
        minmax = evalin('base', 'imMinMax');
        
        cla(ax,'reset')
        I = uint8((raw-minmax(1))/(minmax(2)-minmax(1))*255);
        hI = imshow(I,[0 255]);
        drawnow
        
        if varList.isRoi
            setROI(fig,ax);
            roiElements = get(ax,'UserData');
            roi = get(roiElements{2},'UserData');
            delete(roiElements{1}); delete(roiElements{2})
        else
            roi = [1 1 v.settings.Width v.settings.Height];
        end %if
        I = I(roi(2):roi(2)+roi(4)-1,roi(1):roi(1)+roi(3)-1);
        
        if varList.isColormap
            I = imprintColormap([],[],I,size(I,2),5,1);
        end
        if varList.isScalebar
            I = imprintScalebar([], [], I,size(I,2),...
                size(I,1),1,varList.valScalebar,...
                v.px2micron, 1, 1);
        end %if
        if varList.isTimestamp
            I = imprintTimestamp([], [], I,...
                size(I,2),size(I,1),0, 1, 1);
        end %if
        
        set(hI,'CData',I)
        axis image
        
        trackIdx = v.track & v.trackActiv;
        activeTracks = sum(trackIdx);
        startPnt = 0;
        xCoords = nan(activeTracks,v.settings.Frames-startPnt);
        yCoords = nan(activeTracks,v.settings.Frames-startPnt);
        n = 1;
        for N = find(trackIdx)
            %check if whole trajectory is inside the roi
            if all(v.data{N}(:,1)+1 > roi(1) &...
                    v.data{N}(:,1)+1 < roi(1)+roi(3)-1 &...
                    v.data{N}(:,2)+1 > roi(2) &...
                    v.data{N}(:,2)+1 < roi(2)+roi(4)-1)
                xCoords(n,v.data{N}(:,3)-startPnt) = v.data{N}(:,1)+1;
                yCoords(n,v.data{N}(:,3)-startPnt) = v.data{N}(:,2)+1;
                n = n +1;
            else
                %discard track
                trackIdx(N) = false;
            end %if
        end %for
        %cut nan
        xCoords(n+1:end,:) = []; yCoords(n+1:end,:) = [];
        
        onState = ~isnan(xCoords);
        for N = 2:v.settings.Frames-startPnt
            xCoords(isnan(xCoords(:,N)),N)  = xCoords(isnan(xCoords(:,N)),N-1);
            yCoords(isnan(yCoords(:,N)),N) = yCoords(isnan(yCoords(:,N)),N-1);
        end %for
        lastFrame = cell2mat(...
            cellfun(@(x) x(end,3),v.data(trackIdx),'Un',0))-startPnt;
        xCoords(sub2ind(size(xCoords),1:n-1,lastFrame)) = nan;
        
        %adjust coordinates for Roi
        xCoords = xCoords-roi(1)+1; yCoords = yCoords-roi(2)+1;
        
        if varList.isShowDetect
            rho = [0;0.69;1.39;2.09;2.79;3.49;4.18;4.88;5.58;6.28];
            hDots = patch(repmat(xCoords(onState(:,1),1)',10,1)+...
                cos(rho)*repmat(2,sum(onState(:,1)),1)',...
                repmat(yCoords(onState(:,1),1)',10,1)+...
                sin(rho)*repmat(2,sum(onState(:,1)),1)',...
                repmat(shiftdim([1 0 0],-1),1,sum(onState(:,1))),...
                'EdgeColor', 'none', 'FaceAlpha', 0.3,...
                'Parent', ax);
        end %if
        
        htrack = line([xCoords(:,1),xCoords(:,1)]',[yCoords(:,1),yCoords(:,1)]',...
            'Parent', ax,'LineWidth',2);
        drawnow
        
        exportMovie([moviepath moviename],ax,'initialize',varList,1)
        
        for frame = 2:v.settings.Frames-startPnt
            raw = double(imread([pathname filename],frame,'info',info,...
                'PixelRegion',{[roi(2) roi(2)+roi(4)-1],...
                [roi(1) roi(1)+roi(3)-1]}));
            I = uint8((raw-minmax(1))/(minmax(2)-minmax(1))*255);
            
            if varList.isColormap
                I = imprintColormap([],[],I,size(I,2),5,1);
            end
            if varList.isScalebar
                I = imprintScalebar([], [], I,size(I,2),...
                    size(I,1),1,varList.valScalebar,...
                    v.px2micron, 1, 1);
            end %if
            if varList.isTimestamp
                I = imprintTimestamp([], [], I,...
                    size(I,2),size(I,1),v.settings.Delay*(frame-1), 1, 1);
            end %if
            set(hI,'CData',I)
            
            if varList.isShowDetect
                set(hDots, 'XData', repmat(xCoords(onState(:,frame),frame)',10,1)+...
                    cos(rho)*repmat(2,sum(onState(:,frame)),1)',...
                    'YData', repmat(yCoords(onState(:,frame),frame)',10,1)+...
                    sin(rho)*repmat(2,sum(onState(:,frame)),1)',...
                    'CData', repmat(shiftdim([1 0 0],-1),1,sum(onState(:,frame))))
            end %if
            
            if varList.visMode
                good = ~isnan(xCoords(:,frame));
                set(htrack(good),{'XData',},num2cell(xCoords(good,1:frame),2),...
                    {'YData',},num2cell(yCoords(good,1:frame),2))
                set(htrack(~isnan(xCoords(:,frame-1)) & ~good),'Visible','off');
            else
                set(htrack,{'XData',},num2cell(xCoords(:,1:frame),2),...
                    {'YData',},num2cell(yCoords(:,1:frame),2))
            end %if
            drawnow
            
            exportMovie([moviepath moviename],ax,'append',varList,frame)
        end %for
        exportMovie([moviepath moviename],ax,'finalize',varList,frame)
    end %if
    delete(fig)
    msgbox('Movie Export Done!')
end %if

    function getMinMax(src, event)
        hList = findobj(hImTool, 'Style', 'edit');
        imMinMax = [str2double(get(hList(7), 'String'))...
            str2double(get(hList(6), 'String'))];
        assignin('base', 'imMinMax', imMinMax)
        close(gcbf)
    end
end
function exportMovie(filename,ax,mode,varList,frame)
persistent hMovie

v = getappdata(1, 'values')
format = {'tif','avi'};
format = format{varList.saveas};

I = getframe(ax);

switch format
    case 'tif'
        imwrite(I.cdata,[filename '.tif'],...
            'compression', 'none', 'WriteMode', 'append')
    case 'gif'
        I.cdata = rgb2ind(I.cdata,gray(256));
        imwrite(I.cdata,[filename '.gif'],...
            'WriteMode', 'append')
    case 'avi'
        switch mode
            case 'initialize'
                ...hMovie = avifile(filename,...
                    ...'Colormap', gray(256),...
                    ...'Compression', 'none',...
                    ...'fps', 32);
                hMovie = VideoWriter(filename);
                ...hMovie = addframe(hMovie, I.cdata);
                open(hMovie);
                writeVideo(hMovie,I.cdata)
            case 'append'
                ...hMovie = addframe(hMovie, I.cdata);
                open(hMovie);
                writeVideo(hMovie,I.cdata)
            case 'finalize'
                ...hMovie = close(hMovie);
                close(hMovie);
        end %switch
end %switch
end %function

function I = imprintColormap(src, event, I, width, mapHeight, mode)
if mode == 1
    colorRamp = repmat(round(linspace(0, 255, width)),...
        mapHeight,1);
    I(end-mapHeight+1:end,:) = colorRamp;
else
    cmapWidth = floor(width/4);
    colorRamp = round(linspace(0, 255, cmapWidth));
    colorRamp = repmat([colorRamp,...
        ones(1,cmapWidth)*255, fliplr(colorRamp),...
        zeros(1,width-3*cmapWidth)],mapHeight,1);
    if mode == 3
        colorRamp3D = repmat(round(linspace(0, 255,...
            mapHeight))',1,width);
        I(end-mapHeight+1:end,:,:) =...
            cat(3,colorRamp, fliplr(colorRamp), colorRamp3D);
    else
        I(end-mapHeight+1:end,:,:) =...
            cat(3,colorRamp, fliplr(colorRamp), colorRamp*0);
    end %if
end %if
end
function I = imprintScalebar(src, event, I, width, height,...
    exf, barLength, pxSize, sizeFac, mode)
barUnit = pxChars(height,width,...
    [num2str(barLength) 'nm'],sizeFac);

pxBarLength = round(barLength/(1000*pxSize/exf));
pxBarHeight = ceil(max(exf/3,pxBarLength/20));
bar = ones(pxBarHeight,pxBarLength);

tmp = size(bar,2)-size(barUnit,2);
if tmp > 0
    bar = [[zeros(size(barUnit,1),floor(tmp/2)),...
        barUnit, zeros(size(barUnit,1),ceil(tmp/2))];...
        zeros(2,size(bar,2)); bar];
elseif tmp < 0
    bar = [barUnit;zeros(2,size(barUnit,2));...
        [zeros(pxBarHeight,floor(-tmp/2)),bar,...
        zeros(pxBarHeight,ceil(-tmp/2))]];
else
    bar = [barUnit;zeros(2,size(bar,2));bar];
end %sif

barOffsetX = 4*pxBarHeight;
barOffsetY = 4*pxBarHeight;
offset = height*(width-(size(bar,2)+barOffsetX))+barOffsetY;
idx = find([bar;zeros(height-size(bar,1),...
    size(bar,2))])+offset;

if mode == 1
    I(idx) = 255;
else
    I([idx;idx+height*width;idx+2*height*width]) = 255;
end %if
end
function I = imprintTimestamp(src, event, I, width, height,...
    time, sizeFac, mode)
stamp = pxChars(height,width,...
    [strrep(num2str(time, '%.3f'),'.','p') '_S'],...
    sizeFac);

barOffsetX = ceil(max(sizeFac*2,size(stamp,2)/5));
barOffsetY = barOffsetX;

idx = find([stamp;zeros(height-size(stamp,1),size(stamp,2))])+...
    barOffsetX*height+barOffsetY;
if mode == 1
    I(idx) = 255;
else
    I([idx;idx+height*width;idx+2*height*width]) = 255;
end %if
end
function string = pxChars(N,M,num,scaleFactor) %#ok
n_ = [...
    0 0;...
    0 0;...
    0 0;...
    0 0;...
    0 0] ;%#ok

np = [...
    0;...
    0;...
    0;...
    0;...
    1] ;%#ok

n0 = [...
    1 1 1;...
    1 0 1;...
    1 0 1;...
    1 0 1;...
    1 1 1] ;%#ok
n1 = [...
    0 1 0;...
    0 1 0;...
    0 1 0;...
    0 1 0;...
    0 1 0] ;%#ok
n2= [...
    1 1 1;...
    0 0 1 ;...
    1 1 1;...
    1 0 0;...
    1 1 1] ;%#ok
n3= [...
    1 1 1;...
    0 0 1 ;...
    0 1 1;...
    0 0 1;...
    1 1 1] ;%#ok
n4= [...
    1 0 1;...
    1 0 1 ;...
    1 1 1;...
    0 0 1;...
    0 0 1] ;%#ok
n5 = [...
    1 1 1;...
    1 0 0;...
    1 1 1;...
    0 0 1;...
    1 1 1] ;%#ok
n6= [...
    1 1 1;...
    1 0 0 ;...
    1 1 1;...
    1 0 1;...
    1 1 1] ;%#ok
n7 = [...
    1 1 1;...
    0 0 1;...
    0 1 0;...
    0 1 0;...
    0 1 0] ;%#ok
n8 = [...
    1 1 1;...
    1 0 1;...
    1 1 1;...
    1 0 1;...
    1 1 1] ;%#ok
n9 = [...
    1 1 1;...
    1 0 1;...
    1 1 1;...
    0 0 1;...
    1 1 1] ;%#ok

nA = [...
    0 1 1 1 0;...
    1 0 0 0 1;...
    1 1 1 1 1;...
    1 0 0 0 1;...
    1 0 0 0 1] ;%#ok

nB = [...
    1 1 1 1 0;...
    1 0 0 0 1;...
    1 1 1 1 0;...
    1 0 0 0 1;...
    1 1 1 1 0] ;%#ok

nC = [...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 0 0 0 0;...
    1 0 0 0 0;...
    1 1 1 1 1] ;%#ok

nD = [...
    1 1 1 1 0;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 1 1 1 0] ;%#ok

nE = [...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 1 1 1 1] ;%#ok

nF = [...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 0 0 0 0] ;%#ok

nG = [...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 0 1 1 1;...
    1 0 0 0 1;...
    1 1 1 1 1] ;%#ok

nH = [...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 1 1 1 1;...
    1 0 0 0 1;...
    1 0 0 0 1] ;%#ok

nI = [...
    0 1 1 1 0;...
    0 0 1 0 0;...
    0 0 1 0 0;...
    0 0 1 0 0;...
    0 1 1 1 0] ;%#ok

nJ = [...
    1 1 1 1 1;...
    0 0 0 0 1;...
    0 0 0 0 1;...
    1 0 0 0 1;...
    0 1 1 1 0] ;%#ok

nK = [...
    1 0 0 0 1;...
    1 0 0 1 0;...
    1 1 1 0 0;...
    1 0 0 1 0;...
    1 0 0 0 1] ;%#ok

nL = [...
    1 0 0 0 0;...
    1 0 0 0 0;...
    1 0 0 0 0;...
    1 0 0 0 0;...
    1 1 1 1 1] ;%#ok

nM = [...
    1 1 0 1 1;...
    1 0 1 0 1;...
    1 0 1 0 1;...
    1 0 0 0 1;...
    1 0 0 0 1] ;%#ok

nN = [...
    1 0 0 0 1;...
    1 1 0 0 1;...
    1 0 1 0 1;...
    1 0 0 1 1;...
    1 0 0 0 1] ;%#ok

nO = [...
    0 1 1 1 0;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    0 1 1 1 0] ;%#ok

nP = [...
    1 1 1 1 0;...
    1 0 0 0 1;...
    1 1 1 1 0;...
    1 0 0 0 0;...
    1 0 0 0 0] ;%#ok

nQ = [...
    0 1 1 1 0;...
    1 0 0 0 1;...
    1 0 1 0 1;...
    1 0 0 1 0;...
    0 1 1 0 1] ;%#ok

nR = [...
    1 1 1 1 0;...
    1 0 0 0 1;...
    1 1 1 1 0;...
    1 0 0 1 0;...
    1 0 0 0 1] ;%#ok

nS = [...
    1 1 1 1 1;...
    1 0 0 0 0;...
    1 1 1 1 1;...
    0 0 0 0 1;...
    1 1 1 1 1] ;%#ok

nT = [...
    1 1 1 1 1;...
    0 0 1 0 0;...
    0 0 1 0 0;...
    0 0 1 0 0;...
    0 0 1 0 0] ;%#ok

nU = [...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    0 1 1 1 0] ;%#ok

nV = [...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 0 0 0 1;...
    0 1 0 1 0;...
    0 0 1 0 0] ;%#ok

nW = [...
    1 0 0 0 1;...
    1 0 0 0 1;...
    1 0 1 0 1;...
    1 0 1 0 1;...
    0 1 0 1 0] ;%#ok

nX = [...
    1 0 0 0 1;...
    0 1 0 1 0;...
    0 0 1 0 0;...
    0 1 0 1 0;...
    1 0 0 0 1] ;%#ok

nY = [...
    1 0 0 0 1;...
    0 1 0 1 0;...
    0 0 1 0 0;...
    0 0 1 0 0;...
    0 0 1 0 0] ;%#ok

nZ = [...
    1 1 1 1 1;...
    0 0 0 1 0;...
    0 0 1 0 0;...
    0 1 0 0 0;...
    1 1 1 1 1] ;%#ok

nm = [...
    0 0 0 0 0;...
    0 0 0 0 0;...
    0 1 0 1 0;...
    1 0 1 0 1;...
    1 0 1 0 1] ;%#ok

nn = [...
    0 0 0;...
    0 0 0;...
    0 1 0;...
    1 0 1;...
    1 0 1] ;%#ok

strnum = num2str(num) ;


string = eval(sprintf('imresize(n%s,scaleFactor)>0.5;', strnum(1)));
for c=2:size(strnum, 2)
    string = [string, zeros(5*scaleFactor,1),...
        eval(sprintf('imresize(n%s,scaleFactor)>0.5;', strnum(c)))];
end%for
end%function
function setROI(hFig,hAx)
hRoi = imrect(hAx);
hPatch = findobj(hRoi,'Type','patch');
set(hPatch,'FaceColor', [1 1 1],...
    'FaceAlpha', 0.3)

pos = ceil(getPosition(hRoi)-0.5);
hText = text(pos(1), pos(2),...
    sprintf([' x = ' num2str(round(pos(1))) '\n',...
    ' y = ' num2str(round(pos(2))) '\n',...
    ' width = ' num2str(ceil(pos(3)+(pos(1)-0.5-floor(pos(1)-0.5)))) '\n',...
    ' height = ' num2str(ceil(pos(4)+(pos(2)-0.5-floor(pos(2)-0.5))))]),...
    'FontSize', 8,...
    'FontWeight', 'bold',...
    'Color', [0 1 0],...
    'VerticalAlignment', 'top',...
    'Tag', 'roi',...
    'UserData', [round(pos(1)) round(pos(2))...
    ceil(pos(3)+(pos(1)-0.5-floor(pos(1)-0.5)))...
    ceil(pos(4)+(pos(2)-0.5-floor(pos(2)-0.5)))]);
addNewPositionCallback(hRoi,@posInfo);
cnstrnts = get(hAx,{'XLim','YLim'});
fcn = makeConstrainToRectFcn('imrect',...
    cnstrnts{1}+[eps -eps], cnstrnts{2}+[eps -eps]);
setPositionConstraintFcn(hRoi,fcn);
set(hAx,'UserData',{hRoi,hText})
%         h = getappdata(src,'handles');
%         delete(h{1}); delete(h{2})
    function posInfo(pos)
        set(hText, 'Position', [round(pos(1)) round(pos(2)) 0],...
            'String', sprintf([...
            ' x = ' num2str(round(pos(1))) '\n',...
            ' y = ' num2str(round(pos(2))) '\n',...
            ' width = ' num2str(ceil(pos(3)+(pos(1)-0.5-floor(pos(1)-0.5)))) '\n',...
            ' height = ' num2str(ceil(pos(4)+(pos(2)-0.5-floor(pos(2)-0.5))))]),...
            'UserData', [round(pos(1)) round(pos(2))...
            ceil(pos(3)+(pos(1)-0.5-floor(pos(1)-0.5)))...
            ceil(pos(4)+(pos(2)-0.5-floor(pos(2)-0.5)))])
    end
end

function CBH = cbfreeze(varargin)
%CBFREEZE   Freezes the colormap of a colorbar.
%
%   SYNTAX:
%           cbfreeze
%           cbfreeze('off')
%           cbfreeze(H,...)
%     CBH = cbfreeze(...);
%
%   INPUT:
%     H     - Handles of colorbars to be freezed, or from figures to search
%             for them or from peer axes (see COLORBAR).
%             DEFAULT: gcf (freezes all colorbars from the current figure)
%     'off' - Unfreezes the colorbars, other options are:
%               'on'    Freezes
%               'un'    same as 'off'
%               'del'   Deletes the colormap(s).
%             DEFAULT: 'on' (of course)
%
%   OUTPUT (all optional):
%     CBH - Color bar handle(s).
%
%   DESCRIPTION:
%     MATLAB works with a unique COLORMAP by figure which is a big
%     limitation. Function FREEZECOLORS by John Iversen allows to use
%     different COLORMAPs in a single figure, but it fails freezing the
%     COLORBAR. This program handles this problem.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * If no colorbar is found, one is created.
%     * The new frozen colorbar is an axes object and does not behaves
%       as normally colorbars when resizing the peer axes. Although, some
%       time the normal behavior is not that good.
%     * Besides, it does not have the 'Location' property anymore.
%     * But, it does acts normally: no ZOOM, no PAN, no ROTATE3D and no
%       mouse selectable.
%     * No need to say that CAXIS and COLORMAP must be defined before using
%       this function. Besides, the colorbar location. Anyway, 'off' or
%       'del' may help.
%     * The 'del' functionality may be used whether or not the colorbar(s)
%       is(are) froozen. The peer axes are resized back. Try: 
%        >> colorbar, cbfreeze del
%
%   EXAMPLE:
%     surf(peaks(30))
%     colormap jet
%     cbfreeze
%     colormap gray
%     title('What...?')
%
%   SEE ALSO:
%     COLORMAP, COLORBAR, CAXIS
%     and
%     FREEZECOLORS by John Iversen
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbfreeze.m
%   VERSION: 1.1 (Sep 02, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)
%   1.1      Fixed BUG with image handle on MATLAB R2009a. Thanks to Sergio
%            Muniz. (Sep 02, 2009)

%   DISCLAIMER:
%   cbfreeze.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Parameters:
cbappname = 'Frozen';         % Colorbar application data with fields:
                              % 'Location' from colorbar
                              % 'Position' from peer axes befor colorbar
                              % 'pax'      handle from peer axes.
axappname = 'FrozenColorbar'; % Peer axes application data with frozen
                              % colorbar handle.
 
% Set defaults:
S = 'on';                   Sopt = {'on','un','off','del'};
H = get(0,'CurrentFig');

% Check inputs:
if nargin==2 && (~isempty(varargin{1}) && all(ishandle(varargin{1})) && ...
  isempty(varargin{2}))
 
 % Check for CallBacks functionalities:
 % ------------------------------------
 
 varargin{1} = double(varargin{1});
 
 if strcmp(get(varargin{1},'BeingDelete'),'on') 
  % Working as DeletFcn:

  if (ishandle(get(varargin{1},'Parent')) && ...
      ~strcmpi(get(get(varargin{1},'Parent'),'BeingDeleted'),'on'))
    % The handle input is being deleted so do the colorbar:
    S = 'del'; 
    
   if ~isempty(getappdata(varargin{1},cbappname))
    % The frozen colorbar is being deleted:
    H = varargin{1};
   else
    % The peer axes is being deleted:
    H = ancestor(varargin{1},{'figure','uipanel'}); 
   end
   
  else
   % The figure is getting close:
   return
  end
  
 elseif (gca==varargin{1} && ...
                     gcf==ancestor(varargin{1},{'figure','uipanel'}))
  % Working as ButtonDownFcn:
  
  cbfreezedata = getappdata(varargin{1},cbappname);
  if ~isempty(cbfreezedata) 
   if ishandle(cbfreezedata.ax)
    % Turns the peer axes as current (ignores mouse click-over):
    set(gcf,'CurrentAxes',cbfreezedata.ax);
    return
   end
  else
   % Clears application data:
   rmappdata(varargin{1},cbappname) 
  end
  H = varargin{1};
 end
 
else
 
 % Checks for normal calling:
 % --------------------------
 
 % Looks for H:
 if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
  H = varargin{1};
  varargin(1) = [];
 end

 % Looks for S:
 if ~isempty(varargin) && (isempty(varargin{1}) || ischar(varargin{1}))
  S = varargin{1};
 end
end

% Checks S:
if isempty(S)
 S = 'on';
end
S = lower(S);
iS = strmatch(S,Sopt);
if isempty(iS)
 error('CVARGAS:cbfreeze:IncorrectStringOption',...
  ['Unrecognized ''' S ''' argument.' ])
else
 S = Sopt{iS};
end

% Looks for CBH:
CBH = cbhandle(H);

if ~strcmp(S,'del') && isempty(CBH)
 % Creates a colorbar and peer axes:
 pax = gca;
 CBH = colorbar('peer',pax);
else
 pax = [];
end


% -------------------------------------------------------------------------
% MAIN 
% -------------------------------------------------------------------------
% Note: only CBH and S are necesary, but I use pax to avoid the use of the
%       "hidden" 'Axes' COLORBAR's property. Why... ??

% Saves current position:
fig = get(  0,'CurrentFigure');
cax = get(fig,'CurrentAxes');

% Works on every colorbar:
for icb = 1:length(CBH)
 
 % Colorbar axes handle:
 h  = double(CBH(icb));
 
 % This application data:
 cbfreezedata = getappdata(h,cbappname);
 
 % Gets peer axes:
 if ~isempty(cbfreezedata)
  pax = cbfreezedata.pax;
  if ~ishandle(pax) % just in case
   rmappdata(h,cbappname)
   continue
  end
 elseif isempty(pax) % not generated
  try
   pax = double(get(h,'Axes'));  % NEW feature in COLORBARs
  catch
   continue
  end
 end
 
 % Choose functionality:
 switch S
  
  case 'del'
   % Deletes:
   if ~isempty(cbfreezedata)
    % Returns axes to previous size:
    oldunits = get(pax,'Units');
    set(pax,'Units','Normalized');
    set(pax,'Position',cbfreezedata.Position)
    set(pax,'Units',oldunits)
    set(pax,'DeleteFcn','')
    if isappdata(pax,axappname)
     rmappdata(pax,axappname)
    end
   end
   if strcmp(get(h,'BeingDelete'),'off') 
    delete(h)
   end
   
  case {'un','off'}
   % Unfrozes:
   if ~isempty(cbfreezedata)
    delete(h);
    set(pax,'DeleteFcn','')
    if isappdata(pax,axappname)
     rmappdata(pax,axappname)
    end
    oldunits = get(pax,'Units');
    set(pax,'Units','Normalized')
    set(pax,'Position',cbfreezedata.Position)
    set(pax,'Units',oldunits)
    CBH(icb) = colorbar(...
     'peer'    ,pax,...
     'Location',cbfreezedata.Location);
   end
 
  otherwise % 'on'
   % Freezes:
 
   % Gets colorbar axes properties:
   cb_prop  = get(h);
   
   % Gets colorbar image handle. Fixed BUG, Sep 2009
   hi = findobj(h,'Type','image');
    
   % Gets image data and transform it in a RGB:
   CData = get(hi,'CData'); 
   if size(CData,3)~=1
    % It's already frozen:
    continue
   end
  
   % Gets image tag:
   Tag = get(hi,'Tag');
  
   % Deletes previous colorbar preserving peer axes position:
   oldunits = get(pax,'Units');
              set(pax,'Units','Normalized')
   Position = get(pax,'Position');
   delete(h)
   cbfreezedata.Position = get(pax,'Position');
              set(pax,'Position',Position)
              set(pax,'Units',oldunits)
  
   % Generates new colorbar axes:
   % NOTE: this is needed because each time COLORMAP or CAXIS is used,
   %       MATLAB generates a new COLORBAR! This eliminates that behaviour
   %       and is the central point on this function.
   h = axes(...
    'Parent'  ,cb_prop.Parent,...
    'Position',cb_prop.Position...
   );
  cb_prop
   % Save location for future call:
   cbfreezedata.Location = cb_prop.Location;
  
   % Move ticks because IMAGE draws centered pixels:
   XLim = cb_prop.XLim;
   YLim = cb_prop.YLim;
   if     isempty(cb_prop.XTick)
    % Vertical:
    X = XLim(1) + diff(XLim)/2;
    Y = YLim    + diff(YLim)/(2*length(CData))*[+1 -1];
   else % isempty(YTick)
    % Horizontal:
    Y = YLim(1) + diff(YLim)/2;
    X = XLim    + diff(XLim)/(2*length(CData))*[+1 -1];
   end
  
   % Draws a new RGB image:
   image(X,Y,ind2rgb(CData,colormap),...
    'Parent'            ,h,...
    'HitTest'           ,'off',...
    'Interruptible'     ,'off',...
    'SelectionHighlight','off',...
    'Tag'               ,Tag...
   )  

   % Removes all   '...Mode'   properties:
   cb_fields = fieldnames(cb_prop);
   indmode   = strfind(cb_fields,'Mode');
   for k=1:length(indmode)
    if ~isempty(indmode{k})
     cb_prop = rmfield(cb_prop,cb_fields{k});
    end
   end
   
   % Removes special COLORBARs properties:
   cb_prop = rmfield(cb_prop,{...
    'CurrentPoint','TightInset','BeingDeleted','Type',...       % read-only
    'Title','XLabel','YLabel','ZLabel','Parent','Children',...  % handles
    'UIContextMenu','Location',...                              % colorbars
    'ButtonDownFcn','DeleteFcn',...                             % callbacks
    'CameraPosition','CameraTarget','CameraUpVector','CameraViewAngle',...
    'PlotBoxAspectRatio','DataAspectRatio','Position',... 
    'XLim','YLim','ZLim'});
   
   % And now, set new axes properties almost equal to the unfrozen
   % colorbar:
   set(h,cb_prop)

   % CallBack features:
   set(h,...
    'ActivePositionProperty','position',...
    'ButtonDownFcn'         ,@cbfreeze,...  % mhh...
    'DeleteFcn'             ,@cbfreeze)     % again
   set(pax,'DeleteFcn'      ,@cbfreeze)     % and again!  
  
   % Do not zoom or pan or rotate:
   setAllowAxesZoom  (zoom    ,h,false)
   setAllowAxesPan   (pan     ,h,false)
   setAllowAxesRotate(rotate3d,h,false)
   
   % Updates data:
   CBH(icb) = h;   

   % Saves data for future undo:
   cbfreezedata.pax       = pax;
   setappdata(  h,cbappname,cbfreezedata);
   setappdata(pax,axappname,h);
   
 end % switch functionality   

end  % MAIN loop


% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

% Output?:
if ~nargout
 clear CBH
else
 CBH(~ishandle(CBH)) = [];
end

% Returns current axes:
if ishandle(cax) 
 set(fig,'CurrentAxes',cax)
end
end
function CBH = cbfit(varargin)
%CBFIT   Draws a colorbar with specific color bands between its ticks.
% 
%   SYNTAX:
%           cbfit
%           cbfit(NBANDS)               % May be LBANDS instead of NBANDS
%           cbfit(NBANDS,CENTER)
%           cbfit(...,MODE)
%           cbfit(...,OPT)
%           cbfit(CBH,...)
%     CBH = cbfit(...);
%
%   INPUT:
%     NBANDS - Draws a colorbar with NBANDS bands colors between each tick
%      or      mark or a colorband between the specifies level bands
%     LBANDS   (LBANDS=NBANDS).
%              DEFAULT: 5     
%     CENTER - Center the colormap to this CENTER reference.
%              DEFAULT: [] (do not centers)
%     MODE   - Specifies the ticks mode (should be before AP,AV). One of:
%                'manual' - Forces color ticks on the new bands. 
%                'auto'   - Do not forces
%              DEFAULT: 'auto'
%     OPT    - Normal optional arguments of the COLORBAR function (should
%              be the last arguments).
%              DEFAULT: none.
%     CBH    - Uses this colorbar handle instead of current one.
%
%   OUTPUT (all optional):
%     CBH  - Returns the colorbar axes handle.
%
%   DESCRIPTION:
%     Draws a colorbar with specified number of color bands between its
%     ticks by modifying the current colormap and caxis.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * Sets the color limits, CAXIS, and color map, COLORMAP, before using
%       this function. Use them after this function to get the
%       modifications.
%
%   EXAMPLE:
%     figure, surf(peaks+2), colormap(jet(14)), colorbar
%      title('Normal colorbar.m')
%     figure, surf(peaks+2),                    cbfit(2,0)
%      title('Fitted 2 color bands and centered on zero')
%     figure, surf(peaks+2), caxis([0 10]),     cbfit(4,8)
%      title('Fitted 4 color bands and centered at 8')
%
%   SEE ALSO:
%     COLORBAR
%     and
%     CBFREEZE, CMFIT by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbfit.m
%   VERSION: 2.1 (Sep 30, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released as COLORBARFIT.M. (Mar 11, 2008)
%   1.1      Fixed bug when CAXIS is used before this function. (Jul 01,
%            2008)
%   1.2      Works properly when CAXIS is used before this function. Bug
%            fixed on subfunction and rewritten code. (Aug 21, 2008)
%   2.0      Rewritten code. Instead of the COLORBAND subfunction, now uses
%            the CMFIT function. Changed its name from COLORBARFIT to
%            CBFIT. (Jun 08, 2008)
%   2.1      Fixed bug and help with CBH input. (Sep 30, 2009)

%   DISCLAIMER:
%   cbfit.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2008,2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Sets defaults:
NBANDS = 5;
CENTER = [];
MODE   = 'auto';            
CBH    = [];
pax    = [];        % Peer axes

% Checks if first argument is a handle: Fixed bug Sep 2009
if (~isempty(varargin) && (length(varargin{1})==1) && ...
  ishandle(varargin{1})) && strcmp(get(varargin{1},'Type'),'axes')
 if strcmp(get(varargin{1},'Tag'),'Colorbar')
  CBH = varargin{1};
 else
  warning('CVARGAS:cbfit:incorrectHInput',...
   'Unrecognized first input handle.')
 end
 varargin(1) = [];
end
 
% Reads NBANDS and CENTER:
if ~isempty(varargin) && isnumeric(varargin{1})
 if ~isempty(varargin{1})
  NBANDS = varargin{1};
 end
 if (length(varargin)>1) && isnumeric(varargin{2})
  CENTER = varargin{2};
  varargin(2) = [];
 end
 varargin(1) = [];
end

% Reads MODE:
if (~isempty(varargin) && (rem(length(varargin),2)==1))
 if (~isempty(varargin{1}) && ischar(varargin{1}))
  switch lower(varargin{1})
   case 'auto'  , MODE = 'auto';
   case 'manual', MODE = 'manual';
   otherwise % 'off', 'hide' and 'delete'
    warning('CVARGAS:cbfit:incorrectStringInput',...
     'No pair string input must be one of ''auto'' or ''manual''.')
  end
 end
 varargin(1) = [];
end

% Reads peer axes:
for k = 1:2:length(varargin)
 if ~isempty(varargin{k})
  switch lower(varargin{k})
   case 'peer', pax = varargin{k+1}; break
  end
 end
end
if isempty(pax)
 pax = gca;
end

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% Generates a preliminary colorbar:
if isempty(CBH)
 CBH = colorbar(varargin{:});
end

% Gets limits and orientation:
s     = 'Y';
ticks = get(CBH,[s 'Tick']);
if isempty(ticks)             
 s     = 'X';
 ticks = get(CBH,[s 'Tick']);
end
zlim = get(CBH,[s 'Lim']);

% Gets width and ref:
if ~isempty(NBANDS)

 NL = length(NBANDS);
 
 if (NL==1)
  
  % Force positive integers:
  NBANDS = round(abs(NBANDS));
 
  % Ignores ticks outside the limits:
  if zlim(1)>ticks(1)
   ticks(1) = [];
  end
  if zlim(2)<ticks(end)
   ticks(end) = [];
  end

  % Get the ticks step and colorband:
  tstep = ticks(2)-ticks(1);
  WIDTH = tstep/NBANDS;
  
  % Sets color limits
  if strcmp(get(pax,'CLimMode'),'auto')
   caxis(zlim);
  end
  
  % Forces old colorbar ticks: 
  set(CBH,[s 'Lim'],zlim,[s 'Tick'],ticks)
  
  % Levels:
  if strcmp(MODE,'manual')
   LBANDS = [fliplr(ticks(1)-WIDTH:-WIDTH:zlim(1)) ticks(1):WIDTH:zlim(2)];
  end
  
 else
  
  % Nonlinear colorbar:
  ticks = NBANDS;
  WIDTH = ticks;
  
  % Scales to CLIM:
  if strcmp(get(pax,'CLimMode'),'manual')
   ticks = ticks-ticks(1);
   ticks = ticks/ticks(end);
   ticks = ticks*diff(zlim) + zlim(1);
  end
  zlim = [ticks(1) ticks(end)];
  caxis(pax,zlim)
  CBIH = get(CBH,'Children');
  
  % Change ticks:
  set(CBIH,[s 'Data'],ticks)
  
  % Sets limits:
  set(CBH,[s 'Lim'],zlim)
  
  % Levels:
  if strcmp(MODE,'manual')
   LBANDS = NBANDS;
  end
  
 end
 
 % Get reference mark
 if ~isempty(CENTER)
  REF    = CENTER;
  CENTER = true;
 else
  REF    = ticks(1);
  CENTER = false;
 end
  
end

% Fits the colormap and limits:
cmfit(get(get(pax,'Parent'),'Colormap'),zlim,WIDTH,REF,CENTER)

% Sets ticks:
if strcmp(MODE,'manual')
 set(CBH,[s 'Tick'],LBANDS)
end

% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

if ~nargout
 clear CBH
end
end
function CBH = cbhandle(varargin)
%CBHANDLE   Handle of current colorbar axes.
%
%   SYNTAX:
%     CBH = cbhandle;
%     CBH = cbhandle(H);
%
%   INPUT:
%     H - Handles axes, figures or uipanels to look for colorbars.
%         DEFAULT: gca (current axes)
%
%   OUTPUT:
%     CBH - Color bar handle(s).
%
%   DESCRIPTION:
%     By default, color bars are hidden objects. This function searches for
%     them by its 'axes' type and 'Colorbar' tag.
%    
%   SEE ALSO:
%     COLORBAR
%     and
%     CBUNITS, CBLABEL, CBFREEZE by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbhandle.m
%   VERSION: 1.1 (Aug 20, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)
%   1.1      Fixed bug with colorbar handle input. (Aug 20, 2009)

%   DISCLAIMER:
%   cbhandle.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Parameters:
axappname = 'FrozenColorbar'; % Peer axes application data with frozen
                              % colorbar handle.

% Sets default:
H = get(get(0,'CurrentFigure'),'CurrentAxes');

if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
 H = varargin{1};
end

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% Looks for CBH:
CBH = [];
% set(0,'ShowHiddenHandles','on')
for k = 1:length(H)
 switch get(H(k),'type')
  case {'figure','uipanel'}
   % Parents axes?:
   CBH = [CBH; ...
    findobj(H(k),'-depth',1,'Tag','Colorbar','-and','Type','axes')];
  case 'axes'
   % Peer axes?:
   hin  = double(getappdata(H(k),'LegendColorbarInnerList'));
   hout = double(getappdata(H(k),'LegendColorbarOuterList'));
   if     (~isempty(hin)  && ishandle(hin))
    CBH = [CBH; hin];
   elseif (~isempty(hout) && ishandle(hout))
    CBH = [CBH; hout];
   elseif isappdata(H(k),axappname)
    % Peer from frozen axes?:
    CBH = [CBH; double(getappdata(H(k),axappname))];
   elseif strcmp(get(H(k),'Tag'),'Colorbar') % Fixed BUG Aug 2009
    % Colorbar axes?
    CBH = [CBH; H(k)];
   end
  otherwise
   % continue
 end
end
end
function CBLH = cblabel(varargin)
%CBLABEL   Adds a label to the colorbar.
%
%   SYNTAX:
%            cblabel(LABEL)
%            cblabel(LABEL,..,TP,TV);
%            cblabel(H,...)
%     CBLH = cblabel(...);
%
%   INPUT:
%     LABEL - String (or cell of strings) specifying the colorbar label.
%     TP,TV - Optional text property/property value arguments (in pairs).
%             DEFAULT:  (none)
%     H     - Color bar or peer axes (see COLORBAR) or figure handle(s) to
%             search for a single color bar handle.
%             DEFAULT: gca (current axes color bar)
%
%   OUTPUT (all optional):
%     CBLH  - Returns the colorbar label handle(s).
%           - Labels modified on the colorbar of the current figure or
%             the one(s) specified by CBH.
%
%   DESCRIPTION:
%     This function sets the label of the colorbar(s) in the current
%     figure.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%
%   EXAMPLE:
%     figure, colorbar, cblabel(['           T, ?C'],'Rotation',0)
%     figure
%      subplot(211), h1 = colorbar;
%      subplot(212), h2 = colorbar('Location','south');
%      cblabel([h1 h2],{'$1-\alpha$','$\beta^3$'},'Interpreter','latex')   
%
%   SEE ALSO: 
%     COLORBAR
%     and 
%     CBUNITS, CBHANDLE, CBFREEZE by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cblabel.m
%   VERSION: 2.0 (Jun 08, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Aug 21, 2008)
%   2.0      Minor changes. Added CBHANDLE dependency. (Jun 08, 2009)

%   DISCLAIMER:
%   cblabel.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2008,2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Parameters:
cbappname = 'Frozen';         % Colorbar application data with fields:
                              % 'Location' from colorbar
                              % 'Position' from peer axes befor colorbar
                              % 'pax'      handle from peer axes.

% Sets defaults:
H     = get(get(0,'CurrentFigure'),'CurrentAxes');
LABEL = '';
TOPT  = {};
CBLH  = [];

% Number of inputs:
if nargin<1
 error('CVARGAS:cblabel:incorrectNumberOfInputs',...
        'At least one input is required.')
end

% Looks for H:
if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
 H = varargin{1};
 varargin(1) = [];
end

% Looks for CBH:
CBH = cbhandle(H);
if isempty(CBH), if ~nargout, clear CBLH, end, return, end

% Looks for LABEL:
if ~isempty(varargin) && (ischar(varargin{1}) || iscellstr(varargin{1}))  
 LABEL = varargin{1};
 varargin(1) = [];
end

% Forces cell of strings:
if ischar(LABEL)
 % Same label to all the color bars:
 LABEL = repmat({LABEL},length(CBH),1);
elseif iscellstr(LABEL) && (length(LABEL)==length(CBH))
  % Continue...
else
 error('CVARGAS:cblabel:incorrectInputLabel',...
        ['LABEL must be a string or cell of strings of equal size as ' ...
         'the color bar handles: ' int2str(length(CBH)) '.'])
end

% OPTIONAL arguments:
if ~isempty(varargin)
 TOPT = varargin;
end
if length(TOPT)==1
 TOPT = repmat({TOPT},size(CBH));
end

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------
% NOTE: Only CBH, LABEL and TOPT are needed.

% Applies to each colorbar:
CBLH = repmat(NaN,size(CBH));
for icb = 1:length(CBH)
 
 % Searches for label location:
 try 
  % Normal colorbar:
  location = get(CBH(icb),'Location');
 catch
  % Frozen colorbar:
  location = getappdata(CBH(icb),cbappname);
  location = location.Location;
 end
 switch location(1)
  case 'E', as  = 'Y';
  case 'W', as  = 'Y';
  case 'N', as  = 'X';
  case 'S', as  = 'X';
 end
 % Gets label handle:
 CBLH(icb) = get(CBH(icb),[as 'Label']);
 % Updates label:
 set(CBLH(icb),'String',LABEL{icb},TOPT{:});
 
end

% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

% Sets output:
if ~nargout
 clear CBLH
end
end
function CBH = cbunits(varargin)
%CBUNITS   Adds units to the colorbar ticklabels.
%
%   SYNTAX:
%           cbunits(UNITS)
%           cbunits(UNITS,SPACE)
%           cbunits -clear
%           cbunits(H,...)
%     CBH = cbunits(...);
%
%   INPUT:
%     UNITS - String (or cell of strings) with the colorbar(s) units or
%             '-clear' to eliminate any unit. 
%     SPACE - Logical indicating whether an space should be put between
%             quantity and units. Useful when using '3?C', for example.
%             DEFAULT: true (use an space)
%     H     - Colorbar, or peer axes (see COLORBAR) or figure handle(s) to
%             search for color bars. 
%             DEFAULT: gca (current axes color bar)
%
%   OUTPUT (all optional):
%     CBH   - Returns the colorbar handle(s).
%             DEFAULT: Not returned if not required.
%           - Ticklabels modified on the colorbar of the current axes or
%             the one(s) specified by CBH.
%
%   DESCRIPTION:
%     This function adds units to the current colorbar, by writting them
%     after the biggest ticklabel.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * Scientific notation is included in the units (if any).
%     * When more than one colorbar handle is given or founded and a single
%       UNITS string is given, it is applied to all of them.
%     * Use a cell of strings for UNITS when more than one colorbar handles
%       are given in order to give to each one their proper units. This
%       also works when the handlesare founded but the units order is
%       confusing and not recommended.
%     * Once applied, CAXIS shouldn't be used.
%     * To undo sets the ticklabelmode to 'auto'.
%
%   EXAMPLE:
%     % Easy to use:
%       figure, caxis([1e2 1e8]), colorbar, cbunits('?F',false)
%     % Vectorized:
%       figure
%       subplot(211), h1 = colorbar;
%       subplot(212), h2 = colorbar;
%       cbunits([h1;h2],{'?C','dollars'},[false true])
%     % Handle input:
%       figure
%       subplot(211), colorbar;
%       subplot(212), colorbar('Location','North');
%       caxis([1e2 1e8])
%       cbunits(gcf,'m/s')
%
%   SEE ALSO: 
%     COLORBAR
%     and
%     CBLABEL, CBHANDLE, CBFREEZE by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbunits.m
%   VERSION: 3.0 (Sep 30, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Aug 21, 2008)
%   2.0      Minor changes. Added 'clear' option and CBHANDLE dependency.
%            (Jun 08, 2009)
%   3.0      Fixed bug when inserting units on lower tick and ticklabel
%            justification. Added SPACE option. (Sep 30, 2009)

%   DISCLAIMER:
%   cbunits.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2008,2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Sets defaults:
H     = get(get(0,'CurrentFigure'),'CurrentAxes');
UNITS = '';
SPACE = true;

% Checks inputs/outputs number:
if     nargin<1
 error('CVARGAS:cbunits:notEnoughInputs',...
  'At least 1 input is required.')
elseif nargin>3
 error('CVARGAS:cbunits:tooManyInputs',...
  'At most 3 inputs are allowed.')
elseif nargout>1
 error('CVARGAS:cbunits:tooManyOutputs',...
  'At most 1 output is allowed.')
end

% Looks for H:
if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
 H = varargin{1};
 varargin(1) = [];
end

% Looks for CBH:
CBH = cbhandle(H);
if isempty(CBH), if ~nargout, clear CBH, end, return, end

% Looks for UNITS:
if ~isempty(varargin) && ~isempty(varargin{1}) && ...
  (ischar(varargin{1}) || iscellstr(varargin{1}))  
 UNITS = varargin{1};
 varargin(1) = [];
end
if isempty(UNITS), if ~nargout, clear CBH, end, return, end

% Forces cell of strings:
if ischar(UNITS)
 if numel(UNITS)~=size(UNITS,2)
  error('CVARGAS:cbunits:IncorrectUnitsString',...
        'UNITS string must be a row vector.')
 end
 % Same units to all the color bars:
 UNITS = repmat({UNITS},length(CBH),1);
elseif iscellstr(UNITS) && (length(UNITS)==length(CBH))
  % Continue...
else
 error('CVARGAS:cbunits:IncorrectInputUnits',...
        ['UNITS must be a string or cell of strings of equal size as ' ...
         'the color bar handles: ' int2str(length(CBH)) '.'])
end

% Looks for SPACE:
Nunits = length(UNITS);
if ~isempty(varargin) && ~isempty(varargin{1}) && ...
  ((length(varargin{1})==1) || (length(varargin{1})==Nunits))  
 SPACE = varargin{1};
end
SPACE = logical(SPACE);

% Forces equal size of SPACE and UNITS.
if (length(SPACE)==1) && (Nunits~=1)
 SPACE = repmat(SPACE,Nunits,1);
end


% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------
% Note: Only CBH and UNITS are required.

% Applies to each colorbar:
for icb = 1:length(CBH)
 
 units  = UNITS{icb};
 space  = SPACE(icb);
 cbh    = CBH(icb);
 append = [];
 
 % Gets tick labels:
 as  = 'Y';
 at  = get(cbh,[as 'Tick']);
 if isempty(at)
  as = 'X';
  at = get(cbh,[as 'Tick']);
 end
 
 % Checks for elimitation:
 if strcmpi(units,'-clear')
  set(cbh,[as 'TickLabelMode'],'auto')
  continue
 end

             set(cbh,[as 'TickLabelMode'],'manual');
 old_ticks = get(cbh,[as 'TickLabel']);

 % Adds scientific notation:
 if strcmp(get(cbh,[as 'Scale']),'linear')
  ind = 1;
  if at(ind)==0
   ind = 2;
  end
  o  = log10(abs(at(ind)/str2double(old_ticks(ind,:))));
  sg = '';
  if at(ind)<0, sg = '-'; end
  if o>0
   append = [' e' sg int2str(o) ''];
  end
 end
 
 % Updates ticklabels:
 Nu = length(units);
 Na = length(append);
 Nt = size(old_ticks,1);
 loc = Nt; % Fixed bug, Sep 2009
 if (strcmp(as,'Y') && ((abs(at(1))>abs(at(Nt))) && ...
    (length(fliplr(deblank(fliplr(old_ticks( 1,:))))) > ...
     length(fliplr(deblank(fliplr(old_ticks(Nt,:)))))))) || ...
     (strcmp(as,'X') && strcmp(get(cbh,[as 'Dir']),'reverse'))
  loc = 1; 
 end
 new_ticks  = [old_ticks repmat(' ',Nt,Nu+(Na-(Na>0))+space)];
 new_ticks(loc,end-Nu-Na-space+1:end) = [append repmat(' ',1,space) units];
 if strcmp(as,'Y') % Fixed bug, Sep 2009
  if strcmp(get(cbh,[as 'AxisLocation']),'right')
   new_ticks = strjust(new_ticks,'left');
  else
   new_ticks = strjust(new_ticks,'right');
  end
 else
  new_ticks = strjust(new_ticks,'center');
 end
 set(cbh,[as 'TickLabel'],new_ticks)
 
end % MAIN LOOP


% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

% Sets output:
if ~nargout
 clear CBH
end
end
function RGB = cmapping(varargin)
%CMAPPING   Colormap linear mapping/interpolation.
%
%   SYNTAX:
%           cmapping
%           cmapping(U)
%           cmapping(U,CMAP)
%           cmapping(U,CMAP,...,CNAN)
%           cmapping(U,CMAP,...,TYPE)
%           cmapping(U,CMAP,...,MODE)
%           cmapping(U,CMAP,...,MAPS)
%           cmapping(U,CMAP,...,CLIM)
%           cmapping(AX,...)
%     RGB = cmapping(...);
%
%   INPUT:
%     U     - May be one of the following options:
%              a) An scalar specifying the output M number of colors.
%              b) A vector of length M specifying the values at which
%                 the function CMAP(IMAP) will be mapped.
%              c) A matrix of size M-by-N specifying intensities to be
%                 mapped to an RGB (3-dim) image. May have NaNs elements. 
%             DEFAULT: Current colormap length.
%     CMAP  - A COLORMAP defined by its name or handle-function or RGB
%             matrix (with 3 columns) or by a combination of colors chars
%             specifiers ('kbcw', for example) to be mapped. See NOTE below
%             for more options.
%             DEFAULT: Current colormap
%     CNAN  - Color for NaNs values on U, specified by a 1-by-3 RGB color
%             or a char specifier.
%             DEFAULT: Current axes background (white color: [1 1 1])
%     TYPE  - String specifying the result type. One of:
%               'colormap'  Forces a RGB colormap matrix result (3 columns)
%               'image'     Forces a RGB image result (3 dimensions)
%             DEFAULT: 'image' if U is a matrix, otherwise is 'colormap'
%     MODE  - Defines the mapping way. One of:
%               'discrete'     For discrete colors
%               'continuous'   For continuous color (interpolates)
%             DEFAULT: 'continuous' (interpolates between colors)
%     MAPS  - Specifies the mapping type. One of (see NOTES below):
%               'scaled'   Scales mapping, also by using CLIM (as IMAGESC).
%               'direct'   Do not scales the mapping (as IMAGE).
%             DEFAULT: 'scaled' (uses CLIM)
%     CLIM  - Two element vector that, if given, scales the mapping within
%             this color limits. Ignored if 'direct' is specified.
%             DEFAULT: [0 size(CMAP,1)] or [0 1].
%     AX    - Uses specified axes or figure handle to set/get the colormap.
%             If used, must be the first input.
%             DEFAULT: gca
%
%   OUTPUT (all optional):
%     RGB - If U is not a matrix, this is an M-by-3 colormap matrix with
%           RGB colors in its rows, otherwise is an RGB image: M-by-N-by-3,
%           with the color red intensities defined by RGB(:,:,1), the green
%           ones by RGB(:,:,2) and the blue ones by RGB(:,:,3).
%
%   DESCRIPTION:
%     This functions has various functionalities like: colormap generator,
%     colormap expansion/contraction, color mapping/interpolation, matrix
%     intensities convertion to RGB image, etc.
%
%     The basic idea is a linear mapping between the CMAP columns
%     [red green blue] and the U data, ignoring its NaNs.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * If a single value of U is required for interpolation, use [U U].
%     * If the char '-' is used before the CMAP name, the colors will be
%       flipped. The same occurs if U is a negative integer.
%
%   EXAMPLE:
%     % Colormaps:
%       figure, cmapping( 256,'krgby')            , colorbar
%       figure, cmapping(-256,'krgby' ,'discrete'), colorbar
%       figure, cmapping(log(1:100),[],'discrete'), colorbar
%     % Images:
%       u = random('chi2',2,20,30); u(15:16,7:9) = NaN;
%       u = peaks(30);  u(15:16,7:9) = NaN;
%       v = cmapping(u,jet(64),'discrete','k');
%       w = cmapping(u,cmapping(log(0:63),'jet','discrete'),'discrete');
%       figure, imagesc(u), cmapping(64,'jet'), colorbar
%        title('u')
%       figure, imagesc(v), cmapping(64,'jet'), colorbar
%        title('u transformed to RGB (look the colored NaNs)')
%       figure, imagesc(w) ,cmapping(64,'jet'), colorbar
%        title('u mapped with log(colormap)')
%       figure, imagesc(u), cmapping(log(0:63),'jet','discrete'), colorbar
%        title('u with log(colormap)')
%    
%   SEE ALSO:
%     COLORMAP, IND2RGB
%     and
%     CMJOIN by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cmapping.m
%   VERSION: 1.1 (Sep 02, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)
%   1.0.1    Fixed little bug with 'm' magenta color. (Jun 30, 2009)
%   1.1      Fixed BUG with empty CMAP, thanks to Andrea Rumazza. (Sep 02,
%            2009) 

%   DISCLAIMER:
%   cmapping.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Sets defaults:
AX     = {};                     % Calculated inside.
U      = [];                     % Calculated inside.
CMAP   = [];                     % Calculated inside.
TYPE   = 'colormap';             % Changes to 'image' if U is a matrix.
CLIM   = [];                     % To use in scaling
CNAN   = [1 1 1];                % White 'w'
MODE   = 'continuous';           % Scaling to CLIM
MAPS   = 'scaled';               % Scaled mapping
method = 'linear';               % Interpolation method
mflip  = false;                  % Flip the colormap

% Gets figure handle and axes handle (just in case the default colormap or
% background color axes will be used.
HF     = get(0,'CurrentFigure');
HA     = [];
if ~isempty(HF)
 HA    = get(HF,'CurrentAxes');
 if ~isempty(HA)
  CNAN = get(HA,'Color');        % NaNs colors
 end
end

% Checks inputs:
if nargin>8
 error('CVARGAS:cmapping:tooManyInputs', ...
  'At most 8 inputs are allowed.')
elseif nargout>1
 error('CVARGAS:cmapping:tooManyOutputs', ...
  'At most 1 output is allowed.')
end

% Checks AX:
if (~isempty(varargin)) && ~isempty(varargin{1}) && ...
  (numel(varargin{1})==1) && ishandle(varargin{1}) && ...
  strcmp(get(varargin{1},'Type'),'axes')
 % Gets AX and moves all other inputs to the left:
 AX          = varargin(1);
 HA          = AX{1};
 CNAN        = get(HA,'Color');
 varargin(1) = [];
end

% Checks U:
Nargin = length(varargin);
if ~isempty(varargin)
 U           = varargin{1};
 varargin(1) = [];
end

% Checks CMAP:
if ~isempty(varargin)
 CMAP        = varargin{1};
 varargin(1) = []; 
end

% Checks input U, if not given uses as default colormap length:
% Note: it is not converted to a vector in case CMAP is a function and IMAP
%       was not given.
if isempty(U)
 % Gets default COLORMAP length:
 if ~isempty(HA)
  U = size(colormap(HA),1);
 else
  U = size(get(0,'DefaultFigureColormap'),1);
 end
elseif ndims(U)>2
 error('CVARGAS:cmapping:incorrectXInput', ...
  'U must be an scalar, a vector or a 2-dimensional matrix.')
end

% Checks input CMAP:
if isempty(CMAP)
 % CMAP empty, then uses default:
 if ~isempty(HA)
  CMAP = colormap(HA);
  if isempty(CMAP) % Fixed BUG, Sep 2009.
   CMAP = get(0,'DefaultFigureColormap');
   if isempty(CMAP)
    CMAP = jet(64);
   end
  end
 else
  CMAP = get(0,'DefaultFigureColormap');
  if isempty(CMAP)
   CMAP = jet(64);
  end
 end
 Ncmap = size(CMAP,1);
elseif isnumeric(CMAP)
 % CMAP as an [R G B] colormap:
 Ncmap = size(CMAP,1);
 if (size(CMAP,2)~=3) || ...
  ((min(CMAP(:))<0) || (max(CMAP(:))>1)) || any(~isfinite(CMAP(:)))
  error('CVARGAS:cmapping:incorrectCmapInput', ...
        'CMAP is an incorrect 3 columns RGB colors.')
 end
elseif ischar(CMAP)
 % String CMAP
 % Checks first character:
 switch CMAP(1)
  case '-'
   mflip = ~mflip;
   CMAP(1) = [];
   if isempty(CMAP)
    error('CVARGAS:cmapping:emptyCmapInput',...
     'CMAP function is empty.')
   end
 end
 if ~((exist(CMAP,'file')==2) || (exist(CMAP,'builtin')==5))
  % CMAP as a combination of color char specifiers:
  CMAP  = lower(CMAP);
  iy    = (CMAP=='y');
  im    = (CMAP=='m');
  ic    = (CMAP=='c');
  ir    = (CMAP=='r');
  ig    = (CMAP=='g');
  ib    = (CMAP=='b');
  iw    = (CMAP=='w');
  ik    = (CMAP=='k');
  Ncmap = length(CMAP);
  if (sum([iy im ic ir ig ib iw ik])~=Ncmap)
   error('CVARGAS:cmapping:incorrectCmapStringInput', ...
   ['String CMAP must be a valid colormap name or a combination of '...
    '''ymcrgbwk''.'])
  end
  % Convertion to [R G B]:
  CMAP       = zeros(Ncmap,3);
  CMAP(iy,:) = repmat([1 1 0],sum(iy),1);
  CMAP(im,:) = repmat([1 0 1],sum(im),1); % BUG fixed Jun 2009
  CMAP(ic,:) = repmat([0 1 1],sum(ic),1);
  CMAP(ir,:) = repmat([1 0 0],sum(ir),1);
  CMAP(ig,:) = repmat([0 1 0],sum(ig),1);
  CMAP(ib,:) = repmat([0 0 1],sum(ib),1);
  CMAP(iw,:) = repmat([1 1 1],sum(iw),1);
  CMAP(ik,:) = repmat([0 0 0],sum(ik),1);
 else
  % CMAP as a function name
  % Changes function name to handle:
  CMAP = str2func(CMAP);
  Ncmap = []; % This indicates a CMAP function input
 end
elseif isa(CMAP,'function_handle')
 Ncmap = []; % This indicates a CMAP function input
else
 % CMAP input unrecognized:
 error('CVARGAS:cmapping:incorrectCmapInput', ...
  'Not recognized CMAP input.') 
end

% Checks CMAP function handle:
if isempty(Ncmap)
 % Generates the COLORMAP from function:
 try
  temp = CMAP(2);
  if ~all(size(temp)==[2 3]) || any(~isfinite(temp(:))), error(''), end
  clear temp
 catch
  error('CVARGAS:cmapping:incorrectCmapFunction', ...
   ['CMAP function ''' func2str(CMAP) ''' must result in RGB colors.'])
 end
end

% Checks varargin:
while ~isempty(varargin)
 if     isempty(varargin{1})
  % continue
 elseif ischar(varargin{1})
  % string input
  switch lower(varargin{1})
   % CNAN:
   case 'y'         , CNAN = [1 1 0];
   case 'm'         , CNAN = [1 0 0];
   case 'c'         , CNAN = [0 1 1];
   case 'r'         , CNAN = [1 0 0];
   case 'g'         , CNAN = [0 1 0];
   case 'b'         , CNAN = [0 0 1];
   case 'w'         , CNAN = [1 1 1];
   case 'k'         , CNAN = [0 0 0];
   % MODE:
   case 'discrete'  , MODE = 'discrete';
   case 'continuous', MODE = 'continuous';
   % TYPE:
   case 'colormap'  , TYPE = 'colormap';
   case 'image'     , TYPE = 'image';
   % MAPS:
   case 'direct'    , MAPS = 'direct';
   case 'scaled'    , MAPS = 'scaled';
   % Incorrect input:
   otherwise
    error('CVARGAS:cmapping:incorrectStringInput',...
     ['Not recognized optional string input: ''' varargin{1} '''.'])
  end
 elseif isnumeric(varargin{1}) && all(isfinite(varargin{1}(:)))
  % numeric input
  nv = numel(varargin{1});
  if (nv==3) && (size(varargin{1},1)==1)
   % CNAN:
   CNAN = varargin{1}(:)';
   if (max(CNAN)>1) || (min(CNAN)<0)
    error('CVARGAS:cmapping:incorrectCnanInput',...
     'CNAN elements must be between 0 and 1.')
   end
  elseif (nv==2) && (size(varargin{1},1)==1)
   % CLIM:
   CLIM = sort(varargin{1},'ascend');
   if (diff(CLIM)==0)
    error('CVARGAS:cmapping:incorrectClimValues',...
     'CLIM must have 2 distint elements.')
   end
  else
   error('CVARGAS:cmapping:incorrectNumericInput',...
   'Not recognized numeric input.')
  end
 else
  error('CVARGAS:cmapping:incorrectInput',...
   'Not recognized input.')
 end
 % Clears current optional input:
 varargin(1) = [];
end % while


% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% U size:
[m,n] = size(U);
mn    = m*n;

% Checks TYPE:
if ~any([m n]==1)
 % Forces image TYPE if U is a matrix:
 TYPE = 'image';
elseif strcmp(TYPE,'colormap') && ~nargout && isempty(AX)
 % Changes the colormap on the specified or current axes if no output
 % argument:
 AX = {gca};
end

% Forces positive integer if U is an scalar, and flips CMAP if is negative:
if (mn==1)
 U = round(U);
 if (U==0)
  if ~nargout && strcmp(TYPE,'colormap')
   warning('CVARGAS:cmapping:incorrectUInput',...
    'U was zero and produces no colormap')
  else
   RGB = [];
  end
  return
 elseif (U<0)
  mflip = ~mflip;
  U     = abs(U);
 end
end

% Gets CMAP from function handle:
if isempty(Ncmap)
 if (mn==1)
  % From U:
  Ncmap = U(1);
 else
  % From default colormap:
  if ~isempty(HA)
   Ncmap = size(colormap(HA),1);
  else
   Ncmap = size(get(0,'DefaultFigureColormap'),1);
  end
 end
 CMAP = CMAP(Ncmap);
end

% Flips the colormap
if mflip
 CMAP = flipud(CMAP);
end

% Check CMAP when U is an scalar::
if (mn==1) && (U==Ncmap)
 % Finishes:
 if ~nargout && strcmp(TYPE,'colormap')
  if Nargin==0
   RGB = colormap(AX{:},CMAP);
  else
   colormap(AX{:},CMAP)
  end
 else
  RGB = CMAP;
  if strcmp(TYPE,'image')
   RGB = reshape(RGB,Ncmap,1,3);
  end
 end
 return
end

% Sets scales:
if strcmp(MAPS,'scaled')
 % Scaled mapping:
 if ~isempty(CLIM)
  if (mn==1)
   mn = U;
   U = linspace(CLIM(1),CLIM(2),mn)';
  else
   % Continue  
  end
 else
  CLIM = [0 1];
  if (mn==1)
   mn = U;
   U = linspace(CLIM(1),CLIM(2),mn)';
  else
   % Scales U to [0 1]:
   U = U-min(U(isfinite(U(:))));
   U = U/max(U(isfinite(U(:))));
   % Scales U to CLIM:
   U = U*diff(CLIM)+CLIM(1);
  end
 end
else
 % Direct mapping:
 CLIM = [1 Ncmap];
end

% Do not extrapolates:
U(U<CLIM(1)) = CLIM(1);
U(U>CLIM(2)) = CLIM(2);

% Sets CMAP argument:
umap = linspace(CLIM(1),CLIM(2),Ncmap)';

% Sets U:
if (mn==2) && (U(1)==U(2))
 % U = [Uo Uo] implicates U = Uo:
 U(2) = [];
 mn   = 1;
 m    = 1;
 n    = 1;
end

% Sets discretization:
if strcmp(MODE,'discrete')
 umap2 = linspace(umap(1),umap(end),Ncmap+1)';
 for k = 1:Ncmap
  U((U>umap2(k)) & (U<=umap2(k+1))) = umap(k);
 end
 clear umap2
end

% Forces column vector:
U = U(:);

% Gets finite data:
inan = ~isfinite(U);

% Initializes:
RGB  = repmat(reshape(CNAN,[1 1 3]),[mn 1 1]);

% Interpolates:
if (Ncmap>1) && (sum(~inan)>1)
 [Utemp,a,b]    = unique(U(~inan));
 RGBtemp = [...
  interp1(umap,CMAP(:,1),Utemp,method) ...
  interp1(umap,CMAP(:,2),Utemp,method) ...
  interp1(umap,CMAP(:,3),Utemp,method) ...
  ];
 RGB(~inan,:) = RGBtemp(b,:);
else
 % single color:
 RGB(~inan,1,:) = repmat(reshape(CMAP,[1 1 3]),[sum(~inan) 1 1]);
end

% Just in case
RGB(RGB>1) = 1; 
RGB(RGB<0) = 0;

% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

% Output type:
if strcmp(TYPE,'colormap')
 RGB = reshape(RGB,mn,3);
 if ~isempty(AX)
  colormap(AX{:},RGB)
  if ~nargout 
   clear RGB
  end
 end
else
 RGB = reshape(RGB,[m n 3]);
end
end
function [CMAP,CLIM,WIDTH,REF,LEVELS] = ...
                                 cmfit(CMAP,CLIM,WIDTH,REF,CENTER,varargin) 
%CMFIT   Sets the COLORMAP and CAXIS to specific color bands. 
%
%   SYNTAX:
%                                      cmfit
%                                      cmfit(CMAP)
%                                      cmfit(CMAP,CLIM)
%                                      cmfit(CMAP,CLIM,WIDTH or LEVELS)
%                                      cmfit(CMAP,CLIM,WIDTH,REF)
%                                      cmfit(CMAP,CLIM,WIDTH,REF,CENTER)
%                                      cmfit(AX,...)
%     [CMAPF,CLIMF,WIDTHF,REFF,LEVF] = cmfit(...);
%
%   INPUT:
%     CMAP   - Fits the specified colormap function or RGB colors. 
%              DEFAULT: (current figure colormap)
%     CLIM   - 2 element vector spacifying the limits of CMAP. 
%              DEFAULT: (limits of a COLORBAR)
%     WIDTH  - Color band width (limits are computed with CAXIS) for each
%     or       band or a row vector specifying the LEVELS on each band (see
%     LEVELS   NOTE below).
%              DEFAULT: (fills the ticks of a COLORBAR)
%     REF    - Reference level to start any of the color bands.
%              DEFAULT: (generally the middle of CLIM)
%     CENTER - Logical specifying weather the colormap should be center in
%              the REF value or not.
%              DEFAULT: false (do not centers)
%     AX     - Uses the specified figure or axes handle.
%
%   OUTPUT (all optional):
%     CMAPF  - RGB fitted color map (with 3 columns).
%     CLIMF  - Limits of CMAPF.
%     WIDTHF - Width of fitted colorbands.
%     REFF   - Reference of fitted colorbands.
%     LEVF   - Levels for the color bands.
%
%   DESCRIPTION:
%     This program sets the current figure colormap with specified
%     band-widths of colors taking the CAXIS limits as reference. When the 
%     optional input argument CENTER is true, the colormap is moved and
%     expanded so its middle color will be right at REF. This will help for
%     distinguish between positive and negative values (REF=0).
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * When one of the first two inputs is missing, they are automatically
%       calculated by using a COLORBAR (created temporarly if necesary). In
%       this case CBHANDLE is necesary.
%     * When CMAP is used as output, the current figure colormap won't be
%       modificated. Use 
%         >> colormap(CMAP)
%       after this function, if necesary.
%     * When LEVELS are used instead of band WINDTH, it shoud be
%       monotonically increasing free of NaNs and of length equal to the
%       number of colors minus one, on the output colormap.
% 
%   SEE ALSO:
%     COLORMAP
%     and 
%     CMAPPING, CBFIT by Caros Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cmfit.m
%   VERSION: 1.0 (Jun 08, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)

%   DISCLAIMER:
%   cmfit.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2008,2009 Carlos Adrian Vargas Aguilera


% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Sets defaults: 
AX  = {};    % Axes input
tol = 1;     % Adds this tolerance to the decimal precision
hfig = {get(0,'CurrentFigure')};
if ~isempty(hfig)
 hax = {get(hfig{1},'CurrentAxes')};
 if isempty(hax{1}), hax = {}; end
else
 hfig = {};
 hax  = {};
end

% Checks inputs:
if nargin>6
 error('CVARGAS:cmfit:tooManyInputs', ...
  'At most 6 inputs are allowed.')
end
if nargin>5
 error('CVARGAS:cmfit:tooManyOutputs', ...
  'At most 5 outputs are allowed.')
end

% Saves number of arguments:
Nargin = nargin;

% Checks AX input:
if (Nargin>0) && ~isempty(CMAP) && (numel(CMAP)==1) && ...
  ishandle(CMAP)
 % Gets AX and moves all other inputs to the left:
 AX = {CMAP};
 switch get(AX{1},'Type')
  case 'axes'
   hax  = AX;
   hfig = {get(hax{1},'Parent')};
  case {'figure','uipanel'}
   hfig = {AX{1}};
   hax  = {get(hfig{1},'CurrentAxes')};
   if isempty(hax{1}), hax = {}; end
  otherwise
   error('CVARGAS:cmfit:incorrectAxHandle',...
    'AX must be a valid axes or figure handle.')
 end
 if (Nargin>1)
  CMAP = CLIM;
  if (Nargin>2)
   CLIM = WIDTH;
   if (Nargin>3)
    WIDTH = REF;
    if (Nargin>4)
     REF = CENTER;
     if (Nargin>5)
      CENTER = varargin{1};
     end
    end
   end
  end
 end
 Nargin = Nargin-1;
end

% Checks CMAP input:
if Nargin<1 || isempty(CMAP)
 if ~isempty(hax)
  CMAP = colormap(hax{1});
 else
  CMAP = get(0,'DefaultFigureColormap');
 end
end

% Checks CLIM input:
if Nargin<2
 CLIM = [];
end

% Checks WIDTH input:
if Nargin<3
 WIDTH = [];
end

% Checks REf input:
if Nargin<4
 REF = [];
end

% Checks CENTER input:
if Nargin<5 || isempty(CENTER)
 CENTER = false;
end

% Look for WIDTH and REF from a (temporarly) colorbar:
if isempty(WIDTH) || (length(WIDTH)==1 && (isempty(REF) || ...
  (isempty(CLIM) && (isempty(hax) || ...
  ~strcmp(get(hax{1},'CLimMode'),'manual')))))
 if ~isempty(CLIM)
  caxis(hax{:},CLIM)
 end
 if ~isempty(AX) && ~isempty(cbhandle(AX{1}))
  h = cbhandle(AX{1}); doclear = false; h = h(1);
 elseif ~isempty(hax) && ~isempty(cbhandle(hax{1}))
  h = cbhandle(hax{1}); doclear = false; h = h(1);
 elseif ~isempty(hfig) && ~isempty(cbhandle(hfig{1}))
  h = cbhandle(hfig{1}); doclear = false; h = h(1);
 else
  h = colorbar; doclear = true;
 end
 ticks = get(h,'XTick');
 lim   = get(h,'XLim');
 if isempty(ticks)
  ticks = get(h,'YTick');
  lim   = get(h,'YLim');
 end
 if isempty(WIDTH)
  WIDTH = diff(ticks(1:2));
 end
 if isempty(CLIM)
  CLIM = lim;
 end
 if isempty(REF) && ~CENTER
  REF = ticks(1);
 end
 if doclear
  delete(h)
 end
end

% Centers at the middle:
if CENTER && isempty(REF)
 REF = 0;
end 

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------


% Gets minimum width from specified levels:
NL = length(WIDTH); 
if (NL>1)
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % NONLINEAR CASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 LEVELS = sort(WIDTH);
 
 % Gets LEVELS width:
 wLEVELS = diff(LEVELS);
 
 % Scales to CLIM:
 if ~isempty(CLIM)
  % Scales to [0 1]
  LEVELS = LEVELS-LEVELS(1);
  LEVELS = LEVELS/LEVELS(end);
  % Scales to CLIM:
  LEVELS = LEVELS*diff(CLIM)+CLIM(1);
 else
  CLIM  = [LEVELS(1) LEVELS(end)]; 
 end
 
 % Gets precision:
 if isinteger(wLEVELS) % Allows integer input: uint8, etc. 
  wLEVELS = double(wLEVELS);
 end
 temp = warning('off','MATLAB:log:logOfZero');
 precision = floor(log10(abs(wLEVELS))); % wLEVELS = Str.XXX x 10^precision.
 precision(wLEVELS==0) = 0; % M=0 if x=0.
 warning(temp.state,'MATLAB:log:logOfZero')
 precision = min(precision)-tol;
 
 % Sets levels up to precision:
 wLEVELS = round(wLEVELS*10^(-precision));
 
 % Gets COLORMAP for each LEVEL:
 if CENTER
  % Centers the colormap:
  ind = (REF==LEVELS);
  if ~any(ind)
   error('CVARGAS:cmfit:uncorrectRefLevel',...
    'When CENTER, REF level must be on of the specifyied LEVELS.')
  end
  Nl     = sum(~ind(1:find(ind)));
  [Nl,l] = max([Nl (NL-1-Nl)]);
  wCMAP  = cmapping(2*Nl,CMAP);
  if l==1
   wCMAP = wCMAP(1:NL-1,:);
  else
   wCMAP = wCMAP(end-NL+2:end,:);
  end
 else
  wCMAP  = cmapping(NL-1,CMAP);
 end
 
 % Gets minimum band width:
 WIDTH = wLEVELS(1);
 for k = 1:NL-1
  wlev    = wLEVELS;
  wlev(k) = [];
  WIDTH   = min(min(gcd(wLEVELS(k),wlev)),WIDTH);
 end
 
 % Gets number of bands:
 wLEVELS = wLEVELS/WIDTH;
 
 % Gets new CMAP:
 N = sum(wLEVELS);
 try
  CMAP = repmat(wCMAP(1,:),N,1);
 catch
  error('CVARGAS:cmfit:memoryError',...
   ['The number of colors (N=' int2str(N) ') for the new colormap ' ...
    'is extremely large. Try other LEVELS.'])
 end
 ko = wLEVELS(1);
 for k = 2:NL-1;
  CMAP(ko+(1:wLEVELS(k)),:) = repmat(wCMAP(k,:),wLEVELS(k),1);
  ko = ko+wLEVELS(k);
 end
 
else
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % LINEAR CASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 % Gets CLIM:
 if isempty(CLIM)
  CLIM = caxis(hax{:});
 end

 % Sets color limits to be a multipler of WIDTH passing through REF:
 N1   = ceil((+REF-CLIM(1))/WIDTH);
 N2   = ceil((-REF+CLIM(2))/WIDTH);
 CLIM = REF + [-N1 N2]*WIDTH;

 % Sets colormap with NC bands:
 Nc = round(diff(CLIM)/WIDTH);
 if CENTER
  % Necesary colorbands number to be centered:
  Nmin        = [N1 N2];
  [Nmax,imax] = max(Nmin);
  Nmin(imax)  = [];
  Nc2         = Nc + Nmax - Nmin;
  % Generate a colormap with this size:
  CMAP = cmapping(Nc2,CMAP);
  if imax==1
   CMAP = CMAP(1:Nc,:);
  else
   CMAP = flipud(CMAP);
   CMAP = CMAP(1:Nc,:);
   CMAP = flipud(CMAP);
  end
 else
  CMAP = cmapping(Nc,CMAP);
 end
 
 % Sets levels:
 LEVELS = linspace(CLIM(1),CLIM(2),size(CMAP,1))';
end

% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------
if ~isempty(AX)
 colormap(AX{:},CMAP)
 caxis(AX{:},CLIM)
end
if ~nargout
 if isempty(AX)
  colormap(CMAP)
  caxis(CLIM)
 end
 clear CMAP
end
end
function [CMAP,LEV,WID,CLIM] = cmjoin(varargin)
%CMJOIN   Joins colormaps at certain levels.
%
%   SYNTAX:
%                           cmjoin(CMAPS)
%                           cmjoin(CMAPS,LEV)
%                           cmjoin(CMAPS,LEV,WID)
%                           cmjoin(CMAPS,LEV,WID,CLIM)
%                           cmjoin(AX,...)
%     [CMAP,LEV,WID,CLIM] = cmjoin(...);
%
%   INPUT:
%     CMAPS - Cell with the N colormaps handles, names or RGB colors to be
%             joined. See NOTE below.
%     LEV   - One of:
%               a) N-1 scalars specifying the color levels where the
%                  colormaps will be joined (uses CAXIS). See NOTE below.
%               b) N integers specifying the number of colors for each
%                  colormap.
%               c) N+1 scalars specifying the color limits for each
%                  colormap (sets CAXIS). See NOTE below.
%             DEFAULT: Tries to generate a CMAP with default length.
%     WID   - May be one (or N) positive scalar specifying the width for
%             every (or each) color band. See NOTE below.
%             DEFAULT: uses CAXIS and LEV to estimate it.  
%     CLIM  - 2 elements row vector specifying the color limits values. May
%             be changed at the end, because of the discretization of the
%             colormaps.
%             DEFAULT: uses CAXIS or [0 1] if there are no axes.
%     AX    - Uses the specified axes handle to get/set the CMAPS. If used,
%             must be the first input.
%             DEFAULT: gca
%
%   OUTPUT (all optional):
%     CMAP - RGB colormap output matrix, M-by-3.
%     LEV  - Final levels used.
%     WID  - Final widths used.
%     CLIM - Final color limits used.
%
%   DESCRIPTION:
%     This function join two colormaps at specific level. Useful for
%     joining colormaps at zero (for example) and distinguish from positive
%     and negative values.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * If no output is required or an axes handle were given, the current
%       COLORMAP and CAXIS are changed.
%     * If any of the inputs on CMAPS is a function name, 'jet', for
%       example, it can be used backwards (because CMAPPING is used) if
%       added a '-' at the beggining of its name: '-jet'.
%     * When LEV is type b) and WID is specifyed, the latter is taken as
%       relative colorbans widths between colormaps.
%
%   EXAMPLE:
%     figure(1), clf, surf(peaks)
%     cmjoin({'copper','-summer'},2.5)
%      shading interp, colorbar, axis tight, zlabel('Meters')
%      title('Union at 2.5 m')
%     %
%     figure(2), clf, surf(peaks) 
%     cmjoin({'copper','-summer'},2.5,0.5)
%      shading interp, colorbar, axis tight, zlabel('Meters')
%      title('Union at 2.5 m and different color for each 0.5 m band')
%     %
%     figure(3), clf, surf(peaks)
%     cmjoin({'copper','summer'},2.5,[2 0.5])
%      shading interp, colorbar, axis tight, zlabel('Metros')
%      title('Union at 2.5 m with lengths 2 and 0.5')
%     %
%     figure(4), clf, surf(peaks)
%     cmjoin({'copper','summer'},[-10 2.5 10],[2 0.5])
%      shading interp, colorbar, axis tight, zlabel('Metros')
%      title('Union at 2.5 m with lengths 2 and 0.5 and specified levels')
%     %
%     figure(5), clf, surf(peaks)
%     cmjoin({'copper','summer'},[10 8],[4 1])
%      shading interp, colorbar, axis tight, zlabel('Metros')
%      title('Union at 2.5 m with specified levels number of colors and widths 4:1')
%    
%   SEE ALSO:
%     COLORMAP, COLORMAPEDITOR
%     and
%     CMAPPING by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cmjoin.m
%   VERSION: 2.0 (Jun 08, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0       Released as SETCOLORMAP. (Nov 07, 2006)
%   1.1       English translation. (Nov 11, 2006)
%   2.0       Rewritten and renamed code (from SETCOLORMAPS to CMJOIN. Now
%             joins multiple colormaps. Inputs changed. (Jun 08, 2009)

%   DISCLAIMER:
%   cmjoin.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2006,2009 Carlos Adrian Vargas Aguilera

% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Parameters:
tol  = 1;            % When rounding the levels.

% Checks inputs and outputs number:
if nargin<1
 error('CVARGAS:cmjoin:notEnoughInputs',...
  'At least 1 input is required.')
end
if nargin>5
 error('CVARGAS:cmjoin:tooManyInputs',...
  'At most 5 inputs are allowed.')
end
if nargout>4
 error('CVARGAS:cmjoin:tooManyOutputs',...
  'At most 4 outputs are allowed.')
end

% Checks AX:
AX = {get(get(0,'CurrentFigure'),'CurrentAxes')};
if isempty(AX{1})
 AX = {};
end
if (length(varargin{1})==1) && ishandle(varargin{1}) && ...
  strcmp(get(varargin{1},'Type'),'axes')
 AX = varargin(1);
 varargin(1) = [];
 if isempty(varargin)
  error('CVARGAS:cmjoin:notEnoughInputs',...
   'CMAPS input must be given.')
 end
end

% Checks CMAPS:
CMAPS  = varargin{1};
Ncmaps = length(CMAPS);
if ~iscell(CMAPS) || (Ncmaps<2)
 error('CVARGAS:cmjoin:incorrectCmapsType',...
  'CMAPS must be a cell input with at least 2 colormaps.')
end
varargin(1) = [];
Nopt        = length(varargin);

% Checks LEV and sets Ncol and Jlev:
Ncol = []; % Number of colors for each colormap.
Jlev = []; % Join levels.
LEV  = []; % Levels at which each CMAPS begins and ends.
if (Nopt<1) || isempty(varargin{1})
 % continue as empty
elseif ~all(isfinite(varargin{1}(:)))
 error('CVARGAS:cmjoin:incorrectLeVValue',...
  'LEV must be integers or scalars.')
else
 Nopt1 = length(varargin{1}(:));
 if (Nopt1==Ncmaps)
  % Specifies number of colors:
  Ncol = varargin{1}(:);
  if ~all(Ncol==round(Ncol))
   error('CVARGAS:cmjoin:incorrectLevInput',...
    'LEV must be integers when defines number of colors.')
  end
 elseif ~all(sort(varargin{1})==varargin{1})
  error('CVARGAS:cmjoin:incorrectLevInput',...
   'LEV must be monotonically increasing.')
 elseif Nopt1==(Ncmaps-1) 
  Jlev = varargin{1}(:);
 elseif Nopt1==(Ncmaps+1)
  LEV = varargin{1}(:);
 else
  error('CVARGAS:cmjoin:incorrectLevLength',...
   'LEV must have any of length(CMAPS)+[-1 0 1] elements.')
 end
end

% Checks WID:
Tcol = []; % Total number of colors for output colormap.
if (Nopt<2) || isempty(varargin{2})
 % Tries to generate a colormap with default length with every colorband
 % of the same width:
 WID = [];
 if ~isempty(AX)
  Tcol = size(colormap(AX{:}),1);
 else
  Tcol = size(get(0,'DefaultFigureColormap'),1);
 end
else
 WID = varargin{2}(:);
 WID(~isfinite(WID) | (WID<0)) = 0;
 if ~any(WID>0)
  error('CVARGAS:cmjoin:incorrectWidInput',...
   'At least one WID must be positive.')
 end
 if length(WID)==1
  WID = repmat(abs(varargin{2}),Ncmaps,1);
 elseif length(WID)~=Ncmaps
  error('CVARGAS:cmjoin:incorrectWidLength',...
   'WID must have length 1 or same as CMAPS.')
 end
end

% Checks CLIM:
if (Nopt<3) || isempty(varargin{3})
 % Sets default CLIM:
 if ~isempty(LEV)
  CLIM = [LEV(1) LEV(end)];
 elseif ~isempty(AX)
  CLIM = caxis(AX{:});
 else
  CLIM = [0 1];
 end
else
 CLIM = varargin{3}(:).';
 if (length(CLIM)==2) && (diff(CLIM)>0) && isfinite(diff(CLIM))
  % continue
 else
  error('CVARGAS:cmjoin:incorrectClimInput',...
   'CLIM must be a valid color limits. See CAXIS for details.')
 end
end


% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% Gets rounding precision:
temp = warning('off','MATLAB:log:logOfZero');
if ~isempty(WID)
 tempp               = WID;
 precision           = floor(log10(abs(tempp)));
 precision(tempp==0) = 0;
 precision           = min(precision)-tol;
 % Rounds:
 WID   = round(WID*10^(-precision))*10^precision;
 if ~isempty(LEV)
  LEV(1)        = floor(LEV(1)       *10^(-precision))*10^precision;
  LEV(2:end-1)  = round(LEV(2:end-1) *10^(-precision))*10^precision;
  LEV(end)      = ceil(LEV(end)      *10^(-precision))*10^precision;
 elseif ~isempty(Jlev)
  Jlev(1)       = floor(Jlev(1)      *10^(-precision))*10^precision;
  Jlev(2:end-1) = round(Jlev(2:end-1)*10^(-precision))*10^precision;
  Jlev(end)     = ceil(Jlev(end)     *10^(-precision))*10^precision;
 end
elseif ~isempty(LEV)
 tempp               = diff(LEV);
 precision           = floor(log10(abs(tempp)));
 precision(tempp==0) = 0;
 precision           = min(precision)-tol;
 % Rounds:
 LEV(1)       = floor(LEV(1)      *10^(-precision))*10^precision;
 LEV(2:end-1) = round(LEV(2:end-1)*10^(-precision))*10^precision;
 LEV(end)     = ceil(LEV(end)     *10^(-precision))*10^precision;
elseif ~isempty(Jlev)
 tempp               = diff(Jlev);
 if isempty(tempp)
  tempp              = Jlev;
 end
 precision           = floor(log10(abs(tempp)));
 precision(tempp==0) = 0;
 precision           = min(precision)-tol;
 % Rounds:
 if length(Jlev)==1
  Jlev          = round(Jlev*10^(-precision))*10^precision;
 else
  Jlev(1)       = floor(Jlev(1)      *10^(-precision))*10^precision;
  Jlev(2:end-1) = round(Jlev(2:end-1)*10^(-precision))*10^precision;
  Jlev(end)     = ceil(Jlev(end)     *10^(-precision))*10^precision;
 end
else
 tempp               = CLIM;
 precision           = floor(log10(abs(tempp)));
 precision(tempp==0) = 0;
 precision           = min(precision)-tol;
end
% Rounds:
CLIM(1) = floor(CLIM(1)*10^(-precision))*10^precision;
CLIM(2) =  ceil(CLIM(2)*10^(-precision))*10^precision;
warning(temp.state,'MATLAB:log:logOfZero')

% Completes levels when only join levels are specified:
if ~isempty(Jlev)
 cedge = CLIM;
 % First limit:
 if cedge(1)<=Jlev(1)
  if ~isempty(WID)
   cedge(1) = Jlev(1);
   if WID(1)~=0
    cedge(1) = cedge(1) - WID(1)*ceil((Jlev(1)-CLIM(1))/WID(1));
   end
  else
   % continue
  end
 else
  if (Ncmaps==2)
   cedge(1) = Jlev(1);
  else
   for k = 2:length(Jlev)
    if cedge(1)<=Jlev(k)
     cedge(1) = Jlev(k-1);
     break
    else
     Jlev(k-1) = Jlev(k);
    end
   end
  end
 end
 % Last limit:
 if cedge(2)>=Jlev(end)
  if ~isempty(WID)
   cedge(2) = Jlev(end);
   if WID(end)~=0
    cedge(2) = cedge(2) + WID(end)*ceil((CLIM(2)-Jlev(end))/WID(end));
   end
  else
   % continue
  end
 else
  if (Ncmaps==2)
   cedge(2) = Jlev(end);
  else
   for k = length(Jlev)-1:-1:1
    if cedge(2)>=Jlev(k)
     cedge(2) = Jlev(k+1);
     break
    else
     Jlev(k+1) = Jlev(k);
    end
   end
  end
 end
 % New Levels:
 LEV = [cedge(1); Jlev; cedge(2)];
 
end

% Gets colorband width and sets WID:
if ~isempty(Ncol)
 if isempty(WID)
  % Treats all colorbands with equal widths:
  Cwid = diff(CLIM)/sum(abs(Ncol));
  Cwid = round(Cwid*10^(-(precision-1)))*10^(precision-1);
  WID  = repmat(Cwid,Ncmaps,1);
  LEV  = [CLIM(1); CLIM(1)+cumsum(abs(Ncol))*Cwid];
 else
  % Treats WID as colorbands withs relations:
  WID   = WID/min(WID(WID~=0));
  Ncol2 = WID.*Ncol;
  Cwid  = diff(CLIM)/sum(abs(Ncol2));
  Cwid  = round(Cwid*10^(-(precision-1)))*10^(precision-1);
  WID   = WID*Cwid;
  LEV   = [CLIM(1); CLIM(1)+cumsum(abs(Ncol2))*Cwid];
 end
elseif ~isempty(WID)
 % Gets colorband width:
 Cwid  = WID(1)*10^(-precision);
 for k = 2:Ncmaps
  Cwid = gcd(Cwid,WID(k)*10^(-precision));
 end
 Cwid  = Cwid*10^precision;
else
 % Gets relation between colomaps width:
 if isempty(LEV)
  r    = ones(Ncmaps,1);
  d    = diff(CLIM);
 else
  r         = diff(LEV);
  temp      = warning('off','MATLAB:log:logOfZero');
  precision = floor(log10(abs(r))); % r = Str.XXX x 10^precision.
  precision(r==0) = 0; % precision=0 if Ncol=0.
  warning(temp.state,'MATLAB:log:logOfZero')
  precision = min(precision)-tol;
  r  = round(r*10^(-precision));
  rgcd  = r(1);
  for k = 2:Ncmaps
   rgcd = gcd(rgcd,r(k));
  end
  r = r/rgcd;
  d = (LEV(end)-LEV(1));
 end
 % Gets colorband width:
 r    = r*ceil(Tcol/sum(r));
 Cwid = d/sum(r);
 WID  = repmat(Cwid,Ncmaps,1);
end

% Sets LEV when empty:
if isempty(LEV)
 LEV = linspace(CLIM(1),CLIM(2),Ncmaps+1)';
end

% Gets number of colors for each colormap:
Ncol2 = round(diff(LEV)/Cwid);
if ~isempty(Ncol)
 % continue
else
 Ncol = round(diff(LEV)./WID);
 Ncol(~isfinite(Ncol)) = 0;
 if ~all(Ncol==round(Ncol))
  error('CVARGAS:cmjoin:incorrectWidColor',...
   'Colorband do not match each colormap width. Modify LEV or WID.')
 end
end

% Generates the colormaps:
CMAP  = zeros(sum(abs(Ncol2)),3);
xband = zeros(sum(abs(Ncol2))+1,1);
tempr = [];
for k = 1:Ncmaps
 if Ncol(k)
  r          = sum(abs(Ncol2(1:k-1)))+(1:abs(Ncol2(k)));
  if Ncol(k)~=Ncol2(k)
   CMAP(r,:) = cmapping(Ncol2(k),cmapping(Ncol(k),CMAPS{k}),'discrete');
  else
   CMAP(r,:) = cmapping(Ncol(k),CMAPS{k});
  end
  tempr      = linspace(LEV(k),LEV(k+1),abs(Ncol2(k))+1)';
  xband(r)   = tempr(1:end-1); 
 end
end
if ~isempty(tempr)
 xband(end) = tempr(end);
end

% Cuts edges:
ind = find((xband>=CLIM(1)) & (xband<=CLIM(2)));
if (ind(1)~=1) && ~(any(xband==CLIM(1)))
 ind = [ind(1)-1; ind];
end
if (ind(end)~=length(ind)) && ~(any(xband==CLIM(2)))
 ind = [ind; ind(end)+1];
end
CMAP  = CMAP(ind(1:end-1),:);
clim2 = xband(ind([1 end]));


% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

if ~nargout
 colormap(AX{:},CMAP)
 caxis(AX{:},clim2(:)');
 clear CMAP
else
 if ~isempty(AX)
  colormap(AX{:},CMAP)
  caxis(AX{:},clim2(:)');
 end
 CLIM = clim2;
 WID  = diff(LEV)./max([Ncol ones(Ncmaps,1)],[],2);
end
end
function [HL,CLIN] = cmlines(varargin)
% CMLINES   Change the color of plotted lines using the colormap.
%
%   SYNTAX:
%                 cmlines
%                 cmlines(CMAP)
%                 cmlines(H,...)
%     [HL,CLIN] = cmlines(...);
%   
%   INPUT:
%     CMAP - Color map name or handle to be used, or a Nx3 matrix of colors
%            to be used for each of the N lines or color char specifiers.
%            DEFAULT: jet.
%     H    - Handles of lines or from a axes to search for lines or from
%            figures to search for exes. If used, must be the first input.
%            DEFAULT: gca (sets colors for lines in current axes)
%
%   OUTPUT (all optional):
%     HL   - Returns the handles of lines. Is a cell array if several axes
%            handle were used as input.
%     CLIN - Returns the RGB colors of the lines. Is a cell array if
%            several axes handle were used as input.
%
%   DESCRIPTION:
%     Ths function colored the specified lines with the spectrum of the
%     given colormap. Ideal for lines on the same axes which means increase
%     (or decrease) monotonically.
%
%   EXAMPLE:
%     plot(reshape((1:10).^2,2,5))
%     cmlines
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%    
%   SEE ALSO:
%     PLOT and COLORMAP.
%     and
%     CMAPPING
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cmlines.m
%   VERSION: 1.0 (Jun 08, 2009) (<a href="matlab:web(['www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do',char(63),'objectType',char(61),'author',char(38),'objectId=1093874'])">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)

%   DISCLAIMER:
%   cmlines.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera

% INPUTS CHECK-IN
% -------------------------------------------------------------------------

% Set defaults:
HL   = {};
Ha   = gca;
CMAP = colormap;

% Checks number of inputs:
if nargin>2
 error('CVARGAS:cmlines:tooManyInputs', ...
  'At most 2 inputs are allowed.')
end
if nargout>2
 error('CVARGAS:cmlines:tooManyOutputs', ...
  'At most 2 outputs are allowed.')
end

% Checks handles of lines, axes or figure inputs:
Hl = [];
if (nargin~=0) && ~isempty(varargin{1}) && all(ishandle(varargin{1}(:))) ...
 && ((length(varargin{1})>1) || ~isa(varargin{1},'function_handle'))
 Ha = [];
 for k = 1:length(varargin{1})
  switch get(varargin{1}(k),'Type')
   case 'line'
    Hl = [Hl varargin{1}(k)];
   case 'axes'
    Ha = [Ha varargin{1}(k)];
   case {'figure','uipanel'}
    Ha = [Ha findobj(varargin{1}(k),'-depth',1,'Type','axes',...
                      '-not',{'Tag','Colorbar','-or','Tag','legend'})];
   otherwise
     warning('CVARGAS:cmlines:unrecognizedHandleInput',...
      'Ignored handle input.')
  end
 end
 varargin(1) = [];
end

% Looks for CMAP input:
if nargin && ~isempty(varargin) && ~isempty(varargin{1})
 CMAP = varargin{1};
end

% Gets line handles:
if ~isempty(Hl)
 HL{1} = Hl;
end
if ~isempty(Ha)
 for k = 1:length(Ha)
  Hl = findobj(Ha(k),'Type','line');
  if ~isempty(Hl)
   HL{end+1} = Hl;
  end
 end
end
if isempty(HL)
 if ~nargout
  clear HL
 end
 return
end

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------

% Sets color lines for each set of lines:
Nlines = length(HL);
CLIN   = cell(1,Nlines);
for k  = 1:length(HL)
 
 % Interpolates the color map:
 CLIN{k} = cmapping(length(HL{k}),CMAP);

 % Changes lines colors:
 set(HL{k},{'Color'},mat2cell(CLIN{k},ones(1,size(CLIN{k},1)),3))
 
end

% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------

if ~nargout
 clear HL
elseif Nlines==1
 HL   = HL{1};
 CLIN = CLIN{1};
end
end
function [handles,levels,parentIdx,listing] = findjobj(container,varargin) %#ok<*CTCH,*ASGLU,*MSNU,*NASGU>
%findjobj Find java objects contained within a specified java container or Matlab GUI handle
%
% Syntax:
%    [handles, levels, parentIds, listing] = findjobj(container, 'PropName',PropValue(s), ...)
%
% Input parameters:
%    container - optional handle to java container uipanel or figure. If unsupplied then current figure will be used
%    'PropName',PropValue - optional list of property pairs (case insensitive). PropName may also be named -PropName
%         'position' - filter results based on those elements that contain the specified X,Y position or a java element
%                      Note: specify a Matlab position (X,Y = pixels from bottom left corner), not a java one
%         'size'     - filter results based on those elements that have the specified W,H (in pixels)
%         'class'    - filter results based on those elements that contain the substring  (or java class) PropValue
%                      Note1: filtering is case insensitive and relies on regexp, so you can pass wildcards etc.
%                      Note2: '-class' is an undocumented findobj PropName, but only works on Matlab (not java) classes
%         'property' - filter results based on those elements that possess the specified case-insensitive property string
%                      Note1: passing a property value is possible if the argument following 'property' is a cell in the
%                             format of {'propName','propValue'}. Example: FINDJOBJ(...,'property',{'Text','click me'})
%                      Note2: partial property names (e.g. 'Tex') are accepted, as long as they're not ambiguous
%         'depth'    - filter results based on specified depth. 0=top-level, Inf=all levels (default=Inf)
%         'flat'     - same as specifying: 'depth',0
%         'not'      - negates the following filter: 'not','class','c' returns all elements EXCEPT those with class 'c'
%         'persist'  - persist figure components information, allowing much faster results for subsequent invocations
%         'nomenu'   - skip menu processing, for "lean" list of handles & much faster processing;
%                      This option is the default for HG containers but not for figure, Java or no container
%         'print'    - display all java elements in a hierarchical list, indented appropriately
%                      Note1: optional PropValue of element index or handle to java container
%                      Note2: normally this option would be placed last, after all filtering is complete. Placing this
%                             option before some filters enables debug print-outs of interim filtering results.
%                      Note3: output is to the Matlab command window unless the 'listing' (4th) output arg is requested
%         'list'     - same as 'print'
%         'debug'    - list found component positions in the Command Window
%
% Output parameters:
%    handles   - list of handles to java elements
%    levels    - list of corresponding hierarchy level of the java elements (top=0)
%    parentIds - list of indexes (in unfiltered handles) of the parent container of the corresponding java element
%    listing   - results of 'print'/'list' options (empty if these options were not specified)
%
%    Note: If no output parameter is specified, then an interactive window will be displayed with a
%    ^^^^  tree view of all container components, their properties and callbacks.
%
% Examples:
%    findjobj;                     % display list of all javaelements of currrent figure in an interactive GUI
%    handles = findjobj;           % get list of all java elements of current figure (inc. menus, toolbars etc.)
%    findjobj('print');            % list all java elements in current figure
%    findjobj('print',6);          % list all java elements in current figure, contained within its 6th element
%    handles = findjobj(hButton);                                     % hButton is a matlab button
%    handles = findjobj(gcf,'position',getpixelposition(hButton,1));  % same as above but also return hButton's panel
%    handles = findjobj(hButton,'persist');                           % same as above, persist info for future reuse
%    handles = findjobj('class','pushbutton');                        % get all pushbuttons in current figure
%    handles = findjobj('class','pushbutton','position',123,456);     % get all pushbuttons at the specified position
%    handles = findjobj(gcf,'class','pushbutton','size',23,15);       % get all pushbuttons with the specified size
%    handles = findjobj('property','Text','not','class','button');    % get all non-button elements with 'text' property
%    handles = findjobj('-property',{'Text','click me'});             % get all elements with 'text' property = 'click me'
%
% Sample usage:
%    hButton = uicontrol('string','click me');
%    jButton = findjobj(hButton,'nomenu');
%      % or: jButton = findjobj('property',{'Text','click me'});
%    jButton.setFlyOverAppearance(1);
%    jButton.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
%    set(jButton,'FocusGainedCallback',@myMatlabFunction);   % some 30 callback points available...
%    jButton.get;   % list all changeable properties...
%
%    hEditbox = uicontrol('style','edit');
%    jEditbox = findjobj(hEditbox,'nomenu');
%    jEditbox.setCaretColor(java.awt.Color.red);
%    jEditbox.KeyTypedCallback = @myCallbackFunc;  % many more callbacks where this came from...
%    jEdit.requestFocus;
%
% Technical explanation & details:
%    http://undocumentedmatlab.com/blog/findjobj/
%    http://undocumentedmatlab.com/blog/findjobj-gui-display-container-hierarchy/
%
% Known issues/limitations:
%    - Cannot currently process multiple container objects - just one at a time
%    - Initial processing is a bit slow when the figure is laden with many UI components (so better use 'persist')
%    - Passing a simple container Matlab handle is currently filtered by its position+size: should find a better way to do this
%    - Matlab uipanels are not implemented as simple java panels, and so they can't be found using this utility
%    - Labels have a write-only text property in java, so they can't be found using the 'property',{'Text','string'} notation
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab functionality.
%    It works on Matlab 7+, but use at your own risk!
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2018-09-21: Fix for R2018b suggested by Eddie (FEX); speedup suggested by Martin Lehmann (FEX); alert if trying to use with uifigure
%    2017-04-13: Fixed two edge-cases (one suggested by H. Koch)
%    2016-04-19: Fixed edge-cases in old Matlab release; slightly improved performance even further
%    2016-04-14: Improved performance for the most common use-case (single input/output): improved code + allow inspecting groot
%    2016-04-11: Improved performance for the most common use-case (single input/output)
%    2015-01-12: Differentiate between overlapping controls (for example in different tabs); fixed case of docked figure
%    2014-10-20: Additional fixes for R2014a, R2014b
%    2014-10-13: Fixes for R2014b
%    2014-01-04: Minor fix for R2014a; check for newer FEX version up to twice a day only
%    2013-12-29: Only check for newer FEX version in non-deployed mode; handled case of invisible figure container
%    2013-10-08: Fixed minor edge case (retrieving multiple scroll-panes)
%    2013-06-30: Additional fixes for the upcoming HG2
%    2013-05-15: Fix for the upcoming HG2
%    2013-02-21: Fixed HG-Java warnings
%    2013-01-23: Fixed callbacks table grouping & editing bugs; added hidden properties to the properties tooltip; updated help section
%    2013-01-13: Improved callbacks table; fixed tree refresh failure; fixed: tree node-selection didn't update the props pane nor flash the selected component
%    2012-07-25: Fixes for R2012a as well as some older Matlab releases
%    2011-12-07: Fixed 'File is empty' messages in compiled apps
%    2011-11-22: Fix suggested by Ward
%    2011-02-01: Fixes for R2011a
%    2010-06-13: Fixes for R2010b; fixed download (m-file => zip-file)
%    2010-04-21: Minor fix to support combo-boxes (aka drop-down, popup-menu) on Windows
%    2010-03-17: Important release: Fixes for R2010a, debug listing, objects not found, component containers that should be ignored etc.
%    2010-02-04: Forced an EDT redraw before processing; warned if requested handle is invisible
%    2010-01-18: Found a way to display label text next to the relevant node name
%    2009-10-28: Fixed uitreenode warning
%    2009-10-27: Fixed auto-collapse of invisible container nodes; added dynamic tree tooltips & context-menu; minor fix to version-check display
%    2009-09-30: Fix for Matlab 7.0 as suggested by Oliver W; minor GUI fix (classname font)
%    2009-08-07: Fixed edge-case of missing JIDE tables
%    2009-05-24: Added support for future Matlab versions that will not support JavaFrame
%    2009-05-15: Added sanity checks for axes items
%    2009-04-28: Added 'debug' input arg; increased size tolerance 1px => 2px
%    2009-04-23: Fixed location of popupmenus (always 20px high despite what's reported by Matlab...); fixed uiinspect processing issues; added blog link; narrower action buttons
%    2009-04-09: Automatic 'nomenu' for uicontrol inputs; significant performance improvement
%    2009-03-31: Fixed position of some Java components; fixed properties tooltip; fixed node visibility indication
%    2009-02-26: Indicated components visibility (& auto-collapse non-visible containers); auto-highlight selected component; fixes in node icons, figure title & tree refresh; improved error handling; display FindJObj version update description if available
%    2009-02-24: Fixed update check; added dedicated labels icon
%    2009-02-18: Fixed compatibility with old Matlab versions
%    2009-02-08: Callbacks table fixes; use uiinspect if available; fix update check according to new FEX website
%    2008-12-17: R2008b compatibility
%    2008-09-10: Fixed minor bug as per Johnny Smith
%    2007-11-14: Fixed edge case problem with class properties tooltip; used existing object icon if available; added checkbox option to hide standard callbacks
%    2007-08-15: Fixed object naming relative property priorities; added sanity check for illegal container arg; enabled desktop (0) container; cleaned up warnings about special class objects
%    2007-08-03: Fixed minor tagging problems with a few Java sub-classes; displayed UIClassID if text/name/tag is unavailable
%    2007-06-15: Fixed problems finding HG components found by J. Wagberg
%    2007-05-22: Added 'nomenu' option for improved performance; fixed 'export handles' bug; fixed handle-finding/display bugs; "cleaner" error handling
%    2007-04-23: HTMLized classname tooltip; returned top-level figure Frame handle for figure container; fixed callbacks table; auto-checked newer version; fixed Matlab 7.2 compatibility issue; added HG objects tree
%    2007-04-19: Fixed edge case of missing figure; displayed tree hierarchy in interactive GUI if no output args; workaround for figure sub-menus invisible unless clicked
%    2007-04-04: Improved performance; returned full listing results in 4th output arg; enabled partial property names & property values; automatically filtered out container panels if children also returned; fixed finding sub-menu items
%    2007-03-20: First version posted on the MathWorks file exchange: <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14317">http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14317</a>
%
% See also:
%    java, handle, findobj, findall, javaGetHandles, uiinspect (on the File Exchange)
% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.
% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.51 $  $Date: 2018/09/21 14:27:18 $
    % Ensure Java AWT is enabled
    error(javachk('awt'));
    persistent pContainer pHandles pLevels pParentIdx pPositions
    try
        % Initialize
        handles = handle([]);
        levels = [];
        parentIdx = [];
        positions = [];   % Java positions start at the top-left corner
        %sizes = [];
        listing = '';
        hg_levels = [];
        hg_handles = handle([]);  % HG handles are double
        hg_parentIdx = [];
        nomenu = false;
        menuBarFoundFlag = false;
        hFig = [];
        % Force an EDT redraw before processing, to ensure all uicontrols etc. are rendered
        drawnow;  pause(0.02);
        % Default container is the current figure's root panel
        if nargin
            if isempty(container)  % empty container - bail out
                return;
            elseif ischar(container)  % container skipped - this is part of the args list...
                varargin = [{container}, varargin];
                origContainer = getCurrentFigure;
                [container,contentSize] = getRootPanel(origContainer);
            elseif isequal(container,0)  % root
                origContainer = handle(container);
                container = com.mathworks.mde.desk.MLDesktop.getInstance.getMainFrame;
                contentSize = [container.getWidth, container.getHeight];
            elseif ishghandle(container) % && ~isa(container,'java.awt.Container')
                container = container(1);  % another current limitation...
                hFig = ancestor(container,'figure');
                oldWarn = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
                try hJavaFrame = get(hFig,'JavaFrame'); catch, hJavaFrame = []; end
                warning(oldWarn);
                if isempty(hJavaFrame)  % alert if trying to use with web-based (not Java-based) uifigure
                    error('YMA:findjobj:NonJavaFigure', 'Findjobj only works with Java-based figures, not web-based (App Designer) uifigures');
                end
                origContainer = handle(container);
                if isa(origContainer,'uimenu') || isa(origContainer,'matlab.ui.container.Menu')
                    % getpixelposition doesn't work for menus... - damn!
                    varargin = {'class','MenuPeer', 'property',{'Label',strrep(get(container,'Label'),'&','')}, varargin{:}};
                elseif ~isa(origContainer, 'figure') && ~isempty(hFig) && ~isa(origContainer, 'matlab.ui.Figure')
                    % For a single input & output, try using the fast variant
                    if nargin==1 && nargout==1
                        try
                            handles = findjobj_fast(container);
                            if ~isempty(handles)
                                try handles = handle(handles,'callbackproperties'); catch, end
                                return
                            end
                        catch
                            % never mind - proceed normally using the slower variant below...
                        end
                    end
                    % See limitations section above: should find a better way to directly refer to the element's java container
                    try
                        % Note: 'PixelBounds' is undocumented and unsupported, but much faster than getpixelposition!
                        % ^^^^  unfortunately, its Y position is inaccurate in some cases - damn!
                        %size = get(container,'PixelBounds');
                        pos = fix(getpixelposition(container,1));
                        %varargin = {'position',pos(1:2), 'size',pos(3:4), 'not','class','java.awt.Panel', varargin{:}};
                    catch
                        try
                            figName = get(hFig,'name');
                            if strcmpi(get(hFig,'number'),'on')
                                figName = regexprep(['Figure ' num2str(hFig) ': ' figName],': $','');
                            end
                            mde = com.mathworks.mde.desk.MLDesktop.getInstance;
                            jFig = mde.getClient(figName);
                            if isempty(jFig), error('dummy');  end
                        catch
                            jFig = get(hJavaFrame,'FigurePanelContainer');
                        end
                        pos = [];
                        try
                            pxsize = get(container,'PixelBounds');
                            pos = [pxsize(1)+5, jFig.getHeight - (pxsize(4)-5)];
                        catch
                            % never mind...
                        end
                    end
                    if size(pos,2) == 2
                        pos(:,3:4) = 0;
                    end
                    if ~isempty(pos)
                        if isa(handle(container),'uicontrol') && strcmp(get(container,'style'),'popupmenu')
                            % popupmenus (combo-box dropdowns) are always 20px high
                            pos(2) = pos(2) + pos(4) - 20;
                            pos(4) = 20;
                        end
                        %varargin = {'position',pos(1:2), 'size',size(3:4)-size(1:2)-10, 'not','class','java.awt.Panel', varargin{:}};
                        varargin = {'position',pos(1:2)+[0,pos(4)], 'size',pos(3:4), 'not','class','java.awt.Panel', 'nomenu', varargin{:}};
                    end
                elseif isempty(hFig)
                    hFig = handle(container);
                end
                [container,contentSize] = getRootPanel(hFig);
            elseif isjava(container)
                % Maybe a java container obj (will crash otherwise)
                origContainer = container;
                contentSize = [container.getWidth, container.getHeight];
            else
                error('YMA:findjobj:IllegalContainer','Input arg does not appear to be a valid GUI object');
            end
        else
            % Default container = current figure
            origContainer = getCurrentFigure;
            [container,contentSize] = getRootPanel(origContainer);
        end
        % Check persistency
        if isequal(pContainer,container)
            % persistency requested and the same container is reused, so reuse the hierarchy information
            [handles,levels,parentIdx,positions] = deal(pHandles, pLevels, pParentIdx, pPositions);
        else
            % Pre-allocate space of complex data containers for improved performance
            handles = repmat(handles,1,1000);
            positions = zeros(1000,2);
            % Check whether to skip menu processing
            nomenu = paramSupplied(varargin,'nomenu');
            % Traverse the container hierarchy and extract the elements within
            traverseContainer(container,0,1);
            % Remove unnecessary pre-allocated elements
            dataLen = length(levels);
            handles  (dataLen+1:end) = [];
            positions(dataLen+1:end,:) = [];
        end
        % Process persistency check before any filtering is done
        if paramSupplied(varargin,'persist')
            [pContainer, pHandles, pLevels, pParentIdx, pPositions] = deal(container,handles,levels,parentIdx,positions);
        end
        % Save data for possible future use in presentObjectTree() below
        allHandles = handles;
        allLevels  = levels;
        allParents = parentIdx;
        selectedIdx = 1:length(handles);
        %[positions(:,1)-container.getX, container.getHeight - positions(:,2)]
        % Debug-list all found compponents and their positions
        if paramSupplied(varargin,'debug')
            for origHandleIdx = 1 : length(allHandles)
                thisObj = handles(origHandleIdx);
                pos = sprintf('%d,%d %dx%d',[positions(origHandleIdx,:) getWidth(thisObj) getHeight(thisObj)]);
                disp([repmat(' ',1,levels(origHandleIdx)) '[' pos '] ' char(toString(thisObj))]);
            end
        end
        % Process optional args
        % Note: positions is NOT returned since it's based on java coord system (origin = top-left): will confuse Matlab users
        processArgs(varargin{:});
        % De-cell and trim listing, if only one element was found (no use for indented listing in this case)
        if iscell(listing) && length(listing)==1
            listing = strtrim(listing{1});
        end
        % If no output args and no listing requested, present the FINDJOBJ interactive GUI
        if nargout == 0 && isempty(listing)
            % Get all label positions
            hg_labels = [];
            labelPositions = getLabelsJavaPos(container);
            % Present the GUI (object tree)
            if ~isempty(container)
                presentObjectTree();
            else
                warnInvisible(varargin{:});
            end
        % Display the listing, if this was specifically requested yet no relevant output arg was specified
        elseif nargout < 4 && ~isempty(listing)
            if ~iscell(listing)
                disp(listing);
            else
                for listingIdx = 1 : length(listing)
                    disp(listing{listingIdx});
                end
            end
        end
        % If the number of output handles does not match the number of inputs, try to match via tooltips
        if nargout && numel(handles) ~= numel(origContainer)
            newHandles = handle([]);
            switchHandles = false;
            handlesToCheck = handles;
            if isempty(handles)
                handlesToCheck = allHandles;
            end
            for origHandleIdx = 1 : numel(origContainer)
                try
                    thisContainer = origContainer(origHandleIdx);
                    if isa(thisContainer,'figure') || isa(thisContainer,'matlab.ui.Figure')
                        break;
                    end
                    try
                        newHandles(origHandleIdx) = handlesToCheck(origHandleIdx); %#ok<AGROW>
                    catch
                        % maybe no corresponding handle in [handles]
                    end
                    % Assign a new random tooltip to the original (Matlab) handle
                    oldTooltip = get(thisContainer,'Tooltip');
                    newTooltip = num2str(rand,99);
                    set(thisContainer,'Tooltip',newTooltip);
                    drawnow;  % force the Java handle to sync with the Matlab prop-change
                    try
                        % Search for a Java handle that has the newly-generated tooltip
                        for newHandleIdx = 1 : numel(handlesToCheck)
                            testTooltip = '';
                            thisHandle = handlesToCheck(newHandleIdx);
                            try
                                testTooltip = char(thisHandle.getToolTipText);
                            catch
                                try testTooltip = char(thisHandle.getTooltipText); catch, end
                            end
                            if isempty(testTooltip)
                                % One more attempt - assume it's enclosed by a scroll-pane
                                try testTooltip = char(thisHandle.getViewport.getView.getToolTipText); catch, end
                            end
                            if strcmp(testTooltip, newTooltip)
                                newHandles(origHandleIdx) = thisHandle;
                                switchHandles = true;
                                break;
                            end
                        end
                    catch
                        % never mind - skip to the next handle
                    end
                    set(thisContainer,'Tooltip',oldTooltip);
                catch
                    % never mind - skip to the next handle (maybe handle doesn't have a tooltip prop)
                end
            end
            if switchHandles
                handles = newHandles;
            end
        end
        % Display a warning if the requested handle was not found because it's invisible
        if nargout && isempty(handles)
            warnInvisible(varargin{:});
        end
        return;  %debug point
    catch
        % 'Cleaner' error handling - strip the stack info etc.
        err = lasterror;  %#ok
        err.message = regexprep(err.message,'Error using ==> [^\n]+\n','');
        if isempty(findstr(mfilename,err.message))
            % Indicate error origin, if not already stated within the error message
            err.message = [mfilename ': ' err.message];
        end
        rethrow(err);
    end
    %% Display a warning if the requested handle was not found because it's invisible
    function warnInvisible(varargin)
        try
            if strcmpi(get(hFig,'Visible'),'off')
                pos = get(hFig,'Position');
                set(hFig, 'Position',pos-[5000,5000,0,0], 'Visible','on');
                drawnow; pause(0.01);
                [handles,levels,parentIdx,listing] = findjobj(origContainer,varargin{:});
                set(hFig, 'Position',pos, 'Visible','off');
            end
        catch
            % ignore - move on...
        end
        try
            stk = dbstack;
            stkNames = {stk.name};
            OutputFcnIdx = find(~cellfun(@isempty,regexp(stkNames,'_OutputFcn')));
            if ~isempty(OutputFcnIdx)
                OutputFcnName = stkNames{OutputFcnIdx};
                warning('YMA:FindJObj:OutputFcn',['No Java reference was found for the requested handle, because the figure is still invisible in ' OutputFcnName '()']);
            elseif ishandle(origContainer) && isprop(origContainer,'Visible') && strcmpi(get(origContainer,'Visible'),'off')
                warning('YMA:FindJObj:invisibleHandle','No Java reference was found for the requested handle, probably because it is still invisible');
            end
        catch
            % Never mind...
        end
    end
    %% Check existence of a (case-insensitive) optional parameter in the params list
    function [flag,idx] = paramSupplied(paramsList,paramName)
        %idx = find(~cellfun('isempty',regexpi(paramsList(cellfun(@ischar,paramsList)),['^-?' paramName])));
        idx = find(~cellfun('isempty',regexpi(paramsList(cellfun('isclass',paramsList,'char')),['^-?' paramName])));  % 30/9/2009 fix for ML 7.0 suggested by Oliver W
        flag = any(idx);
    end
    %% Get current figure (even if its 'HandleVisibility' property is 'off')
    function curFig = getCurrentFigure
        oldShowHidden = get(0,'ShowHiddenHandles');
        set(0,'ShowHiddenHandles','on');  % minor fix per Johnny Smith
        curFig = gcf;
        set(0,'ShowHiddenHandles',oldShowHidden);
    end
    %% Get Java reference to top-level (root) panel - actually, a reference to the java figure
    function [jRootPane,contentSize] = getRootPanel(hFig)
        try
            contentSize = [0,0];  % initialize
            jRootPane = hFig;
            figName = get(hFig,'name');
            if strcmpi(get(hFig,'number'),'on')
                figName = regexprep(['Figure ' num2str(hFig) ': ' figName],': $','');
            end
            mde = com.mathworks.mde.desk.MLDesktop.getInstance;
            jFigPanel = mde.getClient(figName);
            jRootPane = jFigPanel;
            jRootPane = jFigPanel.getRootPane;
        catch
            try
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
                jFrame = get(hFig,'JavaFrame');
                jFigPanel = get(jFrame,'FigurePanelContainer');
                jRootPane = jFigPanel;
                jRootPane = jFigPanel.getComponent(0).getRootPane;
            catch
                % Never mind
            end
        end
        try
            % If invalid RootPane - try another method...
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
            jFrame = get(hFig,'JavaFrame');
            jAxisComponent = get(jFrame,'AxisComponent');
            jRootPane = jAxisComponent.getParent.getParent.getRootPane;
        catch
            % Never mind
        end
        try
            % If invalid RootPane, retry up to N times
            tries = 10;
            while isempty(jRootPane) && tries>0  % might happen if figure is still undergoing rendering...
                drawnow; pause(0.001);
                tries = tries - 1;
                jRootPane = jFigPanel.getComponent(0).getRootPane;
            end
            % If still invalid, use FigurePanelContainer which is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
            if isempty(jRootPane)
                jRootPane = jFigPanel;
            end
            contentSize = [jRootPane.getWidth, jRootPane.getHeight];
            % Try to get the ancestor FigureFrame
            jRootPane = jRootPane.getTopLevelAncestor;
        catch
            % Never mind - FigurePanelContainer is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
        end
    end
    %% Traverse the container hierarchy and extract the elements within
    function traverseContainer(jcontainer,level,parent)
        persistent figureComponentFound menuRootFound
        % Record the data for this node
        %disp([repmat(' ',1,level) '<= ' char(jcontainer.toString)])
        thisIdx = length(levels) + 1;
        levels(thisIdx) = level;
        parentIdx(thisIdx) = parent;
        try newHandle = handle(jcontainer,'callbackproperties'); catch, newHandle = handle(jcontainer); end
        try handles(thisIdx) = newHandle; catch, handles = newHandle; end
        try
            positions(thisIdx,:) = getXY(jcontainer);
            %sizes(thisIdx,:) = [jcontainer.getWidth, jcontainer.getHeight];
        catch
            positions(thisIdx,:) = [0,0];
            %sizes(thisIdx,:) = [0,0];
        end
        if level>0
            positions(thisIdx,:) = positions(thisIdx,:) + positions(parent,:);
            if ~figureComponentFound && ...
               strcmp(jcontainer.getName,'fComponentContainer') && ...
               isa(jcontainer,'com.mathworks.hg.peer.FigureComponentContainer')   % there are 2 FigureComponentContainers - only process one...
                % restart coordinate system, to exclude menu & toolbar areas
                positions(thisIdx,:) = positions(thisIdx,:) - [jcontainer.getRootPane.getX, jcontainer.getRootPane.getY];
                figureComponentFound = true;
            end
        elseif level==1
            positions(thisIdx,:) = positions(thisIdx,:) + positions(parent,:);
        else
            % level 0 - initialize flags used later
            figureComponentFound = false;
            menuRootFound = false;
        end
        parentId = length(parentIdx);
        % Traverse Menu items, unless the 'nomenu' option was requested
        if ~nomenu
            try
                for child = 1 : getNumMenuComponents(jcontainer)
                    traverseContainer(jcontainer.getMenuComponent(child-1),level+1,parentId);
                end
            catch
                % Probably not a Menu container, but maybe a top-level JMenu, so discard duplicates
                %if isa(handles(end).java,'javax.swing.JMenuBar')
                if ~menuRootFound && strcmp(class(java(handles(end))),'javax.swing.JMenuBar')  %faster...
                    if removeDuplicateNode(thisIdx)
                        menuRootFound = true;
                        return;
                    end
                end
            end
        end
        % Now recursively process all this node's children (if any), except menu items if so requested
        %if isa(jcontainer,'java.awt.Container')
        try  % try-catch is faster than checking isa(jcontainer,'java.awt.Container')...
            %if jcontainer.getComponentCount,  jcontainer.getComponents,  end
            if ~nomenu || menuBarFoundFlag || isempty(strfind(class(jcontainer),'FigureMenuBar'))
                lastChildComponent = java.lang.Object;
                child = 0;
                while (child < jcontainer.getComponentCount)
                    childComponent = jcontainer.getComponent(child);
                    % Looping over menus sometimes causes jcontainer to get mixed up (probably a JITC bug), so identify & fix
                    if isequal(childComponent,lastChildComponent)
                        child = child + 1;
                        childComponent = jcontainer.getComponent(child);
                    end
                    lastChildComponent = childComponent;
                    %disp([repmat(' ',1,level) '=> ' num2str(child) ': ' char(class(childComponent))])
                    traverseContainer(childComponent,level+1,parentId);
                    child = child + 1;
                end
            else
                menuBarFoundFlag = true;  % use this flag to skip further testing for FigureMenuBar
            end
        catch
            % do nothing - probably not a container
            %dispError
        end
        % ...and yet another type of child traversal...
        try
            if ~isdeployed  % prevent 'File is empty' messages in compiled apps
                jc = jcontainer.java;
            else
                jc = jcontainer;
            end
            for child = 1 : jc.getChildCount
                traverseContainer(jc.getChildAt(child-1),level+1,parentId);
            end
        catch
            % do nothing - probably not a container
            %dispError
        end
        % TODO: Add axis (plot) component handles
    end
    %% Get the XY location of a Java component
    function xy = getXY(jcontainer)
            % Note: getX/getY are better than get(..,'X') (mem leaks),
            % ^^^^  but sometimes they fail and revert to getx.m ...
            % Note2: try awtinvoke() catch is faster than checking ismethod()...
            % Note3: using AWTUtilities.invokeAndWait() directly is even faster than awtinvoke()...
            try %if ismethod(jcontainer,'getX')
                %positions(thisIdx,:) = [jcontainer.getX, jcontainer.getY];
                cls = getClass(jcontainer);
                location = com.mathworks.jmi.AWTUtilities.invokeAndWait(jcontainer,getMethod(cls,'getLocation',[]),[]);
                x = location.getX;
                y = location.getY;
            catch %else
                try
                    x = com.mathworks.jmi.AWTUtilities.invokeAndWait(jcontainer,getMethod(cls,'getX',[]),[]);
                    y = com.mathworks.jmi.AWTUtilities.invokeAndWait(jcontainer,getMethod(cls,'getY',[]),[]);
                catch
                    try
                        x = awtinvoke(jcontainer,'getX()');
                        y = awtinvoke(jcontainer,'getY()');
                    catch
                        x = get(jcontainer,'X');
                        y = get(jcontainer,'Y');
                    end
                end
            end
            %positions(thisIdx,:) = [x, y];
            xy = [x,y];
    end
    %% Get the number of menu sub-elements
    function numMenuComponents  = getNumMenuComponents(jcontainer)
        % The following line will raise an Exception for anything except menus
        numMenuComponents = jcontainer.getMenuComponentCount;
        % No error so far, so this must be a menu container...
        % Note: Menu subitems are not visible until the top-level (root) menu gets initial focus...
        % Try several alternatives, until we get a non-empty menu (or not...)
        % TODO: Improve performance - this takes WAY too long...
        if jcontainer.isTopLevelMenu && (numMenuComponents==0)
            jcontainer.requestFocus;
            numMenuComponents = jcontainer.getMenuComponentCount;
            if (numMenuComponents == 0)
                drawnow; pause(0.001);
                numMenuComponents = jcontainer.getMenuComponentCount;
                if (numMenuComponents == 0)
                    jcontainer.setSelected(true);
                    numMenuComponents = jcontainer.getMenuComponentCount;
                    if (numMenuComponents == 0)
                        drawnow; pause(0.001);
                        numMenuComponents = jcontainer.getMenuComponentCount;
                        if (numMenuComponents == 0)
                            jcontainer.doClick;  % needed in order to populate the sub-menu components
                            numMenuComponents = jcontainer.getMenuComponentCount;
                            if (numMenuComponents == 0)
                                drawnow; %pause(0.001);
                                numMenuComponents = jcontainer.getMenuComponentCount;
                                jcontainer.doClick;  % close menu by re-clicking...
                                if (numMenuComponents == 0)
                                    drawnow; %pause(0.001);
                                    numMenuComponents = jcontainer.getMenuComponentCount;
                                end
                            else
                                % ok - found sub-items
                                % Note: no need to close menu since this will be done when focus moves to the FindJObj window
                                %jcontainer.doClick;  % close menu by re-clicking...
                            end
                        end
                    end
                    jcontainer.setSelected(false);  % de-select the menu
                end
            end
        end
    end
    %% Remove a specific tree node's data
    function nodeRemovedFlag = removeDuplicateNode(thisIdx)
        nodeRemovedFlag = false;
        for idx = 1 : thisIdx-1
            if isequal(handles(idx),handles(thisIdx))
                levels(thisIdx) = [];
                parentIdx(thisIdx) = [];
                handles(thisIdx) = [];
                positions(thisIdx,:) = [];
                %sizes(thisIdx,:) = [];
                nodeRemovedFlag = true;
                return;
            end
        end
    end
    %% Process optional args
    function processArgs(varargin)
        % Initialize
        invertFlag = false;
        listing = '';
        % Loop over all optional args
        while ~isempty(varargin) && ~isempty(handles)
            % Process the arg (and all its params)
            foundIdx = 1 : length(handles);
            if iscell(varargin{1}),  varargin{1} = varargin{1}{1};  end
            if ~isempty(varargin{1}) && varargin{1}(1)=='-'
                varargin{1}(1) = [];
            end
            switch lower(varargin{1})
                case 'not'
                    invertFlag = true;
                case 'position'
                    [varargin,foundIdx] = processPositionArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'size'
                    [varargin,foundIdx] = processSizeArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'class'
                    [varargin,foundIdx] = processClassArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'property'
                    [varargin,foundIdx] = processPropertyArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'depth'
                    [varargin,foundIdx] = processDepthArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case 'flat'
                    varargin = {'depth',0, varargin{min(2:end):end}};
                    [varargin,foundIdx] = processDepthArgs(varargin{:});
                    if invertFlag,  foundIdx = ~foundIdx;  invertFlag = false;  end
                case {'print','list'}
                    [varargin,listing] = processPrintArgs(varargin{:});
                case {'persist','nomenu','debug'}
                    % ignore - already handled in main function above
                otherwise
                    error('YMA:findjobj:IllegalOption',['Option ' num2str(varargin{1}) ' is not a valid option. Type ''help ' mfilename ''' for the full options list.']);
            end
            % If only parent-child pairs found
            foundIdx = find(foundIdx);
            if ~isempty(foundIdx) && isequal(parentIdx(foundIdx(2:2:end)),foundIdx(1:2:end))
                % Return just the children (the parent panels are uninteresting)
                foundIdx(1:2:end) = [];
            end
            
            % If several possible handles were found and the first is the container of the second
            if length(foundIdx) == 2 && isequal(handles(foundIdx(1)).java, handles(foundIdx(2)).getParent)
                % Discard the uninteresting component container
                foundIdx(1) = [];
            end
            % Filter the results
            selectedIdx = selectedIdx(foundIdx);
            handles   = handles(foundIdx);
            levels    = levels(foundIdx);
            parentIdx = parentIdx(foundIdx);
            positions = positions(foundIdx,:);
            % Remove this arg and proceed to the next one
            varargin(1) = [];
        end  % Loop over all args
    end
    %% Process 'print' option
    function [varargin,listing] = processPrintArgs(varargin)
        if length(varargin)<2 || ischar(varargin{2})
            % No second arg given, so use the first available element
            listingContainer = handles(1);  %#ok - used in evalc below
        else
            % Get the element to print from the specified second arg
            if isnumeric(varargin{2}) && (varargin{2} == fix(varargin{2}))  % isinteger doesn't work on doubles...
                if (varargin{2} > 0) && (varargin{2} <= length(handles))
                    listingContainer = handles(varargin{2});  %#ok - used in evalc below
                elseif varargin{2} > 0
                    error('YMA:findjobj:IllegalPrintFilter','Print filter index %g > number of available elements (%d)',varargin{2},length(handles));
                else
                    error('YMA:findjobj:IllegalPrintFilter','Print filter must be a java handle or positive numeric index into handles');
                end
            elseif ismethod(varargin{2},'list')
                listingContainer = varargin{2};  %#ok - used in evalc below
            else
                error('YMA:findjobj:IllegalPrintFilter','Print filter must be a java handle or numeric index into handles');
            end
            varargin(2) = [];
        end
        % use evalc() to capture output into a Matlab variable
        %listing = evalc('listingContainer.list');
        % Better solution: loop over all handles and process them one by one
        listing = cell(length(handles),1);
        for componentIdx = 1 : length(handles)
            listing{componentIdx} = [repmat(' ',1,levels(componentIdx)) char(handles(componentIdx).toString)];
        end
    end
    %% Process 'position' option
    function [varargin,foundIdx] = processPositionArgs(varargin)
        if length(varargin)>1
            positionFilter = varargin{2};
            %if (isjava(positionFilter) || iscom(positionFilter)) && ismethod(positionFilter,'getLocation')
            try  % try-catch is faster...
                % Java/COM object passed - get its position
                positionFilter = positionFilter.getLocation;
                filterXY = [positionFilter.getX, positionFilter.getY];
            catch
                if ~isscalar(positionFilter)
                    % position vector passed
                    if (length(positionFilter)>=2) && isnumeric(positionFilter)
                        % Remember that java coordinates start at top-left corner, Matlab coords start at bottom left...
                        %positionFilter = java.awt.Point(positionFilter(1), container.getHeight - positionFilter(2));
                        filterXY = [container.getX + positionFilter(1), container.getY + contentSize(2) - positionFilter(2)];
                        % Check for full Matlab position vector (x,y,w,h)
                        %if (length(positionFilter)==4)
                        %    varargin{end+1} = 'size';
                        %    varargin{end+1} = fix(positionFilter(3:4));
                        %end
                    else
                        error('YMA:findjobj:IllegalPositionFilter','Position filter must be a java UI component, or X,Y pair');
                    end
                elseif length(varargin)>2
                    % x,y passed as separate arg values
                    if isnumeric(positionFilter) && isnumeric(varargin{3})
                        % Remember that java coordinates start at top-left corner, Matlab coords start at bottom left...
                        %positionFilter = java.awt.Point(positionFilter, container.getHeight - varargin{3});
                        filterXY = [container.getX + positionFilter, container.getY + contentSize(2) - varargin{3}];
                        varargin(3) = [];
                    else
                        error('YMA:findjobj:IllegalPositionFilter','Position filter must be a java UI component, or X,Y pair');
                    end
                else
                    error('YMA:findjobj:IllegalPositionFilter','Position filter must be a java UI component, or X,Y pair');
                end
            end
            % Compute the required element positions in order to be eligible for a more detailed examination
            % Note: based on the following constraints: 0 <= abs(elementX-filterX) + abs(elementY+elementH-filterY) < 7
            baseDeltas = [positions(:,1)-filterXY(1), positions(:,2)-filterXY(2)];  % faster than repmat()...
            %baseHeight = - baseDeltas(:,2);% -abs(baseDeltas(:,1));
            %minHeight = baseHeight - 7;
            %maxHeight = baseHeight + 7;
            %foundIdx = ~arrayfun(@(b)(invoke(b,'contains',positionFilter)),handles);  % ARGH! - disallowed by Matlab!
            %foundIdx = repmat(false,1,length(handles));
            %foundIdx(length(handles)) = false;  % faster than repmat()...
            foundIdx = (abs(baseDeltas(:,1)) < 7) & (abs(baseDeltas(:,2)) < 7); % & (minHeight >= 0);
            %fi = find(foundIdx);
            %for componentIdx = 1 : length(fi)
                %foundIdx(componentIdx) = handles(componentIdx).getBounds.contains(positionFilter);
                % Search for a point no farther than 7 pixels away (prevents rounding errors)
                %foundIdx(componentIdx) = handles(componentIdx).getLocationOnScreen.distanceSq(positionFilter) < 50;  % fails for invisible components...
                %p = java.awt.Point(positions(componentIdx,1), positions(componentIdx,2) + handles(componentIdx).getHeight);
                %foundIdx(componentIdx) = p.distanceSq(positionFilter) < 50;
                %foundIdx(componentIdx) = sum(([baseDeltas(componentIdx,1),baseDeltas(componentIdx,2)+handles(componentIdx).getHeight]).^2) < 50;
                % Following is the fastest method found to date: only eligible elements are checked in detailed
            %    elementHeight = handles(fi(componentIdx)).getHeight;
            %    foundIdx(fi(componentIdx)) = elementHeight > minHeight(fi(componentIdx)) && ...
            %                                 elementHeight < maxHeight(fi(componentIdx));
                %disp([componentIdx,elementHeight,minHeight(fi(componentIdx)),maxHeight(fi(componentIdx)),foundIdx(fi(componentIdx))])
            %end
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end
    %% Process 'size' option
    function [varargin,foundIdx] = processSizeArgs(varargin)
        if length(varargin)>1
            sizeFilter = lower(varargin{2});
            %if (isjava(sizeFilter) || iscom(sizeFilter)) && ismethod(sizeFilter,'getSize')
            try  % try-catch is faster...
                % Java/COM object passed - get its size
                sizeFilter = sizeFilter.getSize;
                filterWidth  = sizeFilter.getWidth;
                filterHeight = sizeFilter.getHeight;
            catch
                if ~isscalar(sizeFilter)
                    % size vector passed
                    if (length(sizeFilter)>=2) && isnumeric(sizeFilter)
                        %sizeFilter = java.awt.Dimension(sizeFilter(1),sizeFilter(2));
                        filterWidth  = sizeFilter(1);
                        filterHeight = sizeFilter(2);
                    else
                        error('YMA:findjobj:IllegalSizeFilter','Size filter must be a java UI component, or W,H pair');
                    end
                elseif length(varargin)>2
                    % w,h passed as separate arg values
                    if isnumeric(sizeFilter) && isnumeric(varargin{3})
                        %sizeFilter = java.awt.Dimension(sizeFilter,varargin{3});
                        filterWidth  = sizeFilter;
                        filterHeight = varargin{3};
                        varargin(3) = [];
                    else
                        error('YMA:findjobj:IllegalSizeFilter','Size filter must be a java UI component, or W,H pair');
                    end
                else
                    error('YMA:findjobj:IllegalSizeFilter','Size filter must be a java UI component, or W,H pair');
                end
            end
            %foundIdx = ~arrayfun(@(b)(invoke(b,'contains',sizeFilter)),handles);  % ARGH! - disallowed by Matlab!
            foundIdx(length(handles)) = false;  % faster than repmat()...
            for componentIdx = 1 : length(handles)
                %foundIdx(componentIdx) = handles(componentIdx).getSize.equals(sizeFilter);
                % Allow a 2-pixel tollerance to account for non-integer pixel sizes
                foundIdx(componentIdx) = abs(handles(componentIdx).getWidth  - filterWidth)  <= 3 && ...  % faster than getSize.equals()
                                         abs(handles(componentIdx).getHeight - filterHeight) <= 3;
            end
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end
    %% Process 'class' option
    function [varargin,foundIdx] = processClassArgs(varargin)
        if length(varargin)>1
            classFilter = varargin{2};
            %if ismethod(classFilter,'getClass')
            try  % try-catch is faster...
                classFilter = char(classFilter.getClass);
            catch
                if ~ischar(classFilter)
                    error('YMA:findjobj:IllegalClassFilter','Class filter must be a java object, class or string');
                end
            end
            % Now convert all java classes to java.lang.Strings and compare to the requested filter string
            try
                foundIdx(length(handles)) = false;  % faster than repmat()...
                jClassFilter = java.lang.String(classFilter).toLowerCase;
                for componentIdx = 1 : length(handles)
                    % Note: JVM 1.5's String.contains() appears slightly slower and is available only since Matlab 7.2
                    foundIdx(componentIdx) = handles(componentIdx).getClass.toString.toLowerCase.indexOf(jClassFilter) >= 0;
                end
            catch
                % Simple processing: slower since it does extra processing within opaque.char()
                for componentIdx = 1 : length(handles)
                    % Note: using @toChar is faster but returns java String, not a Matlab char
                    foundIdx(componentIdx) = ~isempty(regexpi(char(handles(componentIdx).getClass),classFilter));
                end
            end
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end
    %% Process 'property' option
    function [varargin,foundIdx] = processPropertyArgs(varargin)
        if length(varargin)>1
            propertyName = varargin{2};
            if iscell(propertyName)
                if length(propertyName) == 2
                    propertyVal  = propertyName{2};
                    propertyName = propertyName{1};
                elseif length(propertyName) == 1
                    propertyName = propertyName{1};
                else
                    error('YMA:findjobj:IllegalPropertyFilter','Property filter must be a string (case insensitive name of property) or cell array {propName,propValue}');
                end
            end
            if ~ischar(propertyName)
                error('YMA:findjobj:IllegalPropertyFilter','Property filter must be a string (case insensitive name of property) or cell array {propName,propValue}');
            end
            propertyName = lower(propertyName);
            %foundIdx = arrayfun(@(h)isprop(h,propertyName),handles);  % ARGH! - disallowed by Matlab!
            foundIdx(length(handles)) = false;  % faster than repmat()...
            % Split processing depending on whether a specific property value was requested (ugly but faster...)
            if exist('propertyVal','var')
                for componentIdx = 1 : length(handles)
                    try
                        % Find out whether this element has the specified property
                        % Note: findprop() and its return value schema.prop are undocumented and unsupported!
                        prop = findprop(handles(componentIdx),propertyName);  % faster than isprop() & enables partial property names
                        % If found, compare it to the actual element's property value
                        foundIdx(componentIdx) = ~isempty(prop) && isequal(get(handles(componentIdx),prop.Name),propertyVal);
                    catch
                        % Some Java classes have a write-only property (like LabelPeer with 'Text'), so we end up here
                        % In these cases, simply assume that the property value doesn't match and continue
                        foundIdx(componentIdx) = false;
                    end
                end
            else
                for componentIdx = 1 : length(handles)
                    try
                        % Find out whether this element has the specified property
                        % Note: findprop() and its return value schema.prop are undocumented and unsupported!
                        foundIdx(componentIdx) = ~isempty(findprop(handles(componentIdx),propertyName));
                    catch
                        foundIdx(componentIdx) = false;
                    end
                end
            end
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end
    %% Process 'depth' option
    function [varargin,foundIdx] = processDepthArgs(varargin)
        if length(varargin)>1
            level = varargin{2};
            if ~isnumeric(level)
                error('YMA:findjobj:IllegalDepthFilter','Depth filter must be a number (=maximal element depth)');
            end
            foundIdx = (levels <= level);
            varargin(2) = [];
        else
            foundIdx = [];
        end
    end
    %% Convert property data into a string
    function data = charizeData(data)
        if isa(data,'com.mathworks.hg.types.HGCallback')
            data = get(data,'Callback');
        end
        if ~ischar(data) && ~isa(data,'java.lang.String')
            newData = strtrim(evalc('disp(data)'));
            try
                newData = regexprep(newData,'  +',' ');
                newData = regexprep(newData,'Columns \d+ through \d+\s','');
                newData = regexprep(newData,'Column \d+\s','');
            catch
                %never mind...
            end
            if iscell(data)
                newData = ['{ ' newData ' }'];
            elseif isempty(data)
                newData = '';
            elseif isnumeric(data) || islogical(data) || any(ishandle(data)) || numel(data) > 1 %&& ~isscalar(data)
                newData = ['[' newData ']'];
            end
            data = newData;
        elseif ~isempty(data)
            data = ['''' data ''''];
        end
    end  % charizeData
    %% Prepare a hierarchical callbacks table data
    function setProp(list,name,value,category)
        prop = eval('com.jidesoft.grid.DefaultProperty();');  % prevent JIDE alert by run-time (not load-time) evaluation
        prop.setName(name);
        prop.setType(java.lang.String('').getClass);
        prop.setValue(value);
        prop.setEditable(true);
        prop.setExpert(true);
        %prop.setCategory(['<html><b><u><font color="blue">' category ' callbacks']);
        prop.setCategory([category ' callbacks']);
        list.add(prop);
    end  % getTreeData
    %% Prepare a hierarchical callbacks table data
    function list = getTreeData(data)
        list = java.util.ArrayList();
        names = regexprep(data,'([A-Z][a-z]+).*','$1');
        %hash = java.util.Hashtable;
        others = {};
        for propIdx = 1 : size(data,1)
            if (propIdx < size(data,1) && strcmp(names{propIdx},names{propIdx+1})) || ...
               (propIdx > 1            && strcmp(names{propIdx},names{propIdx-1}))
                % Child callback property
                setProp(list,data{propIdx,1},data{propIdx,2},names{propIdx});
            else
                % Singular callback property => Add to 'Other' category at bottom of the list
                others(end+1,:) = data(propIdx,:);  %#ok
            end
        end
        for propIdx = 1 : size(others,1)
            setProp(list,others{propIdx,1},others{propIdx,2},'Other');
        end
    end  % getTreeData
    %% Get callbacks table data
    function [cbData, cbHeaders, cbTableEnabled] = getCbsData(obj, stripStdCbsFlag)
        % Initialize
        cbData = {'(no callbacks)'};
        cbHeaders = {'Callback name'};
        cbTableEnabled = false;
        cbNames = {};
        try
            try
                classHdl = classhandle(handle(obj));
                cbNames = get(classHdl.Events,'Name');
                if ~isempty(cbNames) && ~iscom(obj)  %only java-based please...
                    cbNames = strcat(cbNames,'Callback');
                end
                propNames = get(classHdl.Properties,'Name');
            catch
                % Try to interpret as an MCOS class object
                try
                    oldWarn = warning('off','MATLAB:structOnObject');
                    dataFields = struct(obj);
                    warning(oldWarn);
                catch
                    dataFields = get(obj);
                end
                propNames = fieldnames(dataFields);
            end
            propCbIdx = [];
            if ischar(propNames),  propNames={propNames};  end  % handle case of a single callback
            if ~isempty(propNames)
                propCbIdx = find(~cellfun(@isempty,regexp(propNames,'(Fcn|Callback)$')));
                cbNames = unique([cbNames; propNames(propCbIdx)]);  %#ok logical is faster but less debuggable...
            end
            if ~isempty(cbNames)
                if stripStdCbsFlag
                    cbNames = stripStdCbs(cbNames);
                end
                if iscell(cbNames)
                    cbNames = sort(cbNames);
                    if size(cbNames,1) < size(cbNames,2)
                        cbNames = cbNames';
                    end
                end
                hgHandleFlag = 0;  try hgHandleFlag = ishghandle(obj); catch, end  %#ok
                try
                    obj = handle(obj,'CallbackProperties');
                catch
                    hgHandleFlag = 1;
                end
                if hgHandleFlag
                    % HG handles don't allow CallbackProperties - search only for *Fcn
                    %cbNames = propNames(propCbIdx);
                end
                if iscom(obj)
                    cbs = obj.eventlisteners;
                    if ~isempty(cbs)
                        cbNamesRegistered = cbs(:,1);
                        cbData = setdiff(cbNames,cbNamesRegistered);
                        %cbData = charizeData(cbData);
                        if size(cbData,2) > size(cbData(1))
                            cbData = cbData';
                        end
                        cbData = [cbData, cellstr(repmat(' ',length(cbData),1))];
                        cbData = [cbData; cbs];
                        [sortedNames, sortedIdx] = sort(cbData(:,1));
                        sortedCbs = cellfun(@charizeData,cbData(sortedIdx,2),'un',0);
                        cbData = [sortedNames, sortedCbs];
                    else
                        cbData = [cbNames, cellstr(repmat(' ',length(cbNames),1))];
                    end
                elseif iscell(cbNames)
                    cbNames = sort(cbNames);
                    %cbData = [cbNames, get(obj,cbNames)'];
                    cbData = cbNames;
                    oldWarn = warning('off','MATLAB:hg:JavaSetHGProperty');
                    warning('off','MATLAB:hg:PossibleDeprecatedJavaSetHGProperty');
                    for idx = 1 : length(cbNames)
                        try
                            cbData{idx,2} = charizeData(get(obj,cbNames{idx}));
                        catch
                            cbData{idx,2} = '(callback value inaccessible)';
                        end
                    end
                    warning(oldWarn);
                else  % only one event callback
                    %cbData = {cbNames, get(obj,cbNames)'};
                    %cbData{1,2} = charizeData(cbData{1,2});
                    try
                        cbData = {cbNames, charizeData(get(obj,cbNames))};
                    catch
                        cbData = {cbNames, '(callback value inaccessible)'};
                    end
                end
                cbHeaders = {'Callback name','Callback value'};
                cbTableEnabled = true;
            end
        catch
            % never mind - use default (empty) data
        end
    end  % getCbsData
    %% Get relative (0.0-1.0) divider location
    function divLocation = getRalativeDivlocation(jDiv)
        divLocation = jDiv.getDividerLocation;
        if divLocation > 1  % i.e. [pixels]
            visibleRect = jDiv.getVisibleRect;
            if jDiv.getOrientation == 0  % vertical
                start = visibleRect.getY;
                extent = visibleRect.getHeight - start;
            else
                start = visibleRect.getX;
                extent = visibleRect.getWidth - start;
            end
            divLocation = (divLocation - start) / extent;
        end
    end  % getRalativeDivlocation
    %% Try to set a treenode icon based on a container's icon
    function setTreeNodeIcon(treenode,container)
        try
            iconImage = [];
            iconImage = container.getIcon;
            if ~isempty(findprop(handle(iconImage),'Image'))  % get(iconImage,'Image') is easier but leaks memory...
                iconImage = iconImage.getImage;
            else
                a=b; %#ok cause an error
            end
        catch
            try
                iconImage = container.getIconImage;
            catch
                try
                    if ~isempty(iconImage)
                        ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment;
                        gd = ge.getDefaultScreenDevice;
                        gc = gd.getDefaultConfiguration;
                        image = gc.createCompatibleImage(iconImage.getIconWidth, iconImage.getIconHeight);  % a BufferedImage object
                        g = image.createGraphics;
                        iconImage.paintIcon([], g, 0, 0);
                        g.dispose;
                        iconImage = image;
                    end
                catch
                    % never mind...
                end
            end
        end
        if ~isempty(iconImage)
            iconImage = setIconSize(iconImage);
            treenode.setIcon(iconImage);
        end
    end  % setTreeNodeIcon
    %% Present the object hierarchy tree
    function presentObjectTree()
        persistent lastVersionCheck
        if isempty(lastVersionCheck),  lastVersionCheck = now-1;  end
        import java.awt.*
        import javax.swing.*
        hTreeFig = findall(0,'tag','findjobjFig');
        iconpath = [matlabroot, '/toolbox/matlab/icons/'];
        cbHideStd = 0;  % Initial state of the cbHideStdCbs checkbox
        if isempty(hTreeFig)
            % Prepare the figure
            hTreeFig = figure('tag','findjobjFig','menuBar','none','toolBar','none','Name','FindJObj','NumberTitle','off','handleVisibility','off','IntegerHandle','off');
            figIcon = ImageIcon([iconpath 'tool_legend.gif']);
            drawnow;
            try
                mde = com.mathworks.mde.desk.MLDesktop.getInstance;
                jTreeFig = mde.getClient('FindJObj').getTopLevelAncestor;
                jTreeFig.setIcon(figIcon);
            catch
                warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
                jTreeFig = get(hTreeFig,'JavaFrame');
                jTreeFig.setFigureIcon(figIcon);
            end
            vsplitPaneLocation = 0.8;
            hsplitPaneLocation = 0.5;
        else
            % Remember cbHideStdCbs checkbox & dividers state for later
            userdata = get(hTreeFig, 'userdata');
            try cbHideStd = userdata.cbHideStdCbs.isSelected; catch, end  %#ok
            try
                vsplitPaneLocation = getRalativeDivlocation(userdata.vsplitPane);
                hsplitPaneLocation = getRalativeDivlocation(userdata.hsplitPane);
            catch
                vsplitPaneLocation = 0.8;
                hsplitPaneLocation = 0.5;
            end
            % Clear the figure and redraw
            clf(hTreeFig);
            figure(hTreeFig);   % bring to front
        end
        % Traverse all HG children, if root container was a HG handle
        if ishghandle(origContainer) %&& ~isequal(origContainer,container)
            traverseHGContainer(origContainer,0,0);
        end
        % Prepare the tree pane
        warning('off','MATLAB:uitreenode:MigratingFunction');  % R2008b compatibility
        warning('off','MATLAB:uitreenode:DeprecatedFunction'); % R2008a compatibility
        tree_h = com.mathworks.hg.peer.UITreePeer;
        try tree_h = javaObjectEDT(tree_h); catch, end
        tree_hh = handle(tree_h,'CallbackProperties');
        hasChildren = sum(allParents==1) > 1;
        icon = [iconpath 'upfolder.gif'];
        [rootName, rootTitle] = getNodeName(container);
        try
            root = uitreenode('v0', handle(container), rootName, icon, ~hasChildren);
        catch  % old matlab version don't have the 'v0' option
            root = uitreenode(handle(container), rootName, icon, ~hasChildren);
        end
        setTreeNodeIcon(root,container);  % constructor must accept a char icon unfortunately, so need to do this afterwards...
        if ~isempty(rootTitle)
            set(hTreeFig, 'Name',['FindJObj - ' char(rootTitle)]);
        end
        nodedata.idx = 1;
        nodedata.obj = container;
        set(root,'userdata',nodedata);
        root.setUserObject(container);
        setappdata(root,'childHandle',container);
        tree_h.setRoot(root);
        treePane = tree_h.getScrollPane;
        treePane.setMinimumSize(Dimension(50,50));
        jTreeObj = treePane.getViewport.getComponent(0);
        jTreeObj.setShowsRootHandles(true)
        jTreeObj.getSelectionModel.setSelectionMode(javax.swing.tree.TreeSelectionModel.DISCONTIGUOUS_TREE_SELECTION);
        %jTreeObj.setVisible(0);
        %jTreeObj.getCellRenderer.setLeafIcon([]);
        %jTreeObj.getCellRenderer.setOpenIcon(figIcon);
        %jTreeObj.getCellRenderer.setClosedIcon([]);
        treePanel = JPanel(BorderLayout);
        treePanel.add(treePane, BorderLayout.CENTER);
        progressBar = JProgressBar(0);
        progressBar.setMaximum(length(allHandles) + length(hg_handles));  % = # of all nodes
        treePanel.add(progressBar, BorderLayout.SOUTH);
        % Prepare the image pane
%disable for now, until we get it working...
%{
        try
            hFig = ancestor(origContainer,'figure');
            [cdata, cm] = getframe(hFig);  %#ok cm unused
            tempfname = [tempname '.png'];
            imwrite(cdata,tempfname);  % don't know how to pass directly to BufferedImage, so use disk...
            jImg = javax.imageio.ImageIO.read(java.io.File(tempfname));
            try delete(tempfname);  catch  end
            imgPanel = JPanel();
            leftPanel = JSplitPane(JSplitPane.VERTICAL_SPLIT, treePanel, imgPanel);
            leftPanel.setOneTouchExpandable(true);
            leftPanel.setContinuousLayout(true);
            leftPanel.setResizeWeight(0.8);
        catch
            leftPanel = treePanel;
        end
%}
        leftPanel = treePanel;
        % Prepare the inspector pane
        classNameLabel = JLabel(['      ' char(class(container))]);
        classNameLabel.setForeground(Color.blue);
        updateNodeTooltip(container, classNameLabel);
        inspectorPanel = JPanel(BorderLayout);
        inspectorPanel.add(classNameLabel, BorderLayout.NORTH);
        % TODO: Maybe uncomment the following when we add the HG tree - in the meantime it's unused (java properties are un-groupable)
        %objReg = com.mathworks.services.ObjectRegistry.getLayoutRegistry;
        %toolBar = awtinvoke('com.mathworks.mlwidgets.inspector.PropertyView$ToolBarStyle','valueOf(Ljava.lang.String;)','GROUPTOOLBAR');
        %inspectorPane = com.mathworks.mlwidgets.inspector.PropertyView(objReg, toolBar);
        inspectorPane = com.mathworks.mlwidgets.inspector.PropertyView;
        identifiers = disableDbstopError;  %#ok "dbstop if error" causes inspect.m to croak due to a bug - so workaround
        inspectorPane.setObject(container);
        inspectorPane.setAutoUpdate(true);
        % TODO: Add property listeners
        % TODO: Display additional props
        inspectorTable = inspectorPane;
        try
            while ~isa(inspectorTable,'javax.swing.JTable')
                inspectorTable = inspectorTable.getComponent(0);
            end
        catch
            % R2010a
            inspectorTable = inspectorPane.getComponent(0).getScrollPane.getViewport.getComponent(0);
        end
        toolTipText = 'hover mouse over the red classname above to see the full list of properties';
        inspectorTable.setToolTipText(toolTipText);
        jideTableUtils = [];
        try
            % Try JIDE features - see http://www.jidesoft.com/products/JIDE_Grids_Developer_Guide.pdf
            com.mathworks.mwswing.MJUtilities.initJIDE;
            jideTableUtils = eval('com.jidesoft.grid.TableUtils;');  % prevent JIDE alert by run-time (not load-time) evaluation
            jideTableUtils.autoResizeAllColumns(inspectorTable);
            inspectorTable.setRowAutoResizes(true);
            inspectorTable.getModel.setShowExpert(1);
        catch
            % JIDE is probably unavailable - never mind...
        end
        inspectorPanel.add(inspectorPane, BorderLayout.CENTER);
        % TODO: Add data update listeners
        % Prepare the callbacks pane
        callbacksPanel = JPanel(BorderLayout);
        stripStdCbsFlag = true;  % initial value
        [cbData, cbHeaders, cbTableEnabled] = getCbsData(container, stripStdCbsFlag);
        %{
        %classHdl = classhandle(handle(container));
        %eventNames = get(classHdl.Events,'Name');
        %if ~isempty(eventNames)
        %    cbNames = sort(strcat(eventNames,'Callback'));
        %    try
        %        cbData = [cbNames, get(container,cbNames)'];
        %    catch
        %        % R2010a
        %        cbData = cbNames;
        %        if isempty(cbData)
        %            cbData = {};
        %        elseif ~iscell(cbData)
        %            cbData = {cbData};
        %        end
        %        for idx = 1 : length(cbNames)
        %            cbData{idx,2} = get(container,cbNames{idx});
        %        end
        %    end
        %    cbTableEnabled = true;
        %else
        %    cbData = {'(no callbacks)',''};
        %    cbTableEnabled = false;
        %end
        %cbHeaders = {'Callback name','Callback value'};
        %}
        try
            % Use JideTable if available on this system
            %callbacksTableModel = javax.swing.table.DefaultTableModel(cbData,cbHeaders);  %#ok
            %callbacksTable = eval('com.jidesoft.grid.PropertyTable(callbacksTableModel);');  % prevent JIDE alert by run-time (not load-time) evaluation
            try
                list = getTreeData(cbData);  %#ok
                model = eval('com.jidesoft.grid.PropertyTableModel(list);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                % Auto-expand if only one category
                if model.getRowCount==1   % length(model.getCategories)==1 fails for some unknown reason...
                    model.expandFirstLevel;
                end
                %callbacksTable = eval('com.jidesoft.grid.TreeTable(model);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                callbacksTable = eval('com.jidesoft.grid.PropertyTable(model);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                %callbacksTable.expandFirstLevel;
                callbacksTable.setShowsRootHandles(true);
                callbacksTable.setShowTreeLines(false);
                %callbacksTable.setShowNonEditable(0);  %=SHOW_NONEDITABLE_NEITHER
                callbacksPane = eval('com.jidesoft.grid.PropertyPane(callbacksTable);');  % prevent JIDE alert by run-time (not load-time) evaluation
                callbacksPane.setShowDescription(false);
            catch
                callbacksTable = eval('com.jidesoft.grid.TreeTable(cbData,cbHeaders);');  % prevent JIDE alert by run-time (not load-time) evaluation
            end
            callbacksTable.setRowAutoResizes(true);
            callbacksTable.setColumnAutoResizable(true);
            callbacksTable.setColumnResizable(true);
            jideTableUtils.autoResizeAllColumns(callbacksTable);
            callbacksTable.setTableHeader([]);  % hide the column headers since now we can resize columns with the gridline
            callbacksLabel = JLabel(' Callbacks:');  % The column headers are replaced with a header label
            callbacksLabel.setForeground(Color.blue);
            %callbacksPanel.add(callbacksLabel, BorderLayout.NORTH);
            % Add checkbox to show/hide standard callbacks
            callbacksTopPanel = JPanel;
            callbacksTopPanel.setLayout(BoxLayout(callbacksTopPanel, BoxLayout.LINE_AXIS));
            callbacksTopPanel.add(callbacksLabel);
            callbacksTopPanel.add(Box.createHorizontalGlue);
            jcb = JCheckBox('Hide standard callbacks', cbHideStd);
            set(handle(jcb,'CallbackProperties'), 'ActionPerformedCallback',{@cbHideStdCbs_Callback,callbacksTable});
            try
                set(jcb, 'userdata',callbacksTable, 'tooltip','Hide standard Swing callbacks - only component-specific callbacks will be displayed');
            catch
                jcb.setToolTipText('Hide standard Swing callbacks - only component-specific callbacks will be displayed');
                %setappdata(jcb,'userdata',callbacksTable);
            end
            callbacksTopPanel.add(jcb);
            callbacksPanel.add(callbacksTopPanel, BorderLayout.NORTH);
        catch
            % Otherwise, use a standard Swing JTable (keep the headers to enable resizing)
            callbacksTable = JTable(cbData,cbHeaders);
        end
        cbToolTipText = 'Callbacks may be ''strings'', @funcHandle or {@funcHandle,arg1,...}';
        callbacksTable.setToolTipText(cbToolTipText);
        callbacksTable.setGridColor(inspectorTable.getGridColor);
        cbNameTextField = JTextField;
        cbNameTextField.setEditable(false);  % ensure that the callback names are not modified...
        cbNameCellEditor = DefaultCellEditor(cbNameTextField);
        cbNameCellEditor.setClickCountToStart(intmax);  % i.e, never enter edit mode...
        callbacksTable.getColumnModel.getColumn(0).setCellEditor(cbNameCellEditor);
        if ~cbTableEnabled
            try callbacksTable.getColumnModel.getColumn(1).setCellEditor(cbNameCellEditor); catch, end
        end
        hModel = callbacksTable.getModel;
        set(handle(hModel,'CallbackProperties'), 'TableChangedCallback',{@tbCallbacksChanged,container,callbacksTable});
        %set(hModel, 'UserData',container);
        try
            cbScrollPane = callbacksPane; %JScrollPane(callbacksPane);
            %cbScrollPane.setHorizontalScrollBarPolicy(cbScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        catch
            cbScrollPane = JScrollPane(callbacksTable);
            cbScrollPane.setVerticalScrollBarPolicy(cbScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        end
        callbacksPanel.add(cbScrollPane, BorderLayout.CENTER);
        callbacksPanel.setToolTipText(cbToolTipText);
        % Prepare the top-bottom JSplitPanes
        vsplitPane = JSplitPane(JSplitPane.VERTICAL_SPLIT, inspectorPanel, callbacksPanel);
        vsplitPane.setOneTouchExpandable(true);
        vsplitPane.setContinuousLayout(true);
        vsplitPane.setResizeWeight(0.8);
        % Prepare the left-right JSplitPane
        hsplitPane = JSplitPane(JSplitPane.HORIZONTAL_SPLIT, leftPanel, vsplitPane);
        hsplitPane.setOneTouchExpandable(true);
        hsplitPane.setContinuousLayout(true);
        hsplitPane.setResizeWeight(0.6);
        pos = getpixelposition(hTreeFig);
        % Prepare the bottom pane with all buttons
        lowerPanel = JPanel(FlowLayout);
        blogUrlLabel = '<a href="http://UndocumentedMatlab.com">Undocumented<br>Matlab.com</a>';
        jWebsite = createJButton(blogUrlLabel, @btWebsite_Callback, 'Visit the UndocumentedMatlab.com blog');
        jWebsite.setContentAreaFilled(0);
        lowerPanel.add(jWebsite);
        lowerPanel.add(createJButton('Refresh<br>tree',        {@btRefresh_Callback, origContainer, hTreeFig}, 'Rescan the component tree, from the root down'));
        lowerPanel.add(createJButton('Export to<br>workspace', {@btExport_Callback,  jTreeObj, classNameLabel}, 'Export the selected component handles to workspace variable findjobj_hdls'));
        lowerPanel.add(createJButton('Request<br>focus',       {@btFocus_Callback,   jTreeObj, root}, 'Set the focus on the first selected component'));
        lowerPanel.add(createJButton('Inspect<br>object',      {@btInspect_Callback, jTreeObj, root}, 'View the signature of all methods supported by the first selected component'));
        lowerPanel.add(createJButton('Check for<br>updates',   {@btCheckFex_Callback}, 'Check the MathWorks FileExchange for the latest version of FindJObj'));
        % Display everything on-screen
        globalPanel = JPanel(BorderLayout);
        globalPanel.add(hsplitPane, BorderLayout.CENTER);
        globalPanel.add(lowerPanel, BorderLayout.SOUTH);
        [obj, hcontainer] = javacomponent(globalPanel, [0,0,pos(3:4)], hTreeFig);
        set(hcontainer,'units','normalized');
        drawnow;
        hsplitPane.setDividerLocation(hsplitPaneLocation);  % this only works after the JSplitPane is displayed...
        vsplitPane.setDividerLocation(vsplitPaneLocation);  % this only works after the JSplitPane is displayed...
        %restoreDbstopError(identifiers);
        % Refresh & resize the screenshot thumbnail
%disable for now, until we get it working...
%{
        try
            hAx = axes('Parent',hTreeFig, 'units','pixels', 'position',[10,10,250,150], 'visible','off');
            axis(hAx,'image');
            image(cdata,'Parent',hAx);
            axis(hAx,'off');
            set(hAx,'UserData',cdata);
            set(imgPanel, 'ComponentResizedCallback',{@resizeImg, hAx}, 'UserData',lowerPanel);
            imgPanel.getGraphics.drawImage(jImg, 0, 0, []);
        catch
            % Never mind...
        end
%}
        % If all handles were selected (i.e., none were filtered) then only select the first
        if (length(selectedIdx) == length(allHandles)) && ~isempty(selectedIdx)
            selectedIdx = 1;
        end
        % Store handles for callback use
        userdata.handles = allHandles;
        userdata.levels  = allLevels;
        userdata.parents = allParents;
        userdata.hg_handles = hg_handles;
        userdata.hg_levels  = hg_levels;
        userdata.hg_parents = hg_parentIdx;
        userdata.initialIdx = selectedIdx;
        userdata.userSelected = false;  % Indicates the user has modified the initial selections
        userdata.inInit = true;
        userdata.jTree = jTreeObj;
        userdata.jTreePeer = tree_h;
        userdata.vsplitPane = vsplitPane;
        userdata.hsplitPane = hsplitPane;
        userdata.classNameLabel = classNameLabel;
        userdata.inspectorPane = inspectorPane;
        userdata.callbacksTable = callbacksTable;
        userdata.jideTableUtils = jideTableUtils;
        try
            userdata.cbHideStdCbs = jcb;
        catch
            userdata.cbHideStdCbs = [];
        end
        % Update userdata for use in callbacks
        try
            set(tree_h,'userdata',userdata);
        catch
            setappdata(handle(tree_h),'userdata',userdata);
        end
        try
            set(callbacksTable,'userdata',userdata);
        catch
            setappdata(callbacksTable,'userdata',userdata);
        end
        set(hTreeFig,'userdata',userdata);
        % Select the root node if requested
        % Note: we must do so here since all other nodes except the root are processed by expandNode
        if any(selectedIdx==1)
            tree_h.setSelectedNode(root);
        end
        % Set the initial cbHideStdCbs state
        try
            if jcb.isSelected
                drawnow;
                evd.getSource.isSelected = jcb.isSelected;
                cbHideStdCbs_Callback(jcb,evd,callbacksTable);
            end
        catch
            % never mind...
        end
        % Set the callback functions
        set(tree_hh, 'NodeExpandedCallback', {@nodeExpanded, tree_h});
        set(tree_hh, 'NodeSelectedCallback', {@nodeSelected, tree_h});
        % Set the tree mouse-click callback
        % Note: default actions (expand/collapse) will still be performed?
        % Note: MousePressedCallback is better than MouseClickedCallback
        %       since it fires immediately when mouse button is pressed,
        %       without waiting for its release, as MouseClickedCallback does
        handleTree = tree_h.getScrollPane;
        jTreeObj = handleTree.getViewport.getComponent(0);
        jTreeObjh = handle(jTreeObj,'CallbackProperties');
        set(jTreeObjh, 'MousePressedCallback', {@treeMousePressedCallback,tree_h});  % context (right-click) menu
        set(jTreeObjh, 'MouseMovedCallback',   @treeMouseMovedCallback);    % mouse hover tooltips
        % Update userdata
        userdata.inInit = false;
        try
            set(tree_h,'userdata',userdata);
        catch
            setappdata(handle(tree_h),'userdata',userdata);
        end
        set(hTreeFig,'userdata',userdata);
        % Pre-expand all rows
        %treePane.setVisible(false);
        expandNode(progressBar, jTreeObj, tree_h, root, 0);
        %treePane.setVisible(true);
        %jTreeObj.setVisible(1);
        % Hide the progressbar now that we've finished expanding all rows
        try
            hsplitPane.getLeftComponent.setTopComponent(treePane);
        catch
            % Probably not a vSplitPane on the left...
            hsplitPane.setLeftComponent(treePane);
        end
        hsplitPane.setDividerLocation(hsplitPaneLocation);  % need to do it again...
        % Set keyboard focus on the tree
        jTreeObj.requestFocus;
        drawnow;
        % Check for a newer version (only in non-deployed mode, and only twice a day)
        if ~isdeployed && now-lastVersionCheck > 0.5
            checkVersion();
            lastVersionCheck = now;
        end
        % Reset the last error
        lasterr('');  %#ok
    end
    %% Rresize image pane
    function resizeImg(varargin)  %#ok - unused (TODO: waiting for img placement fix...)
        try
            hPanel = varargin{1};
            hAx    = varargin{3};
            lowerPanel = get(hPanel,'UserData');
            newJPos = cell2mat(get(hPanel,{'X','Y','Width','Height'}));
            newMPos = [1,get(lowerPanel,'Height'),newJPos(3:4)];
            set(hAx, 'units','pixels', 'position',newMPos, 'Visible','on');
            uistack(hAx,'top');  % no good...
            set(hPanel,'Opaque','off');  % also no good...
        catch
            % Never mind...
            dispError
        end
        return;
    end
    %% "dbstop if error" causes inspect.m to croak due to a bug - so workaround by temporarily disabling this dbstop
    function identifiers = disableDbstopError
        dbStat = dbstatus;
        idx = find(strcmp({dbStat.cond},'error'));
        identifiers = [dbStat(idx).identifier];
        if ~isempty(idx)
            dbclear if error;
            msgbox('''dbstop if error'' had to be disabled due to a Matlab bug that would have caused Matlab to crash.', 'FindJObj', 'warn');
        end
    end
    %% Restore any previous "dbstop if error"
    function restoreDbstopError(identifiers)  %#ok
        for itemIdx = 1 : length(identifiers)
            eval(['dbstop if error ' identifiers{itemIdx}]);
        end
    end
    %% Recursively expand all nodes (except toolbar/menubar) in startup
    function expandNode(progressBar, tree, tree_h, parentNode, parentRow)
        try
            if nargin < 5
                parentPath = javax.swing.tree.TreePath(parentNode.getPath);
                parentRow = tree.getRowForPath(parentPath);
            end
            tree.expandRow(parentRow);
            progressBar.setValue(progressBar.getValue+1);
            numChildren = parentNode.getChildCount;
            if (numChildren == 0)
                pause(0.0002);  % as short as possible...
                drawnow;
            end
            nodesToUnExpand = {'FigureMenuBar','MLMenuBar','MJToolBar','Box','uimenu','uitoolbar','ScrollBar'};
            numChildren = parentNode.getChildCount;
            for childIdx = 0 : numChildren-1
                childNode = parentNode.getChildAt(childIdx);
                % Pre-select the node based upon the user's FINDJOBJ filters
                try
                    nodedata = get(childNode, 'userdata');
                    try
                        userdata = get(tree_h, 'userdata');
                    catch
                        userdata = getappdata(handle(tree_h), 'userdata');
                    end
                    %fprintf('%d - %s\n',nodedata.idx,char(nodedata.obj))
                    if ~ishghandle(nodedata.obj) && ~userdata.userSelected && any(userdata.initialIdx == nodedata.idx)
                        pause(0.0002);  % as short as possible...
                        drawnow;
                        if isempty(tree_h.getSelectedNodes)
                            tree_h.setSelectedNode(childNode);
                        else
                            newSelectedNodes = [tree_h.getSelectedNodes, childNode];
                            tree_h.setSelectedNodes(newSelectedNodes);
                        end
                    end
                catch
                    % never mind...
                    dispError
                end
                % Expand child node if not leaf & not toolbar/menubar
                if childNode.isLeafNode
                    % This is a leaf node, so simply update the progress-bar
                    progressBar.setValue(progressBar.getValue+1);
                else
                    % Expand all non-leaves
                    expandNode(progressBar, tree, tree_h, childNode);
                    % Re-collapse toolbar/menubar etc., and also invisible containers
                    % Note: if we simply did nothing, progressbar would not have been updated...
                    try
                        childHandle = getappdata(childNode,'childHandle');  %=childNode.getUserObject
                        visible = childHandle.isVisible;
                    catch
                        visible = 1;
                    end
                    visible = visible && isempty(findstr(get(childNode,'Name'),'color="gray"'));
                    %if any(strcmp(childNode.getName,nodesToUnExpand))
                    %name = char(childNode.getName);
                    if any(cellfun(@(s)~isempty(strmatch(s,char(childNode.getName))),nodesToUnExpand)) || ~visible
                        childPath = javax.swing.tree.TreePath(childNode.getPath);
                        childRow = tree.getRowForPath(childPath);
                        tree.collapseRow(childRow);
                    end
                end
            end
        catch
            % never mind...
            dispError
        end
    end
    %% Create utility buttons
    function hButton = createJButton(nameStr, handler, toolTipText)
        try
            jButton = javax.swing.JButton(['<html><body><center>' nameStr]);
            jButton.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
            jButton.setToolTipText(toolTipText);
            try
                minSize = jButton.getMinimumSize;
            catch
                minSize = jButton.getMinimumSize;  % for HG2 - strange indeed that this is needed!
            end
            jButton.setMinimumSize(java.awt.Dimension(minSize.getWidth,35));
            hButton = handle(jButton,'CallbackProperties');
            set(hButton,'ActionPerformedCallback',handler);
        catch
            % Never mind...
            a= 1;
        end
    end
    %% Flash a component off/on for the specified duration
    % note: starts with 'on'; if numTimes is odd then ends with 'on', otherwise with 'off'
    function flashComponent(jComps,delaySecs,numTimes)
        persistent redBorder redBorderPanels
        try
            % Handle callback data from right-click (context-menu)
            if iscell(numTimes)
                [jComps,delaySecs,numTimes] = deal(numTimes{:});
            end
            if isempty(redBorder)  % reuse if possible
                redBorder = javax.swing.border.LineBorder(java.awt.Color.red,2,0);
            end
            for compIdx = 1 : length(jComps)
                try
                    oldBorder{compIdx} = jComps(compIdx).getBorder;  %#ok grow
                catch
                    oldBorder{compIdx} = [];  %#ok grow
                end
                isSettable(compIdx) = ismethod(jComps(compIdx),'setBorder');  %#ok grow
                if isSettable(compIdx)
                    try
                        % some components prevent border modification:
                        oldBorderFlag = jComps(compIdx).isBorderPainted;
                        if ~oldBorderFlag
                            jComps(compIdx).setBorderPainted(1);
                            isSettable(compIdx) = jComps(compIdx).isBorderPainted;  %#ok grow
                            jComps(compIdx).setBorderPainted(oldBorderFlag);
                        end
                    catch
                        % do nothing...
                    end
                end
                if compIdx > length(redBorderPanels)
                    redBorderPanels{compIdx} = javax.swing.JPanel;
                    redBorderPanels{compIdx}.setBorder(redBorder);
                    redBorderPanels{compIdx}.setOpaque(0);  % transparent interior, red border
                end
                try
                    redBorderPanels{compIdx}.setBounds(jComps(compIdx).getBounds);
                catch
                    % never mind - might be an HG handle
                end
            end
            for idx = 1 : 2*numTimes
                if idx>1,  pause(delaySecs);  end  % don't pause at start
                visible = mod(idx,2);
                for compIdx = 1 : length(jComps)
                    try
                        jComp = jComps(compIdx);
                        % Prevent Matlab crash (java buffer overflow...)
                        if isa(jComp,'com.mathworks.mwswing.desk.DTSplitPane') || ...
                           isa(jComp,'com.mathworks.mwswing.MJSplitPane')
                            continue;
                        % HG handles are highlighted by setting their 'Selected' property
                        elseif isa(jComp,'uimenu') || isa(jComp,'matlab.ui.container.Menu')
                            if visible
                                oldColor = get(jComp,'ForegroundColor');
                                setappdata(jComp,'findjobj_oldColor',oldColor);
                                set(jComp,'ForegroundColor','red');
                            else
                                oldColor = getappdata(jComp,'findjobj_oldColor');
                                set(jComp,'ForegroundColor',oldColor);
                                rmappdata(jComp,'ForegroundColor');
                            end
                        elseif ishghandle(jComp)
                            if visible
                                set(jComp,'Selected','on');
                            else
                                set(jComp,'Selected','off');
                            end
                        else %if isjava(jComp)
                            jParent = jComps(compIdx).getParent;
                            % Most Java components allow modifying their borders
                            if isSettable(compIdx)
                                if visible
                                    jComp.setBorder(redBorder);
                                    try jComp.setBorderPainted(1); catch, end  %#ok
                                else %if ~isempty(oldBorder{compIdx})
                                    jComp.setBorder(oldBorder{compIdx});
                                end
                                jComp.repaint;
                            % The other Java components are highlighted by a transparent red-border
                            % panel that is placed on top of them in their parent's space
                            elseif ~isempty(jParent)
                                if visible
                                    jParent.add(redBorderPanels{compIdx});
                                    jParent.setComponentZOrder(redBorderPanels{compIdx},0);
                                else
                                    jParent.remove(redBorderPanels{compIdx});
                                end
                                jParent.repaint
                            end
                        end
                    catch
                        % never mind - try the next component (if any)
                    end
                end
                drawnow;
            end
        catch
            % never mind...
            dispError;
        end
        return;  % debug point
    end  % flashComponent
    %% Select tree node
    function nodeSelected(src, evd, tree)  %#ok
        try
            if iscell(tree)
                [src,node] = deal(tree{:});
            else
                node = evd.getCurrentNode;
            end
            %nodeHandle = node.getUserObject;
            nodedata = get(node,'userdata');
            nodeHandle = nodedata.obj;
            try
                userdata = get(src,'userdata');
            catch
                try
                    userdata = getappdata(java(src),'userdata');
                catch
                    userdata = getappdata(src,'userdata');
                end
                if isempty(userdata)
                    try userdata = get(java(src),'userdata'); catch, end
                end
            end
            if ~isempty(nodeHandle) && ~isempty(userdata)
                numSelections  = userdata.jTree.getSelectionCount;
                selectionPaths = userdata.jTree.getSelectionPaths;
                if (numSelections == 1)
                    % Indicate that the user has modified the initial selection (except if this was an initial auto-selected node)
                    if ~userdata.inInit
                        userdata.userSelected = true;
                        try
                            set(src,'userdata',userdata);
                        catch
                            try
                                setappdata(java(src),'userdata',userdata);
                            catch
                                setappdata(src,'userdata',userdata);
                            end
                        end
                    end
                    % Update the fully-qualified class name label
                    numInitialIdx = length(userdata.initialIdx);
                    thisHandle = nodeHandle;
                    try
                        if ~ishghandle(thisHandle)
                            thisHandle = java(nodeHandle);
                        end
                    catch
                        % never mind...
                    end
                    if ~userdata.inInit || (numInitialIdx == 1)
                        userdata.classNameLabel.setText(['      ' char(class(thisHandle))]);
                    else
                        userdata.classNameLabel.setText([' ' num2str(numInitialIdx) 'x handles (some handles hidden by unexpanded tree nodes)']);
                    end
                    if ishghandle(thisHandle)
                        userdata.classNameLabel.setText(userdata.classNameLabel.getText.concat(' (HG handle)'));
                    end
                    userdata.inspectorPane.dispose;  % remove props listeners - doesn't work...
                    updateNodeTooltip(nodeHandle, userdata.classNameLabel);
                    % Update the data properties inspector pane
                    % Note: we can't simply use the evd nodeHandle, because this node might have been DE-selected with only one other node left selected...
                    %nodeHandle = selectionPaths(1).getLastPathComponent.getUserObject;
                    nodedata = get(selectionPaths(1).getLastPathComponent,'userdata');
                    nodeHandle = nodedata.obj;
                    %identifiers = disableDbstopError;  % "dbstop if error" causes inspect.m to croak due to a bug - so workaround
                    userdata.inspectorPane.setObject(thisHandle);
                    % Update the callbacks table
                    try
                        stripStdCbsFlag = getappdata(userdata.callbacksTable,'hideStdCbs');
                        [cbData, cbHeaders, cbTableEnabled] = getCbsData(nodeHandle, stripStdCbsFlag);  %#ok cbTableEnabled unused
                        try
                            % Use JideTable if available on this system
                            list = getTreeData(cbData);  %#ok
                            callbacksTableModel = eval('com.jidesoft.grid.PropertyTableModel(list);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                            
                            % Expand if only one category
                            if length(callbacksTableModel.getCategories)==1
                                callbacksTableModel.expandFirstLevel;
                            end
                        catch
                            callbacksTableModel = javax.swing.table.DefaultTableModel(cbData,cbHeaders);
                        end
                        set(handle(callbacksTableModel,'CallbackProperties'), 'TableChangedCallback',{@tbCallbacksChanged,nodeHandle,userdata.callbacksTable});
                        %set(callbacksTableModel, 'UserData',nodeHandle);
                        userdata.callbacksTable.setModel(callbacksTableModel)
                        userdata.callbacksTable.setRowAutoResizes(true);
                        userdata.jideTableUtils.autoResizeAllColumns(userdata.callbacksTable);
                    catch
                        % never mind...
                        %dispError
                    end
                    pause(0.005);
                    drawnow;
                    %restoreDbstopError(identifiers);
                    % Highlight the selected object (if visible)
                    flashComponent(nodeHandle,0.2,3);
                elseif (numSelections > 1)  % Multiple selections
                    % Get the list of all selected nodes
                    jArray = javaArray('java.lang.Object', numSelections);
                    toolTipStr = '<html>';
                    sameClassFlag = true;
                    for idx = 1 : numSelections
                        %jArray(idx) = selectionPaths(idx).getLastPathComponent.getUserObject;
                        nodedata = get(selectionPaths(idx).getLastPathComponent,'userdata');
                        try
                            if ishghandle(nodedata.obj)
                                if idx==1
                                    jArray = nodedata.obj;
                                else
                                    jArray(idx) = nodedata.obj;
                                end
                            else
                                jArray(idx) = java(nodedata.obj);
                            end
                        catch
                            jArray(idx) = nodedata.obj;
                        end
                        toolTipStr = [toolTipStr '&nbsp;' class(jArray(idx)) '&nbsp;'];  %#ok grow
                        if (idx < numSelections),  toolTipStr = [toolTipStr '<br>'];  end  %#ok grow
                        try
                            if (idx > 1) && sameClassFlag && ~isequal(jArray(idx).getClass,jArray(1).getClass)
                                sameClassFlag = false;
                            end
                        catch
                            if (idx > 1) && sameClassFlag && ~isequal(class(jArray(idx)),class(jArray(1)))
                                sameClassFlag = false;
                            end
                        end
                    end
                    toolTipStr = [toolTipStr '</html>'];
                    % Update the fully-qualified class name label
                    if sameClassFlag
                        classNameStr = class(jArray(1));
                    else
                        classNameStr = 'handle';
                    end
                    if all(ishghandle(jArray))
                        if strcmp(classNameStr,'handle')
                            classNameStr = 'HG handles';
                        else
                            classNameStr = [classNameStr ' (HG handles)'];
                        end
                    end
                    classNameStr = [' ' num2str(numSelections) 'x ' classNameStr];
                    userdata.classNameLabel.setText(classNameStr);
                    userdata.classNameLabel.setToolTipText(toolTipStr);
                    % Update the data properties inspector pane
                    %identifiers = disableDbstopError;  % "dbstop if error" causes inspect.m to croak due to a bug - so workaround
                    if isjava(jArray)
                        jjArray = jArray;
                    else
                        jjArray = javaArray('java.lang.Object', numSelections);
                        for idx = 1 : numSelections
                            jjArray(idx) = java(jArray(idx));
                        end
                    end
                    userdata.inspectorPane.getRegistry.setSelected(jjArray, true);
                    % Update the callbacks table
                    try
                        % Get intersecting callback names & values
                        stripStdCbsFlag = getappdata(userdata.callbacksTable,'hideStdCbs');
                        [cbData, cbHeaders, cbTableEnabled] = getCbsData(jArray(1), stripStdCbsFlag);  %#ok cbHeaders & cbTableEnabled unused
                        if ~isempty(cbData)
                            cbNames = cbData(:,1);
                            for idx = 2 : length(jArray)
                                [cbData2, cbHeaders2] = getCbsData(jArray(idx), stripStdCbsFlag);  %#ok cbHeaders2 unused
                                if ~isempty(cbData2)
                                    newCbNames = cbData2(:,1);
                                    [cbNames, cbIdx, cb2Idx] = intersect(cbNames,newCbNames);  %#ok cb2Idx unused
                                    cbData = cbData(cbIdx,:);
                                    for cbIdx = 1 : length(cbNames)
                                        newIdx = find(strcmp(cbNames{cbIdx},newCbNames));
                                        if ~isequal(cbData2,cbData) && ~isequal(cbData2{newIdx,2}, cbData{cbIdx,2})
                                            cbData{cbIdx,2} = '<different values>';
                                        end
                                    end
                                else
                                    cbData = cbData([],:);  %=empty cell array
                                end
                                if isempty(cbData)
                                    break;
                                end
                            end
                        end
                        cbHeaders = {'Callback name','Callback value'};
                        try
                            % Use JideTable if available on this system
                            list = getTreeData(cbData);  %#ok
                            callbacksTableModel = eval('com.jidesoft.grid.PropertyTableModel(list);');  %#ok prevent JIDE alert by run-time (not load-time) evaluation
                            
                            % Expand if only one category
                            if length(callbacksTableModel.getCategories)==1
                                callbacksTableModel.expandFirstLevel;
                            end
                        catch
                            callbacksTableModel = javax.swing.table.DefaultTableModel(cbData,cbHeaders);
                        end
                        set(handle(callbacksTableModel,'CallbackProperties'), 'TableChangedCallback',{@tbCallbacksChanged,jArray,userdata.callbacksTable});
                        %set(callbacksTableModel, 'UserData',jArray);
                        userdata.callbacksTable.setModel(callbacksTableModel)
                        userdata.callbacksTable.setRowAutoResizes(true);
                        userdata.jideTableUtils.autoResizeAllColumns(userdata.callbacksTable);
                    catch
                        % never mind...
                        dispError
                    end
                    pause(0.005);
                    drawnow;
                    %restoreDbstopError(identifiers);
                    % Highlight the selected objects (if visible)
                    flashComponent(jArray,0.2,3);
                end
                % TODO: Auto-highlight selected object (?)
                %nodeHandle.requestFocus;
            end
        catch
            dispError
        end
    end
    %% IFF utility function for annonymous cellfun funcs
    function result = iff(test,trueVal,falseVal)  %#ok
        try
            if test
                result = trueVal;
            else
                result = falseVal;
            end
        catch
            result = false;
        end
    end
    %% Get an HTML representation of the object's properties
    function dataFieldsStr = getPropsHtml(nodeHandle, dataFields)
        try
            % Get a text representation of the fieldnames & values
            undefinedStr = '';
            hiddenStr = '';
            dataFieldsStr = '';  % just in case the following croaks...
            if isempty(dataFields)
                return;
            end
            dataFieldsStr = evalc('disp(dataFields)');
            if dataFieldsStr(end)==char(10),  dataFieldsStr=dataFieldsStr(1:end-1);  end
            % Strip out callbacks
            dataFieldsStr = regexprep(dataFieldsStr,'^\s*\w*Callback(Data)?:[^\n]*$','','lineanchors');
            % Strip out internal HG2 mirror properties
            dataFieldsStr = regexprep(dataFieldsStr,'^\s*\w*_I:[^\n]*$','','lineanchors');
            dataFieldsStr = regexprep(dataFieldsStr,'\n\n+','\n');
            % Sort the fieldnames
            %fieldNames = fieldnames(dataFields);
            try
                [a,b,c,d] = regexp(dataFieldsStr,'(\w*): ');
                fieldNames = strrep(d,': ','');
            catch
                fieldNames = fieldnames(dataFields);
            end
            try
                [fieldNames, sortedIdx] = sort(fieldNames);
                s = strsplit(dataFieldsStr, sprintf('\n'))';
                dataFieldsStr = strjoin(s(sortedIdx), sprintf('\n'));
            catch
                % never mind... - ignore, leave unsorted
            end
            % Convert into a Matlab handle()
            %nodeHandle = handle(nodeHandle);
            try
                % ensure this is a Matlab handle, not a java object
                nodeHandle = handle(nodeHandle, 'CallbackProperties');
            catch
                try
                    % HG handles don't allow CallbackProperties...
                    nodeHandle = handle(nodeHandle);
                catch
                    % Some Matlab class objects simply cannot be converted into a handle()
                end
            end
            % HTMLize tooltip data
            % First, set the fields' font based on its read-write status
            for fieldIdx = 1 : length(fieldNames)
                thisFieldName = fieldNames{fieldIdx};
                %accessFlags = get(findprop(nodeHandle,thisFieldName),'AccessFlags');
                try
                    hProp = findprop(nodeHandle,thisFieldName);
                    accessFlags = get(hProp,'AccessFlags');
                    visible = get(hProp,'Visible');
                catch
                    accessFlags = [];
                    visible = 'on';
                    try if hProp.Hidden, visible='off'; end, catch, end
                end
                %if isfield(accessFlags,'PublicSet') && strcmp(accessFlags.PublicSet,'on')
                if (~isempty(hProp) && isprop(hProp,'SetAccess') && isequal(hProp.SetAccess,'public')) || ...  % isequal(...'public') and not strcmpi(...) because might be a cell array of classes
                   (~isempty(accessFlags) && isfield(accessFlags,'PublicSet') && strcmpi(accessFlags.PublicSet,'on'))
                    % Bolden read/write fields
                    thisFieldFormat = ['<b>' thisFieldName '</b>:$2'];
                %elseif ~isfield(accessFlags,'PublicSet')
                elseif (isempty(hProp) || ~isprop(hProp,'SetAccess')) && ...
                       (isempty(accessFlags) || ~isfield(accessFlags,'PublicSet'))
                    % Undefined - probably a Matlab-defined field of com.mathworks.hg.peer.FigureFrameProxy...
                    thisFieldFormat = ['<font color="blue">' thisFieldName '</font>:$2'];
                    undefinedStr = ', <font color="blue">undefined</font>';
                else % PublicSet=='off'
                    % Gray-out & italicize any read-only fields
                    thisFieldFormat = ['<font color="#C0C0C0">' thisFieldName '</font>:<font color="#C0C0C0">$2</font>'];
                end
                if strcmpi(visible,'off')
                    %thisFieldFormat = ['<i>' thisFieldFormat '</i>']; %#ok<AGROW>
                    thisFieldFormat = regexprep(thisFieldFormat, {'(.*):(.*)','<.?b>'}, {'<i>$1:<i>$2',''}); %'(.*):(.*)', '<i>$1:<i>$2');
                    hiddenStr = ', <i>hidden</i>';
                end
                dataFieldsStr = regexprep(dataFieldsStr, ['([\s\n])' thisFieldName ':([^\n]*)'], ['$1' thisFieldFormat]);
            end
        catch
            % never mind... - probably an ambiguous property name
            %dispError
        end
        % Method 1: simple <br> list
        %dataFieldsStr = strrep(dataFieldsStr,char(10),'&nbsp;<br>&nbsp;&nbsp;');
        % Method 2: 2-column <table>
        dataFieldsStr = regexprep(dataFieldsStr, '^\s*([^:]+:)([^\n]*)\n^\s*([^:]+:)([^\n]*)$', '<tr><td>&nbsp;$1</td><td>&nbsp;$2</td><td>&nbsp;&nbsp;&nbsp;&nbsp;$3</td><td>&nbsp;$4&nbsp;</td></tr>', 'lineanchors');
        dataFieldsStr = regexprep(dataFieldsStr, '^[^<]\s*([^:]+:)([^\n]*)$', '<tr><td>&nbsp;$1</td><td>&nbsp;$2</td><td>&nbsp;</td><td>&nbsp;</td></tr>', 'lineanchors');
        dataFieldsStr = ['(<b>documented</b>' undefinedStr hiddenStr ' &amp; <font color="#C0C0C0">read-only</font> fields)<p>&nbsp;&nbsp;<table cellpadding="0" cellspacing="0">' dataFieldsStr '</table>'];
    end
    %% Update tooltip string with a node's data
    function updateNodeTooltip(nodeHandle, uiObject)
        try
            toolTipStr = class(nodeHandle);
            dataFieldsStr = '';
            % Add HG annotation if relevant
            if ishghandle(nodeHandle)
                hgStr = ' HG Handle';
            else
                hgStr = '';
            end
            % Prevent HG-Java warnings
            oldWarn = warning('off','MATLAB:hg:JavaSetHGProperty');
            warning('off','MATLAB:hg:PossibleDeprecatedJavaSetHGProperty');
            warning('off','MATLAB:hg:Root');
            % Note: don't bulk-get because (1) not all properties are returned & (2) some properties cause a Java exception
            % Note2: the classhandle approach does not enable access to user-defined schema.props
            ch = classhandle(handle(nodeHandle));
            dataFields = [];
            [sortedNames, sortedIdx] = sort(get(ch.Properties,'Name'));
            for idx = 1 : length(sortedIdx)
                sp = ch.Properties(sortedIdx(idx));
                % TODO: some fields (see EOL comment below) generate a Java Exception from: com.mathworks.mlwidgets.inspector.PropertyRootNode$PropertyListener$1$1.run
                if strcmp(sp.AccessFlags.PublicGet,'on') % && ~any(strcmp(sp.Name,{'FixedColors','ListboxTop','Extent'}))
                    try
                        dataFields.(sp.Name) = get(nodeHandle, sp.Name);
                    catch
                        dataFields.(sp.Name) = '<font color="red">Error!</font>';
                    end
                else
                    dataFields.(sp.Name) = '(no public getter method)';
                end
            end
            dataFieldsStr = getPropsHtml(nodeHandle, dataFields);
        catch
            % Probably a non-HG java object
            try
                % Note: the bulk-get approach enables access to user-defined schema-props, but not to some original classhandle Properties...
                try
                    oldWarn3 = warning('off','MATLAB:structOnObject');
                    dataFields = struct(nodeHandle);
                    warning(oldWarn3);
                catch
                    dataFields = get(nodeHandle);
                end
                dataFieldsStr = getPropsHtml(nodeHandle, dataFields);
            catch
                % Probably a missing property getter implementation
                try
                    % Inform the user - bail out on error
                    err = lasterror;  %#ok
                    dataFieldsStr = ['<p>' strrep(err.message, char(10), '<br>')];
                catch
                    % forget it...
                end
            end
        end
        % Restore warnings
        try warning(oldWarn); catch, end
        % Set the object tooltip
        if ~isempty(dataFieldsStr)
            toolTipStr = ['<html>&nbsp;<b><font color="blue">' char(toolTipStr) '</font></b>' hgStr ':&nbsp;' dataFieldsStr '</html>'];
        end
        uiObject.setToolTipText(toolTipStr);
    end
    %% Expand tree node
    function nodeExpanded(src, evd, tree)  %#ok
        % tree = handle(src);
        % evdsrc = evd.getSource;
        evdnode = evd.getCurrentNode;
        if ~tree.isLoaded(evdnode)
            % Get the list of children TreeNodes
            childnodes = getChildrenNodes(tree, evdnode);
            % Add the HG sub-tree (unless already included in the first tree)
            childHandle = getappdata(evdnode.handle,'childHandle');  %=evdnode.getUserObject
            if evdnode.isRoot && ~isempty(hg_handles) && ~isequal(hg_handles(1).java, childHandle)
                childnodes = [childnodes, getChildrenNodes(tree, evdnode, true)];
            end
            % If we have a single child handle, wrap it within a javaArray for tree.add() to "swallow"
            if (length(childnodes) == 1)
                chnodes = childnodes;
                childnodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);
                childnodes(1) = java(chnodes);
            end
            % Add child nodes to the current node
            tree.add(evdnode, childnodes);
            tree.setLoaded(evdnode, true);
        end
    end
    %% Get an icon image no larger than 16x16 pixels
    function iconImage = setIconSize(iconImage)
        try
            iconWidth  = iconImage.getWidth;
            iconHeight = iconImage.getHeight;
            if iconWidth > 16
                newHeight = fix(iconHeight * 16 / iconWidth);
                iconImage = iconImage.getScaledInstance(16,newHeight,iconImage.SCALE_SMOOTH);
            elseif iconHeight > 16
                newWidth = fix(iconWidth * 16 / iconHeight);
                iconImage = iconImage.getScaledInstance(newWidth,16,iconImage.SCALE_SMOOTH);
            end
        catch
            % never mind... - return original icon
        end
    end  % setIconSize
    %% Get list of children nodes
    function nodes = getChildrenNodes(tree, parentNode, isRootHGNode)
        try
            iconpath = [matlabroot, '/toolbox/matlab/icons/'];
            nodes = handle([]);
            try
                userdata = get(tree,'userdata');
            catch
                userdata = getappdata(handle(tree),'userdata');
            end
            hdls = userdata.handles;
            nodedata = get(parentNode,'userdata');
            if nargin < 3
                %isJavaNode = ~ishghandle(parentNode.getUserObject);
                isJavaNode = ~ishghandle(nodedata.obj);
                isRootHGNode = false;
            else
                isJavaNode = ~isRootHGNode;
            end
            % Search for this parent node in the list of all nodes
            parents = userdata.parents;
            nodeIdx = nodedata.idx;
            if isJavaNode && isempty(nodeIdx)  % Failback, in case userdata doesn't work for some reason...
                for hIdx = 1 : length(hdls)
                    %if isequal(handle(parentNode.getUserObject), hdls(hIdx))
                    if isequal(handle(nodedata.obj), hdls(hIdx))
                        nodeIdx = hIdx;
                        break;
                    end
                end
            end
            if ~isJavaNode
                if isRootHGNode  % =root HG node
                    thisChildHandle = userdata.hg_handles(1);
                    childName = getNodeName(thisChildHandle);
                    hasGrandChildren = any(parents==1);
                    icon = [];
                    if hasGrandChildren && length(hg_handles)>1
                        childName = childName.concat(' - HG root container');
                        icon = [iconpath 'figureicon.gif'];
                    end
                    try
                        nodes = uitreenode('v0', thisChildHandle, childName, icon, ~hasGrandChildren);
                    catch  % old matlab version don't have the 'v0' option
                        try
                            nodes = uitreenode(thisChildHandle, childName, icon, ~hasGrandChildren);
                        catch
                            % probably an invalid handle - ignore...
                        end
                    end
                    % Add the handler to the node's internal data
                    % Note: could also use 'userdata', but setUserObject() is recommended for TreeNodes
                    % Note2: however, setUserObject() sets a java *BeenAdapter object for HG handles instead of the required original class, so use setappdata
                    %nodes.setUserObject(thisChildHandle);
                    setappdata(nodes,'childHandle',thisChildHandle);
                    nodedata.idx = 1;
                    nodedata.obj = thisChildHandle;
                    set(nodes,'userdata',nodedata);
                    return;
                else  % non-root HG node
                    parents = userdata.hg_parents;
                    hdls    = userdata.hg_handles;
                end  % if isRootHGNode
            end  % if ~isJavaNode
            % If this node was found, get the list of its children
            if ~isempty(nodeIdx)
                %childIdx = setdiff(find(parents==nodeIdx),nodeIdx);
                childIdx = find(parents==nodeIdx);
                childIdx(childIdx==nodeIdx) = [];  % faster...
                numChildren = length(childIdx);
                for cIdx = 1 : numChildren
                    thisChildIdx = childIdx(cIdx);
                    try thisChildHandle = hdls(thisChildIdx); catch, continue, end
                    childName = getNodeName(thisChildHandle);
                    try
                        visible = thisChildHandle.Visible;
                        if visible
                            try visible = thisChildHandle.Width > 0; catch, end  %#ok
                        end
                        if ~visible
                            childName = ['<HTML><i><font color="gray">' char(childName) '</font></i></html>'];  %#ok grow
                        end
                    catch
                        % never mind...
                    end
                    hasGrandChildren = any(parents==thisChildIdx);
                    try
                        isaLabel = isa(thisChildHandle.java,'javax.swing.JLabel');
                    catch
                        isaLabel = 0;
                    end
                    if hasGrandChildren && ~any(strcmp(class(thisChildHandle),{'axes'}))
                        icon = [iconpath 'foldericon.gif'];
                    elseif isaLabel
                        icon = [iconpath 'tool_text.gif'];
                    else
                        icon = [];
                    end
                    try
                        nodes(cIdx) = uitreenode('v0', thisChildHandle, childName, icon, ~hasGrandChildren);
                    catch  % old matlab version don't have the 'v0' option
                        try
                            nodes(cIdx) = uitreenode(thisChildHandle, childName, icon, ~hasGrandChildren);
                        catch
                            % probably an invalid handle - ignore...
                        end
                    end
                    % Use existing object icon, if available
                    try
                        setTreeNodeIcon(nodes(cIdx),thisChildHandle);
                    catch
                        % probably an invalid handle - ignore...
                    end
                    % Pre-select the node based upon the user's FINDJOBJ filters
                    try
                        if isJavaNode && ~userdata.userSelected && any(userdata.initialIdx == thisChildIdx)
                            pause(0.0002);  % as short as possible...
                            drawnow;
                            if isempty(tree.getSelectedNodes)
                                tree.setSelectedNode(nodes(cIdx));
                            else
                                newSelectedNodes = [tree.getSelectedNodes, nodes(cIdx).java];
                                tree.setSelectedNodes(newSelectedNodes);
                            end
                        end
                    catch
                        % never mind...
                    end
                    % Add the handler to the node's internal data
                    % Note: could also use 'userdata', but setUserObject() is recommended for TreeNodes
                    % Note2: however, setUserObject() sets a java *BeenAdapter object for HG handles instead of the required original class, so use setappdata
                    % Note3: the following will error if invalid handle - ignore
                    try
                        if isJavaNode
                            thisChildHandle = thisChildHandle.java;
                        end
                        %nodes(cIdx).setUserObject(thisChildHandle);
                        setappdata(nodes(cIdx),'childHandle',thisChildHandle);
                        nodedata.idx = thisChildIdx;
                        nodedata.obj = thisChildHandle;
                        set(nodes(cIdx),'userdata',nodedata);
                    catch
                        % never mind (probably an invalid handle) - leave unchanged (like a leaf)
                    end
                end
            end
        catch
            % Never mind - leave unchanged (like a leaf)
            %error('YMA:findjobj:UnknownNodeType', 'Error expanding component tree node');
            dispError
        end
    end
    %% Get a node's name
    function [nodeName, nodeTitle] = getNodeName(hndl,charsLimit)
        try
            % Initialize (just in case one of the succeding lines croaks)
            nodeName = '';
            nodeTitle = '';
            if ~ismethod(hndl,'getClass')
                try
                    nodeName = class(hndl);
                catch
                    nodeName = hndl.type;  % last-ditch try...
                end
            else
                nodeName = hndl.getClass.getSimpleName;
            end
            % Strip away the package name, leaving only the regular classname
            if ~isempty(nodeName) && ischar(nodeName)
                nodeName = java.lang.String(nodeName);
                nodeName = nodeName.substring(nodeName.lastIndexOf('.')+1);
            end
            if (nodeName.length == 0)
                % fix case of anonymous internal classes, that do not have SimpleNames
                try
                    nodeName = hndl.getClass.getName;
                    nodeName = nodeName.substring(nodeName.lastIndexOf('.')+1);
                catch
                    % never mind - leave unchanged...
                end
            end
            % Get any unique identifying string (if available in one of several fields)
            labelsToCheck = {'label','title','text','string','displayname','toolTipText','TooltipString','actionCommand','name','Tag','style'}; %,'UIClassID'};
            nodeTitle = '';
            strField = '';  %#ok - used for debugging
            while ((~isa(nodeTitle,'java.lang.String') && ~ischar(nodeTitle)) || isempty(nodeTitle)) && ~isempty(labelsToCheck)
                try
                    nodeTitle = get(hndl,labelsToCheck{1});
                    strField = labelsToCheck{1};  %#ok - used for debugging
                catch
                    % never mind - probably missing prop, so skip to next one
                end
                labelsToCheck(1) = [];
            end
            if length(nodeTitle) ~= numel(nodeTitle)
                % Multi-line - convert to a long single line
                nodeTitle = nodeTitle';
                nodeTitle = nodeTitle(:)';
            end
            if isempty(char(nodeTitle))
                % No title - check whether this is an HG label whose text is gettable
                try
                    location = hndl.getLocationOnScreen;
                    pos = [location.getX, location.getY, hndl.getWidth, hndl.getHeight];
                    %dist = sum((labelPositions-repmat(pos,size(labelPositions,1),[1,1,1,1])).^2, 2);
                    dist = sum((labelPositions-repmat(pos,[size(labelPositions,1),1])).^2, 2);
                    [minVal,minIdx] = min(dist);
                    % Allow max distance of 8 = 2^2+2^2 (i.e. X&Y off by up to 2 pixels, W&H exact)
                    if minVal <= 8  % 8=2^2+2^2
                        nodeTitle = get(hg_labels(minIdx),'string');
                        % Preserve the label handles & position for the tooltip & context-menu
                        %hg_labels(minIdx) = [];
                        %labelPositions(minIdx,:) = [];
                    end
                catch
                    % never mind...
                end
            end
            if nargin<2,  charsLimit = 25;  end
            extraStr = regexprep(nodeTitle,{sprintf('(.{%d,%d}).*',charsLimit,min(charsLimit,length(nodeTitle)-1)),' +'},{'$1...',' '},'once');
            if ~isempty(extraStr)
                if ischar(extraStr)
                    nodeName = nodeName.concat(' (''').concat(extraStr).concat(''')');
                else
                    nodeName = nodeName.concat(' (').concat(num2str(extraStr)).concat(')');
                end
                %nodeName = nodeName.concat(strField);
            end
        catch
            % Never mind - use whatever we have so far
            %dispError
        end
    end
    %% Strip standard Swing callbacks from a list of events
    function evNames = stripStdCbs(evNames)
        try
            stdEvents = {'AncestorAdded',  'AncestorMoved',    'AncestorRemoved', 'AncestorResized', ...
                         'ComponentAdded', 'ComponentRemoved', 'ComponentHidden', ...
                         'ComponentMoved', 'ComponentResized', 'ComponentShown', ...
                         'FocusGained',    'FocusLost',        'HierarchyChanged', ...
                         'KeyPressed',     'KeyReleased',      'KeyTyped', ...
                         'MouseClicked',   'MouseDragged',     'MouseEntered',  'MouseExited', ...
                         'MouseMoved',     'MousePressed',     'MouseReleased', 'MouseWheelMoved', ...
                         'PropertyChange', 'VetoableChange',   ...
                         'CaretPositionChanged',               'InputMethodTextChanged', ...
                         'ButtonDown',     'Create',           'Delete'};
            stdEvents = [stdEvents, strcat(stdEvents,'Callback'), strcat(stdEvents,'Fcn')];
            evNames = setdiff(evNames,stdEvents)';
        catch
            % Never mind...
            dispError
        end
    end
    %% Callback function for <Hide standard callbacks> checkbox
    function cbHideStdCbs_Callback(src, evd, callbacksTable, varargin)  %#ok
        try
            % Store the current checkbox value for later use
            if nargin < 3
                try
                    callbacksTable = get(src,'userdata');
                catch
                    callbacksTable = getappdata(src,'userdata');
                end
            end
            if evd.getSource.isSelected
                setappdata(callbacksTable,'hideStdCbs',1);
            else
                setappdata(callbacksTable,'hideStdCbs',[]);
            end
            % Rescan the current node
            try
                userdata = get(callbacksTable,'userdata');
            catch
                userdata = getappdata(callbacksTable,'userdata');
            end
            nodepath = userdata.jTree.getSelectionModel.getSelectionPath;
            try
                ed.getCurrentNode = nodepath.getLastPathComponent;
                nodeSelected(handle(userdata.jTreePeer),ed,[]);
            catch
                % ignore - probably no node selected
            end
        catch
            % Never mind...
            dispError
        end
    end
    %% Callback function for <UndocumentedMatlab.com> button
    function btWebsite_Callback(src, evd, varargin)  %#ok
        try
            web('http://UndocumentedMatlab.com','-browser');
        catch
            % Never mind...
            dispError
        end
    end
    %% Callback function for <Refresh data> button
    function btRefresh_Callback(src, evd, varargin)  %#ok
        try
            % Set cursor shape to hourglass until we're done
            hTreeFig = varargin{2};
            set(hTreeFig,'Pointer','watch');
            drawnow;
            object = varargin{1};
            % Re-invoke this utility to re-scan the container for all children
            findjobj(object);
        catch
            % Never mind...
        end
        % Restore default cursor shape
        set(hTreeFig,'Pointer','arrow');
    end
    %% Callback function for <Export> button
    function btExport_Callback(src, evd, varargin)  %#ok
        try
            % Get the list of all selected nodes
            if length(varargin) > 1
                jTree = varargin{1};
                numSelections  = jTree.getSelectionCount;
                selectionPaths = jTree.getSelectionPaths;
                hdls = handle([]);
                for idx = 1 : numSelections
                    %hdls(idx) = handle(selectionPaths(idx).getLastPathComponent.getUserObject);
                    nodedata = get(selectionPaths(idx).getLastPathComponent,'userdata');
                    try
                        hdls(idx) = handle(nodedata.obj,'CallbackProperties');
                    catch
                        if idx==1  % probably due to HG2: can't convert object to handle([])
                            hdls = nodedata.obj;
                        else
                            hdls(idx) = nodedata.obj;
                        end
                    end
                end
                % Assign the handles in the base workspace & inform user
                assignin('base','findjobj_hdls',hdls);
                classNameLabel = varargin{2};
                msg = ['Exported ' char(classNameLabel.getText.trim) ' to base workspace variable findjobj_hdls'];
            else
                % Right-click (context-menu) callback
                data = varargin{1};
                obj = data{1};
                varName = data{2};
                if isempty(varName)
                    varName = inputdlg('Enter workspace variable name','FindJObj');
                    if isempty(varName),  return;  end  % bail out on <Cancel>
                    varName = varName{1};
                    if isempty(varName) || ~ischar(varName),  return;  end  % bail out on empty/null
                    varName = genvarname(varName);
                end
                assignin('base',varName,handle(obj,'CallbackProperties'));
                msg = ['Exported object to base workspace variable ' varName];
            end
            msgbox(msg,'FindJObj','help');
        catch
            % Never mind...
            dispError
        end
    end
    %% Callback function for <Request focus> button
    function btFocus_Callback(src, evd, varargin)  %#ok
        try
            % Request focus for the specified object
            object = getTopSelectedObject(varargin{:});
            object.requestFocus;
        catch
            try
                object = object.java.getPeer.requestFocus;
                object.requestFocus;
            catch
                % Never mind...
                %dispError
            end
        end
    end
    %% Callback function for <Inspect> button
    function btInspect_Callback(src, evd, varargin)  %#ok
        try
            % Inspect the specified object
            if length(varargin) == 1
                object = varargin{1};
            else
                object = getTopSelectedObject(varargin{:});
            end
            if isempty(which('uiinspect'))
                % If the user has not indicated NOT to be informed about UIInspect
                if ~ispref('FindJObj','dontCheckUIInspect')
                    % Ask the user whether to download UIINSPECT (YES, no, no & don't ask again)
                    answer = questdlg({'The object inspector requires UIINSPECT from the MathWorks File Exchange. UIINSPECT was created by Yair Altman, like this FindJObj utility.','','Download & install UIINSPECT?'},'UIInspect','Yes','No','No & never ask again','Yes');
                    switch answer
                        case 'Yes'  % => Yes: download & install
                            try
                                % Download UIINSPECT
                                baseUrl = 'http://www.mathworks.com/matlabcentral/fileexchange/17935';
                                fileUrl = [baseUrl '?controller=file_infos&download=true'];
                                %file = urlread(fileUrl);
                                %file = regexprep(file,[char(13),char(10)],'\n');  %convert to OS-dependent EOL
                                % Install...
                                %newPath = fullfile(fileparts(which(mfilename)),'uiinspect.m');
                                %fid = fopen(newPath,'wt');
                                %fprintf(fid,'%s',file);
                                %fclose(fid);
                                [fpath,fname,fext] = fileparts(which(mfilename));
                                zipFileName = fullfile(fpath,'uiinspect.zip');
                                urlwrite(fileUrl,zipFileName);
                                unzip(zipFileName,fpath);
                                rehash;
                            catch
                                % Error downloading: inform the user
                                msgbox(['Error in downloading: ' lasterr], 'UIInspect', 'warn');  %#ok
                                web(baseUrl);
                            end
                            % ...and now run it...
                            %pause(0.1); 
                            drawnow;
                            dummy = which('uiinspect');  %#ok used only to load into memory
                            uiinspect(object);
                            return;
                        case 'No & never ask again'   % => No & don't ask again
                            setpref('FindJObj','dontCheckUIInspect',1);
                        otherwise
                            % forget it...
                    end
                end
                drawnow;
                % No UIINSPECT available - run the good-ol' METHODSVIEW()...
                methodsview(object);
            else
                uiinspect(object);
            end
        catch
            try
                if isjava(object)
                    methodsview(object)
                else
                    methodsview(object.java);
                end
            catch
                % Never mind...
                dispError
            end
        end
    end
    %% Callback function for <Check for updates> button
    function btCheckFex_Callback(src, evd, varargin)  %#ok
        try
            % Check the FileExchange for the latest version
            web('http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14317');
        catch
            % Never mind...
            dispError
        end
    end
    %% Check for existence of a newer version
    function checkVersion()
        try
            % If the user has not indicated NOT to be informed
            if ~ispref('FindJObj','dontCheckNewerVersion')
                % Get the latest version date from the File Exchange webpage
                baseUrl = 'http://www.mathworks.com/matlabcentral/fileexchange/';
                webUrl = [baseUrl '14317'];  % 'loadFile.do?objectId=14317'];
                webPage = urlread(webUrl);
                modIdx = strfind(webPage,'>Updates<');
                if ~isempty(modIdx)
                    webPage = webPage(modIdx:end);
                    % Note: regexp hangs if substr not found, so use strfind instead...
                    %latestWebVersion = regexprep(webPage,'.*?>(20[\d-]+)</td>.*','$1');
                    dateIdx = strfind(webPage,'class="date">');
                    if ~isempty(dateIdx)
                        latestDate = webPage(dateIdx(end)+13 : dateIdx(end)+23);
                        try
                            startIdx = dateIdx(end)+27;
                            descStartIdx = startIdx + strfind(webPage(startIdx:startIdx+999),'<td>');
                            descEndIdx   = startIdx + strfind(webPage(startIdx:startIdx+999),'</td>');
                            descStr = webPage(descStartIdx(1)+3 : descEndIdx(1)-2);
                            descStr = regexprep(descStr,'</?[pP]>','');
                        catch
                            descStr = '';
                        end
                        % Get this file's latest date
                        thisFileName = which(mfilename);  %#ok
                        try
                            thisFileData = dir(thisFileName);
                            try
                                thisFileDatenum = thisFileData.datenum;
                            catch  % old ML versions...
                                thisFileDatenum = datenum(thisFileData.date);
                            end
                        catch
                            thisFileText = evalc('type(thisFileName)');
                            thisFileLatestDate = regexprep(thisFileText,'.*Change log:[\s%]+([\d-]+).*','$1');
                            thisFileDatenum = datenum(thisFileLatestDate,'yyyy-mm-dd');
                        end
                        % If there's a newer version on the File Exchange webpage (allow 2 days grace period)
                        if (thisFileDatenum < datenum(latestDate,'dd mmm yyyy')-2)
                            % Ask the user whether to download the newer version (YES, no, no & don't ask again)
                            msg = {['A newer version (' latestDate ') of FindJObj is available on the MathWorks File Exchange:'], '', ...
                                   ['\color{blue}' descStr '\color{black}'], '', ...
                                   'Download & install the new version?'};
                            createStruct.Interpreter = 'tex';
                            createStruct.Default = 'Yes';
                            answer = questdlg(msg,'FindJObj','Yes','No','No & never ask again',createStruct);
                            switch answer
                                case 'Yes'  % => Yes: download & install newer file
                                    try
                                        %fileUrl = [baseUrl '/download.do?objectId=14317&fn=findjobj&fe=.m'];
                                        fileUrl = [baseUrl '/14317?controller=file_infos&download=true'];
                                        %file = urlread(fileUrl);
                                        %file = regexprep(file,[char(13),char(10)],'\n');  %convert to OS-dependent EOL
                                        %fid = fopen(thisFileName,'wt');
                                        %fprintf(fid,'%s',file);
                                        %fclose(fid);
                                        [fpath,fname,fext] = fileparts(thisFileName);
                                        zipFileName = fullfile(fpath,[fname '.zip']);
                                        urlwrite(fileUrl,zipFileName);
                                        unzip(zipFileName,fpath);
                                        rehash;
                                    catch
                                        % Error downloading: inform the user
                                        msgbox(['Error in downloading: ' lasterr], 'FindJObj', 'warn');  %#ok
                                        web(webUrl);
                                    end
                                case 'No & never ask again'   % => No & don't ask again
                                    setpref('FindJObj','dontCheckNewerVersion',1);
                                otherwise
                                    % forget it...
                            end
                        end
                    end
                else
                    % Maybe webpage not fully loaded or changed format - bail out...
                end
            end
        catch
            % Never mind...
        end
    end
    %% Get the first selected object (might not be the top one - depends on selection order)
    function object = getTopSelectedObject(jTree, root)
        try
            object = [];
            numSelections  = jTree.getSelectionCount;
            if numSelections > 0
                % Get the first object specified
                %object = jTree.getSelectionPath.getLastPathComponent.getUserObject;
                nodedata = get(jTree.getSelectionPath.getLastPathComponent,'userdata');
            else
                % Get the root object (container)
                %object = root.getUserObject;
                nodedata = get(root,'userdata');
            end
            object = nodedata.obj;
        catch
            % Never mind...
            dispError
        end
    end
    %% Update component callback upon callbacksTable data change
    function tbCallbacksChanged(src, evd, object, table)
        persistent hash
        try
            % exit if invalid handle or already in Callback
            %if ~ishandle(src) || ~isempty(getappdata(src,'inCallback')) % || length(dbstack)>1  %exit also if not called from user action
            if isempty(hash), hash = java.util.Hashtable;  end
            if ~ishandle(src) || ~isempty(hash.get(src)) % || length(dbstack)>1  %exit also if not called from user action
                return;
            end
            %setappdata(src,'inCallback',1);  % used to prevent endless recursion   % can't use getappdata(src,...) because it fails on R2010b!!!
            hash.put(src,1);
            % Update the object's callback with the modified value
            modifiedColIdx = evd.getColumn;
            modifiedRowIdx = evd.getFirstRow;
            if modifiedRowIdx>=0 %&& modifiedColIdx==1  %sanity check - should always be true
                %table = evd.getSource;
                %object = get(src,'userdata');
                modifiedRowIdx = table.getSelectedRow;  % overcome issues with hierarchical table
                cbName = strtrim(table.getValueAt(modifiedRowIdx,0));
                try
                    cbValue = strtrim(char(table.getValueAt(modifiedRowIdx,1)));
                    if ~isempty(cbValue) && ismember(cbValue(1),'{[@''')
                        cbValue = eval(cbValue);
                    end
                    if (~ischar(cbValue) && ~isa(cbValue, 'function_handle') && (~iscell(cbValue) || iscom(object(1))))
                        revertCbTableModification(table, modifiedRowIdx, modifiedColIdx, cbName, object, '');
                    else
                        for objIdx = 1 : length(object)
                            obj = object(objIdx);
                            if ~iscom(obj)
                                try
                                    try
                                        if isjava(obj)
                                            obj = handle(obj,'CallbackProperties');
                                        end
                                    catch
                                        % never mind...
                                    end
                                    set(obj, cbName, cbValue);
                                catch
                                    try
                                        set(handle(obj,'CallbackProperties'), cbName, cbValue);
                                    catch
                                        % never mind - probably a callback-group header
                                    end
                                end
                            else
                                cbs = obj.eventlisteners;
                                if ~isempty(cbs)
                                    cbs = cbs(strcmpi(cbs(:,1),cbName),:);
                                    obj.unregisterevent(cbs);
                                end
                                if ~isempty(cbValue) && ~strcmp(cbName,'-')
                                    obj.registerevent({cbName, cbValue});
                                end
                            end
                        end
                    end
                catch
                    revertCbTableModification(table, modifiedRowIdx, modifiedColIdx, cbName, object, lasterr)  %#ok
                end
            end
        catch
            % never mind...
        end
        %setappdata(src,'inCallback',[]);  % used to prevent endless recursion   % can't use setappdata(src,...) because it fails on R2010b!!!
        hash.remove(src);
    end
    %% Revert Callback table modification
    function revertCbTableModification(table, modifiedRowIdx, modifiedColIdx, cbName, object, errMsg)  %#ok
        try
            % Display a notification MsgBox
            msg = 'Callbacks must be a ''string'', or a @function handle';
            if ~iscom(object(1)),  msg = [msg ' or a {@func,args...} construct'];  end
            if ~isempty(errMsg),  msg = {errMsg, '', msg};  end
            msgbox(msg, ['Error setting ' cbName ' value'], 'warn');
            % Revert to the current value
            curValue = '';
            try
                if ~iscom(object(1))
                    curValue = charizeData(get(object(1),cbName));
                else
                    cbs = object(1).eventlisteners;
                    if ~isempty(cbs)
                        cbs = cbs(strcmpi(cbs(:,1),cbName),:);
                        curValue = charizeData(cbs(1,2));
                    end
                end
            catch
                % never mind... - clear the current value
            end
            table.setValueAt(curValue, modifiedRowIdx, modifiedColIdx);
        catch
            % never mind...
        end
    end  % revertCbTableModification
    %% Get the Java positions of all HG text labels
    function labelPositions = getLabelsJavaPos(container)
        try
            labelPositions = [];
            % Ensure we have a figure handle
            try
                h = hFig;  %#ok unused
            catch
                hFig = getCurrentFigure;
            end
            % Get the figure's margins from the Matlab properties
            hg_labels = findall(hFig, 'Style','text');
            units = get(hFig,'units');
            set(hFig,'units','pixels');
            outerPos = get(hFig,'OuterPosition');
            innerPos = get(hFig,'Position');
            set(hFig,'units',units);
            margins = abs(innerPos-outerPos);
            figX = container.getX;        % =outerPos(1)
            figY = container.getY;        % =outerPos(2)
            %figW = container.getWidth;   % =outerPos(3)
            figH = container.getHeight;   % =outerPos(4)
            % Get the relevant screen pixel size
            %monitorPositions = get(0,'MonitorPositions');
            %for monitorIdx = size(monitorPositions,1) : -1 : 1
            %    screenSize = monitorPositions(monitorIdx,:);
            %    if (outerPos(1) >= screenSize(1)) % && (outerPos(1)+outerPos(3) <= screenSize(3))
            %        break;
            %    end
            %end
            %monitorBaseY = screenSize(4) - monitorPositions(1,4);
            % Compute the labels' screen pixel position in Java units ([0,0] = top left)
            for idx = 1 : length(hg_labels)
                matlabPos = getpixelposition(hg_labels(idx),1);
                javaX = figX + matlabPos(1) + margins(1);
                javaY = figY + figH - matlabPos(2) - matlabPos(4) - margins(2);
                labelPositions(idx,:) = [javaX, javaY, matlabPos(3:4)];  %#ok grow
            end
        catch
            % never mind...
            err = lasterror;  %#ok debug point
        end
    end
    %% Traverse an HG container hierarchy and extract the HG elements within
    function traverseHGContainer(hcontainer,level,parent)
        try
            % Record the data for this node
            thisIdx = length(hg_levels) + 1;
            hg_levels(thisIdx) = level;
            hg_parentIdx(thisIdx) = parent;
            try
                hg_handles(thisIdx) = handle(hcontainer);
            catch
                hg_handles = handle(hcontainer);
            end
            parentId = length(hg_parentIdx);
            % Now recursively process all this node's children (if any)
            %if ishghandle(hcontainer)
            try  % try-catch is faster than checking ishghandle(hcontainer)...
                allChildren = allchild(handle(hcontainer));
                for childIdx = 1 : length(allChildren)
                    traverseHGContainer(allChildren(childIdx),level+1,parentId);
                end
            catch
                % do nothing - probably not a container
                %dispError
            end
            % TODO: Add axis (plot) component handles
        catch
            % forget it...
        end
    end
    %% Debuggable "quiet" error-handling
    function dispError
        err = lasterror;  %#ok
        msg = err.message;
        for idx = 1 : length(err.stack)
            filename = err.stack(idx).file;
            if ~isempty(regexpi(filename,mfilename))
                funcname = err.stack(idx).name;
                line = num2str(err.stack(idx).line);
                msg = [msg ' at <a href="matlab:opentoline(''' filename ''',' line ');">' funcname ' line #' line '</a>']; %#ok grow
                break;
            end
        end
        disp(msg);
        return;  % debug point
    end
    %% ML 7.0 - compatible ischar() function
    function flag = ischar(data)
        try
            flag = builtin('ischar',data);
        catch
            flag = isa(data,'char');
        end
    end
    %% Set up the uitree context (right-click) menu
    function jmenu = setTreeContextMenu(obj,node,tree_h)
          % Prepare the context menu (note the use of HTML labels)
          import javax.swing.*
          titleStr = getNodeTitleStr(obj,node);
          titleStr = regexprep(titleStr,'<hr>.*','');
          menuItem0 = JMenuItem(titleStr);
          menuItem0.setEnabled(false);
          menuItem0.setArmed(false);
          %menuItem1 = JMenuItem('Export handle to findjobj_hdls');
          if isjava(obj), prefix = 'j';  else,  prefix = 'h';  end  %#ok<NOCOM>
          varname = strrep([prefix strtok(char(node.getName))], '$','_');
          varname = genvarname(varname);
          varname(2) = upper(varname(2));  % ensure lowerCamelCase
          menuItem1 = JMenuItem(['Export handle to ' varname]);
          menuItem2 = JMenuItem('Export handle to...');
          menuItem3 = JMenuItem('Request focus (bring to front)');
          menuItem4 = JMenuItem('Flash component borders');
          menuItem5 = JMenuItem('Display properties & callbacks');
          menuItem6 = JMenuItem('Inspect object');
          % Set the menu items' callbacks
          set(handle(menuItem1,'CallbackProperties'), 'ActionPerformedCallback', {@btExport_Callback,{obj,varname}});
          set(handle(menuItem2,'CallbackProperties'), 'ActionPerformedCallback', {@btExport_Callback,{obj,[]}});
          set(handle(menuItem3,'CallbackProperties'), 'ActionPerformedCallback', {@requestFocus,obj});
          set(handle(menuItem4,'CallbackProperties'), 'ActionPerformedCallback', {@flashComponent,{obj,0.2,3}});
          set(handle(menuItem5,'CallbackProperties'), 'ActionPerformedCallback', {@nodeSelected,{tree_h,node}});
          set(handle(menuItem6,'CallbackProperties'), 'ActionPerformedCallback', {@btInspect_Callback,obj});
          % Add all menu items to the context menu (with internal separator)
          jmenu = JPopupMenu;
          jmenu.add(menuItem0);
          jmenu.addSeparator;
          handleValue=[];  try handleValue = double(obj); catch, end;  %#ok
          if ~isempty(handleValue)
              % For valid HG handles only
              menuItem0a = JMenuItem('Copy handle value to clipboard');
              set(handle(menuItem0a,'CallbackProperties'), 'ActionPerformedCallback', sprintf('clipboard(''copy'',%.99g)',handleValue));
              jmenu.add(menuItem0a);
          end
          jmenu.add(menuItem1);
          jmenu.add(menuItem2);
          jmenu.addSeparator;
          jmenu.add(menuItem3);
          jmenu.add(menuItem4);
          jmenu.add(menuItem5);
          jmenu.add(menuItem6);
    end  % setTreeContextMenu
    %% Set the mouse-press callback
    function treeMousePressedCallback(hTree, eventData, tree_h)  %#ok hTree is unused
        if eventData.isMetaDown  % right-click is like a Meta-button
            % Get the clicked node
            clickX = eventData.getX;
            clickY = eventData.getY;
            jtree = eventData.getSource;
            treePath = jtree.getPathForLocation(clickX, clickY);
            try
                % Modify the context menu based on the clicked node
                node = treePath.getLastPathComponent;
                userdata = get(node,'userdata');
                obj = userdata.obj;
                jmenu = setTreeContextMenu(obj,node,tree_h);
                % TODO: remember to call jmenu.remove(item) in item callback
                % or use the timer hack shown here to remove the item:
                %    timerFcn = {@menuRemoveItem,jmenu,item};
                %    start(timer('TimerFcn',timerFcn,'StartDelay',0.2));
                % Display the (possibly-modified) context menu
                jmenu.show(jtree, clickX, clickY);
                jmenu.repaint;
                % This is for debugging:
                userdata.tree = jtree;
                setappdata(gcf,'findjobj_hgtree',userdata)
            catch
                % clicked location is NOT on top of any node
                % Note: can also be tested by isempty(treePath)
            end
        end
    end  % treeMousePressedCallback
    %% Remove the extra context menu item after display
    function menuRemoveItem(hObj,eventData,jmenu,item) %#ok unused
        jmenu.remove(item);
    end  % menuRemoveItem
    %% Get the title for the tooltip and context (right-click) menu
    function nodeTitleStr = getNodeTitleStr(obj,node)
        try
            % Display the full classname and object name in the tooltip
            %nodeName = char(node.getName);
            %nodeName = strrep(nodeName, '<HTML><i><font color="gray">','');
            %nodeName = strrep(nodeName, '</font></i></html>','');
            nodeName = char(getNodeName(obj,99));
            [objClass,objName] = strtok(nodeName);
            objName = objName(3:end-1);  % strip leading ( and trailing )
            if isempty(objName),  objName = '(none found)';  end
            nodeName = char(node.getName);
            objClass = char(obj.getClass.getName);
            nodeTitleStr = sprintf('<html>Class name: <font color="blue">%s</font><br>Text/title: %s',objClass,objName);
            % If the component is invisible, state this in the tooltip
            if ~isempty(strfind(nodeName,'color="gray"'))
                nodeTitleStr = [nodeTitleStr '<br><font color="gray"><i><b>*** Invisible ***</b></i></font>'];
            end
            nodeTitleStr = [nodeTitleStr '<hr>Right-click for context-menu'];
        catch
            % Possible not a Java object - try treating as an HG handle
            try
                handleValueStr = sprintf('#: <font color="blue"><b>%.99g<b></font>',double(obj));
                try
                    type = '';
                    type = get(obj,'type');
                    type(1) = upper(type(1));
                catch
                    if ~ishandle(obj)
                        type = ['<font color="red"><b>Invalid <i>' char(node.getName) '</i>'];
                        handleValueStr = '!!!</b></font><br>Perhaps this handle was deleted after this UIInspect tree was<br>already drawn. Try to refresh by selecting any valid node handle';
                    end
                end
                nodeTitleStr = sprintf('<html>%s handle %s',type,handleValueStr);
                try
                    % If the component is invisible, state this in the tooltip
                    if strcmp(get(obj,'Visible'),'off')
                        nodeTitleStr = [nodeTitleStr '<br><center><font color="gray"><i>Invisible</i></font>'];
                    end
                catch
                    % never mind...
                end
            catch
                % never mind... - ignore
            end
        end
    end  % getNodeTitleStr
    %% Handle tree mouse movement callback - used to set the tooltip & context-menu
    function treeMouseMovedCallback(hTree, eventData)
          try
              x = eventData.getX;
              y = eventData.getY;
              jtree = eventData.getSource;
              treePath = jtree.getPathForLocation(x, y);
              try
                  % Set the tooltip string based on the hovered node
                  node = treePath.getLastPathComponent;
                  userdata = get(node,'userdata');
                  obj = userdata.obj;
                  tooltipStr = getNodeTitleStr(obj,node);
                  set(hTree,'ToolTipText',tooltipStr)
              catch
                  % clicked location is NOT on top of any node
                  % Note: can also be tested by isempty(treePath)
              end
          catch
              dispError;
          end
          return;  % denug breakpoint
    end  % treeMouseMovedCallback
    %% Request focus for a specific object handle
    function requestFocus(hTree, eventData, obj)  %#ok hTree & eventData are unused
        % Ensure the object handle is valid
        if isjava(obj)
            obj.requestFocus;
            return;
        elseif ~ishandle(obj)
            msgbox('The selected object does not appear to be a valid handle as defined by the ishandle() function. Perhaps this object was deleted after this hierarchy tree was already drawn. Refresh this tree by selecting a valid node handle and then retry.','FindJObj','warn');
            beep;
            return;
        end
        try
            foundFlag = 0;
            while ~foundFlag
                if isempty(obj),  return;  end  % sanity check
                type = get(obj,'type');
                obj = double(obj);
                foundFlag = any(strcmp(type,{'figure','axes','uicontrol'}));
                if ~foundFlag
                    obj = get(obj,'Parent');
                end
            end
            feval(type,obj);
        catch
            % never mind...
            dispError;
        end
    end  % requestFocus
end  % FINDJOBJ
% Fast implementation
function jControl = findjobj_fast(hControl, jContainer)
    try jControl = hControl.Table; return, catch, end  % fast bail-out for old uitables
    try jControl = hControl.JavaFrame.getGUIDEView; return, catch, end  % bail-out for HG2 matlab.ui.container.Panel
    oldWarn = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    if nargin < 2 || isempty(jContainer)
        % Use a HG2 matlab.ui.container.Panel jContainer if the control's parent is a uipanel
        try
            hParent = get(hControl,'Parent');
        catch
            % Probably indicates an invalid/deleted/empty handle
            jControl = [];
            return
        end
        try jContainer = hParent.JavaFrame.getGUIDEView; catch, jContainer = []; end
    end
    if isempty(jContainer)
        hFig = ancestor(hControl,'figure');
        jf = get(hFig, 'JavaFrame');
        jContainer = jf.getFigurePanelContainer.getComponent(0);
    end
    warning(oldWarn);
    jControl = [];
    counter = 20;  % 2018-09-21 speedup (100 x 0.001 => 20 x 0.005) - Martin Lehmann suggestion on FEX 2016-06-07
    specialTooltipStr = '!@#$%^&*';
    try  % Fix for R2018b suggested by Eddie (FEX comment 2018-09-19)
        tooltipPropName = 'TooltipString';
        oldTooltip = get(hControl,tooltipPropName);
        set(hControl,tooltipPropName,specialTooltipStr);
    catch
        tooltipPropName = 'Tooltip';
        oldTooltip = get(hControl,tooltipPropName);
        set(hControl,tooltipPropName,specialTooltipStr);
    end
    while isempty(jControl) && counter>0
        counter = counter - 1;
        pause(0.005);
        jControl = findTooltipIn(jContainer, specialTooltipStr);
    end
    set(hControl,tooltipPropName,oldTooltip);
    try jControl.setToolTipText(oldTooltip); catch, end
    try jControl = jControl.getParent.getView.getParent.getParent; catch, end  % return JScrollPane if exists
end
function jControl = findTooltipIn(jContainer, specialTooltipStr)
    try
        jControl = [];  % Fix suggested by H. Koch 11/4/2017
        tooltipStr = jContainer.getToolTipText;
        %if strcmp(char(tooltipStr),specialTooltipStr)
        if ~isempty(tooltipStr) && tooltipStr.startsWith(specialTooltipStr)  % a bit faster
            jControl = jContainer;
        else
            for idx = 1 : jContainer.getComponentCount
                jControl = findTooltipIn(jContainer.getComponent(idx-1), specialTooltipStr);
                if ~isempty(jControl), return; end
            end
        end
    catch
        % ignore
    end
end