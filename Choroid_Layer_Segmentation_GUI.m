
function varargout = Choroid_Layer_Segmentation_GUI(varargin)
%      Choroid_Layer_Segmentation_GUI M-file for Choroid_Layer_Segmentation_GUI.fig
%      Choroid_Layer_Segmentation_GUI, by itself, creates a new Choroid_Layer_Segmentation_GUI or raises the existing
%      singleton*.
%
%      H = Choroid_Layer_Segmentation_GUI returns the handle to a new Choroid_Layer_Segmentation_GUI or the handle to
%      the existing singleton*.
%
%      Choroid_Layer_Segmentation_GUI('Property','Value',...) creates a new Choroid_Layer_Segmentation_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Choroid_Layer_Segmentation_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      Choroid_Layer_Segmentation_GUI('CALLBACK') and Choroid_Layer_Segmentation_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in Choroid_Layer_Segmentation_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Choroid_Layer_Segmentation_GUI

% Last Modified by GUIDE v2.5 04-May-2024 09:53:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Choroid_Layer_Segmentation_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Choroid_Layer_Segmentation_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Choroid_Layer_Segmentation_GUI is made visible.
function Choroid_Layer_Segmentation_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Choroid_Layer_Segmentation_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Choroid_Layer_Segmentation_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Choroid_Layer_Segmentation_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Select_ImgFile.
function Select_ImgFile_Callback(hObject, eventdata, handles)
% P841526027_Angio (12mmx12mm)_12-26-2023_11-13-1_OD_sn2446_cube_z
[fileNames0,filePath0,~] = uigetfile('../../Data/*Angio*_cube_z*.img');  %%%%%%%%%%%%%  Angio*_cube_*
% fileNames0 = handles.fileNames0;
% filePath0 = handles.filePath0;
fileNames = strrep(fileNames0,' ','_');
filePath = strrep(filePath0,' ','_');
srcPath = strcat(filePath0,fileNames0);
modPath = strcat(filePath,fileNames);
if ~strcmp(filePath,filePath0)
    mkdir(filePath);
end
if ~strcmp(srcPath,modPath)
    movefile(srcPath,modPath);
end
fn = fileNames(1:end-4);
mainFolder = strcat(filePath,fn);
clear imgs;
orgPath = strcat(mainFolder,'/Org/');mkdir(orgPath);
imgs = ImagesExtraction(filePath,fileNames,orgPath);
ptrn = OrgPtrn(orgPath);
handles.ptrn = ptrn;
handles.mainFolder = mainFolder;
handles.orgPath = orgPath;
handles.imgTy = 'IMG';
handles.imgs = imgs;
handles.fn = fn;
guidata(hObject,handles);
% --- Executes on button press in SelectJPGFile.
function SelectJPGFile_Callback(hObject, eventdata, handles)
% hObject    handle to SelectJPGFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
orgPath = strcat(uigetdir('../../Data/'),'\');
% [~,orgPath,~] = uigetfile('MultiSelect','on','E:\Razeen\Data\*.jpg');
clear imgs;
imgs = imRDImgs(orgPath);
ptrn = OrgPtrn(orgPath);
handles.ptrn = ptrn;
handles.orgPath = orgPath;
handles.imgTy = 'JPG';
handles.imgs = imgs;
str0 = split(orgPath,'\');
mainFolder = cell2mat(join(str0(1:end-2),'\'));
fn = cell2mat(str0(end-2));
handles.fn = fn;
handles.mainFolder = mainFolder;
guidata(hObject,handles);


% --- Executes on button press in PerformChBndSegmentation.
function PerformChBndSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to PerformChBndSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ty = handles.ty;
% imgTy = handles.imgTy;
% h5Path = 'C:/Users/ee12p/OneDrive/ResUNet/ChBndrySeg_Razeen_UPMC_12x12/21Jan2024/';
h5Path = 'C:/Users/ee12p/OneDrive/Documents/ResUNet/Models/';
% ptrn = handles.ptrn;
orgPath = handles.orgPath;
mainFolder = handles.mainFolder;
fn = handles.fn;
imgs = handles.imgs;
if strcmp(ty,'single')
%     rnos = {'89'};
%     analPath = strcat(mainFolder,'\Analysis_1M_',rnos,'\');
    rnos = 89;
    analPath = strcat(mainFolder,'\Analysis\ChBndrySeg_1M_',int2str(rnos),'\');
elseif strcmp(ty,'multi')
    rnos = [50,58,65,70,77, 85,90];
    % rnos = [50,70,90];
    str3 = [];
    for indx = 1:length(rnos)
        if indx < length(rnos)
            str3 = [str3 strcat(int2str(rnos(indx)),'_')];
        else
            str3 = [str3 strcat(int2str(rnos(indx)))];
        end
    end
    analPath = strcat(mainFolder,'\Analysis\ChBndrySeg_MM_',str3,'\');
end
maskPath = strcat(analPath,'ChMask\');mkdir(maskPath);
orgCibCobOvpath3 = strcat(analPath,'CibCob3Dsm\');mkdir(orgCibCobOvpath3);
matFileDir = strcat(analPath,'MatFile\');mkdir(matFileDir);
% rnos_py = py.numpy.array(rnos);
cmd = cell2mat(strcat('python ResUNet2_Mask.py',{' '},orgPath,{' '},h5Path,{' '},maskPath,{' '},ty));
% cmd = cell2mat(strcat('python C:/Users/ee12p/OneDrive/Documents/MATLAB/ResUNet2_Mask.py',{' '},orgPath,{' '},h5Path,{' '},maskPath,{' '},ptrn,{' '},ty,{' '},rnos_py));
system(cmd);
if strcmp(ty,'single')
    1111
    model_lst = dir(strcat(maskPath,'*_IP'));
    mPath = strcat(maskPath,model_lst(1).name,'\');
elseif strcmp(ty,'multi')
    222
    mPath = CibCob_Agg_10M(maskPath);         
end
mlst = dir(strcat(mPath,'*.jpg'));
[cib_2Dsm, cob_2Dsm, cib_3Dsm, cob_3Dsm] = CibCobOverlay_Org_basedon_Mask(mPath);
prnt_cib_cob_overlay_org(imgs,cib_3Dsm,cob_3Dsm,orgCibCobOvpath3,mlst);
enf_img = enfImg1(cib_2Dsm,imgs);
RPE_EnfImg = flipud(enf_img');
% axes(handles.axes4) 
% imshow(RPE_EnfImg,'InitialMagnification','fit');
% title(handles.fn, 'Interpreter', 'none')
save(strcat(matFileDir,fn,'.mat'),"cib_2Dsm","cob_2Dsm","cib_3Dsm","cob_3Dsm","RPE_EnfImg");
winopen(mainFolder)
handles.matFileDir = matFileDir;
% handles.fn = fn;
handles.RPE_EnfImg = RPE_EnfImg;   
handles.orgCibCobOvpath3 = orgCibCobOvpath3;
handles.mainFolder = mainFolder;
handles.cib_3Dsm = cib_3Dsm;
handles.cob_3Dsm = cob_3Dsm;
handles.analPath = analPath;
% handles.mask = mask;
guidata(hObject,handles);
% % % function range_Callback(hObject, eventdata, handles)
% % % % hObject    handle to rpt_corr_scan_range (see GCBO)
% % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % handles    structure with handles and user data (see GUIDATA)
% % % 
% % % % Hints: get(hObject,'String') returns contents of rpt_corr_scan_range as text
% % % %        str2double(get(hObject,'String')) returns contents of rpt_corr_scan_range as a double

% --- Executes on button press in ShowOutputFolder.
function ShowOutputFolder_Callback(hObject, eventdata, handles)
% hObject    handle to ShowOutputFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainFolder = handles.mainFolder;
winopen(mainFolder)

% --- Executes on button press in ShowChSegmentations.
function ShowChSegmentations_Callback(hObject, eventdata, handles)
% hObject    handle to ShowChSegmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(handles.orgCibCobOvpath3);

% --- Executes on button press in showRPE_EnfImage.
function showRPE_EnfImage_Callback(hObject, eventdata, handles)
% hObject    handle to showRPE_EnfImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clear(figure(1))
figure (1);
imshow(handles.RPE_EnfImg,'InitialMagnification','fit');
title(handles.fn, 'Interpreter', 'none')


% --- Executes on button press in SingleModel.
function SingleModel_Callback(hObject, eventdata, handles)
% hObject    handle to SingleModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SingleModel
status = get(handles.SingleModel,'Value');
ty = 'single';
if status == 1
    handles.ty = ty;
end
guidata(hObject,handles)

% --- Executes on button press in MultiModel.
function MultiModel_Callback(hObject, eventdata, handles)
% hObject    handle to MultiModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MultiModel
status = get(handles.MultiModel,'Value');
ty = 'multi';
if status == 1
    handles.ty = ty;
end
guidata(hObject,handles)


% --- Executes on button press in ShowOCTVolume.
function ShowOCTVolume_Callback(hObject, eventdata, handles)
% hObject    handle to ShowOCTVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% imgs = handles.imgs;
volshow(handles.imgs);
% title(handles.fn, 'Interpreter', 'none');



% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes on button press in SelectImagesForBndryCorrectionsMan_CIB.
function SelectImagesForBndryCorrectionsMan_CIB_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImagesForBndryCorrectionsMan_CIB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mFd = handles.mainFolder;
cib = handles.cib_3Dsm;
imgs = handles.imgs;
SelImgs = get(handles.SelectImages,'String');
str00 = split(SelImgs,';');
for i = 1:length(str00)
    str0 = split(str00{i},',');
    clear snos;
    for j = 1:length(str0)
        snos(j) = str2double(cell2mat(str0(j)));
    end
    [cib1, oPath] = multiple_image_correction_snos1_CIB(snos,mFd,imgs,cib);
    cib = cib1;
end      
handles.cib_3Dsm = cib;
winopen(oPath);

guidata(hObject,handles)

function SelectImagesForBndryCorrectionsMan_COB_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImagesForBndryCorrectionsMan_COB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mFd = handles.mainFolder;
cob = handles.cob_3Dsm;
imgs = handles.imgs;
SelImgs = get(handles.SelectImages,'String');
str00 = split(SelImgs,';');
for i = 1:length(str00)
    str0 = split(str00{i},',');
    clear snos;
    for j = 1:length(str0)
        snos(j) = str2double(cell2mat(str0(j)));
    end
    [cob1, oPath] = multiple_image_correction_snos1_COB(snos,mFd,imgs,cob);
    cob = cob1;
end      
handles.cob_3Dsm = cob;
winopen(oPath);
guidata(hObject,handles)

function SelectImagesForBndryCorrectionsMan_CIB_COB_Callback(hObject, eventdata, handles)
mFd = handles.mainFolder;
cib = handles.cib_3Dsm;
cob = handles.cob_3Dsm;
imgs = handles.imgs;
SelImgs = get(handles.SelectImages,'String');
str00 = split(SelImgs,';');
clear snos;
for i = 1:length(str00)
    str0 = split(str00{i},',');
    clear snos;
    for j = 1:length(str0)
        snos(j) = str2double(cell2mat(str0(j)));
    end
    [cib1, cob1, oPath] = multiple_image_correction_snos1(snos,mFd,imgs,cib,cob);
    cib = cib1;
    cob = cob1;
end      
handles.cib_3Dsm = cib;
handles.cob_3Dsm = cob;
winopen(oPath);

guidata(hObject,handles)



function SelectImages_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SelectImages as text
%        str2double(get(hObject,'String')) returns contents of SelectImages as a double


% --- Executes during object creation, after setting all properties.
function SelectImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadSavedVolumes.
function LoadSavedVolumes_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSavedVolumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% E:\Razeen\Data\zzzBkp\Smizik\P841299357_Angio_(12mmx12mm)_5-12-2023_11-18-23_OD_sn0044_cube_z\Analysis_MM_50_70_90\MatFile
[matFileName,matFileDir,~] = uigetfile('E:\Razeen\Data\*.mat');  %%%%%%%%%%%%%  Angio*_cube_*
% orgPath = strcat(uigetdir('E:\Razeen\Data\'),'\');
% [~,orgPath,~] = uigetfile('MultiSelect','on','E:\Razeen\Data\*.jpg');
clear imgs;
str0 = split(matFileDir,'\');
mainFolder = cell2mat(join(str0(1:end-4),'\'));
orgPath = strcat(mainFolder,'\Org\');
analPath = cell2mat(join(str0(1:end-3),'\'));
fn = cell2mat(str0(end-4));
imgs = imRDImgs1(orgPath);
ptrn = OrgPtrn(orgPath);
handles.ptrn = ptrn;
handles.orgPath = orgPath;
handles.imgTy = 'JPG';
handles.imgs = imgs;
handles.mainFolder = mainFolder;

% MainFolder = strcat(folderPath,fn);
% folderPath = strcat('E:\Razeen\19Oct2023\Data\05Oct2023\',str(1:end-5),'\');
% OrgFPath = strcat(MainFolder,'\Org\');
% imgs = imRDImgs(OrgFPath);
MatFilePath = strcat(matFileDir,'\',matFileName);
load(MatFilePath);

axes(handles.axes4) 
imshow(RPE_EnfImg,'InitialMagnification','fit');

orgCibCobOvpath3 = strcat(analPath,'\CibCob3Dsm\');

handles.matFileDir = matFileDir;
handles.RPE_EnfImg = RPE_EnfImg;
handles.fn = fn;
handles.analPath = analPath;
handles.cib_3Dsm = cib_3Dsm;
handles.cob_3Dsm = cob_3Dsm;
handles.orgCibCobOvpath3 = orgCibCobOvpath3;
guidata(hObject,handles)

% --- Executes on button press in ManCorrections_CIB_COB_50.
function ManCorrections_CIB_COB_50_Callback(hObject, eventdata, handles)
% hObject    handle to ManCorrections_CIB_COB_50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SelectImages = get(handles.SelectImages,'String');
mFd = handles.mainFolder;
imgs = handles.imgs;
% str0 = split(SelectImages,',');
% clear snos;
% for i = 1:length(str0)
%     snos(i) = str2double(cell2mat(str0(i)));
% end
% snos = [1 100 200 300 400 500];
snos = [1 50 100 150 200 250 300 350 400 450 500];
[cib1, cob1, oPath] = multiple_image_correction_interp_snos(snos,mFd,imgs);   
handles.cib_3Dsm = cib1;
handles.cob_3Dsm = cob1;
winopen(oPath);
guidata(hObject,handles)

% --- Executes on button press in ManCorrections_COB_50.
function ManCorrections_COB_50_Callback(hObject, eventdata, handles)
% hObject    handle to ManCorrections_COB_50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mFd = handles.mainFolder;
imgs = handles.imgs;
% snos = [1 100 200 300 400 500];
snos = [1 50 100 150 200 250 300 350 400 450 500];
[cob1, oPath] = multiple_image_correction_interp_snos_COB(snos,mFd,imgs);   
% handles.cib_3Dsm = cib1;
handles.cob_3Dsm = cob1;
winopen(oPath);
guidata(hObject,handles)


% --- Executes on button press in ManCorrections_CIB_50.
function ManCorrections_CIB_50_Callback(hObject, eventdata, handles)
% hObject    handle to ManCorrections_CIB_50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SelectImages = get(handles.SelectImages,'String');
mFd = handles.mainFolder;
imgs = handles.imgs;
% str0 = split(SelectImages,',');
% clear snos;
% for i = 1:length(str0)
%     snos(i) = str2double(cell2mat(str0(i)));
% end
% snos = [1 100 200 300 400 500];
snos = [1 50 100 150 200 250 300 350 400 450 500];
[cib1, oPath] = multiple_image_correction_interp_snos_CIB(snos,mFd,imgs);   
handles.cib_3Dsm = cib1;
% handles.cob_3Dsm = cob1;
winopen(oPath);
guidata(hObject,handles)


% --- Executes on button press in Smoothing_CIB.
function Smoothing_CIB_Callback(hObject, eventdata, handles)
% hObject    handle to Smoothing_CIB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CIB = smoothdata(smoothdata(handles.cib_3Dsm,1,'rloess'),2,'rloess');

analPath = handles.analPath;
imgs = handles.imgs;
mn1_sz = 1:500;

% CIB = handles.cib_3Dsm;
COB = handles.cob_3Dsm;
cibPath = strcat(analPath,'\Corrections\ManCorrection\',date,'\Mul\CibCob3Dsm');
mkdir(cibPath);
for mn1 = mn1_sz   %  mn1 = x1:x2
    printing_cib_cob=mn1
    clear Ih4;
    Ih4(:,:,1) = imgs(:,:,mn1);
    Ih4(:,:,2) = imgs(:,:,mn1);
    Ih4(:,:,3) = imgs(:,:,mn1);
    try
    for i=1:size(Ih4,2)-1
        if round(CIB(i,mn1)) < 3
            CIB(i,mn1) = 3;
        end
        if round(COB(i,mn1)) < 0
            COB(i,mn1) = 0;
        end
        X_coord = round(CIB(i,mn1))-2:round(CIB(i,mn1))+2;
        X_coord2 = round(COB(i,mn1))-2:round(COB(i,mn1))+2;
        %             X_coord2 = round(CIB(i,mn1)+COB(i,mn1))-2:round(CIB(i,mn1)+COB(i,mn1))+2;
        Ih4(X_coord,i,1) = 255;
        Ih4(X_coord,i,2) = 255;
        Ih4(X_coord,i,3) = 0;
        Ih4(X_coord2,i,1) = 255;
        Ih4(X_coord2,i,2) = 255;
        Ih4(X_coord2,i,3) = 0;
    end
        %         fname = fileNames{mn1};
        %         fn = strcat('final_',fname(1:end-4));
    filname_COB_full = strcat(cibPath,'\image',sprintf('%04d',mn1),'.jpg');
    %         imshow(Ih4);
    imwrite(Ih4,filname_COB_full);
    catch ME
    fprintf('Failed to process scan numner %d: %s\n',mn1, ME.message);
    continue;
    end
end
winopen(cibPath);

answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
        handles.cib_3Dsm = CIB;
        guidata(hObject,handles)
    case 'No'
    disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in Smoothing_COB.
function Smoothing_COB_Callback(hObject, eventdata, handles)
% hObject    handle to Smoothing_COB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.cib_3Dsm = smoothdata(smoothdata(handles.cib_3Dsm,1,'rloess'),2,'rloess');
COB = smoothdata(smoothdata(handles.cob_3Dsm,1,'rloess'),2,'rloess');

analPath = handles.analPath;
imgs = handles.imgs;
mn1_sz = 1:500;

CIB = handles.cib_3Dsm;
% COB = handles.cob_3Dsm;
cobPath = strcat(analPath,'\Corrections\ManCorrection\',date,'\Mul\CibCob3Dsm');
mkdir(cobPath);
for mn1 = mn1_sz   %  mn1 = x1:x2
    printing_cib_cob=mn1
    clear Ih4;
    Ih4(:,:,1) = imgs(:,:,mn1);
    Ih4(:,:,2) = imgs(:,:,mn1);
    Ih4(:,:,3) = imgs(:,:,mn1);
    try
    for i=1:size(Ih4,2)-1
        if round(CIB(i,mn1)) < 3
            CIB(i,mn1) = 3;
        end
        if round(COB(i,mn1)) < 0
            COB(i,mn1) = 0;
        end
        X_coord = round(CIB(i,mn1))-2:round(CIB(i,mn1))+2;
        X_coord2 = round(COB(i,mn1))-2:round(COB(i,mn1))+2;
        %             X_coord2 = round(CIB(i,mn1)+COB(i,mn1))-2:round(CIB(i,mn1)+COB(i,mn1))+2;
        Ih4(X_coord,i,1)=255;
        Ih4(X_coord,i,2)=255;
        Ih4(X_coord,i,3)=0;
        Ih4(X_coord2,i,1)=255;
        Ih4(X_coord2,i,2)=255;
        Ih4(X_coord2,i,3)=0;
    end
        %         fname=fileNames{mn1};
        %         fn=strcat('final_',fname(1:end-4));
    filname_COB_full = strcat(cobPath,'\image',sprintf('%04d',mn1),'.jpg');
    %         imshow(Ih4);
    imwrite(Ih4,filname_COB_full);
    catch ME
    fprintf('Failed to process scan numner %d: %s\n',mn1, ME.message);
    continue;
    end
end
winopen(cobPath);

answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
        handles.cob_3Dsm = COB;
        guidata(hObject,handles)
    case 'No'
    disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end

% --- Executes on button press in Smoothing_CIB_COB.
function Smoothing_CIB_COB_Callback(hObject, eventdata, handles)
% hObject    handle to Smoothing_CIB_COB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.cib_3Dsm = smoothdata(smoothdata(handles.cib_3Dsm,1,'rloess'),2,'rloess');
% handles.cob_3Dsm = smoothdata(smoothdata(handles.cob_3Dsm,1,'rloess'),2,'rloess');
% guidata(hObject,handles)

CIB = smoothdata(smoothdata(handles.cib_3Dsm,1,'rloess'),2,'rloess');
COB = smoothdata(smoothdata(handles.cob_3Dsm,1,'rloess'),2,'rloess');

analPath = handles.analPath;
imgs = handles.imgs;
mn1_sz = 1:500;

cib_cob_path = strcat(analPath,'\Corrections\ManCorrection\',date,'\Mul\CibCob3Dsm');
mkdir(cib_cob_path);
for mn1 = mn1_sz   %  mn1 = x1:x2
    printing_cib_cob=mn1
    clear Ih4;
    Ih4(:,:,1) = imgs(:,:,mn1);
    Ih4(:,:,2) = imgs(:,:,mn1);
    Ih4(:,:,3) = imgs(:,:,mn1);
    try
    for i=1:size(Ih4,2)-1
        if round(CIB(i,mn1)) < 3
            CIB(i,mn1) = 3;
        end
        if round(COB(i,mn1)) < 0
            COB(i,mn1) = 0;
        end
        X_coord = round(CIB(i,mn1))-2:round(CIB(i,mn1))+2;
        X_coord2 = round(COB(i,mn1))-2:round(COB(i,mn1))+2;
        %             X_coord2 = round(CIB(i,mn1)+COB(i,mn1))-2:round(CIB(i,mn1)+COB(i,mn1))+2;
        Ih4(X_coord,i,1)=255;
        Ih4(X_coord,i,2)=255;
        Ih4(X_coord,i,3)=0;
        Ih4(X_coord2,i,1)=255;
        Ih4(X_coord2,i,2)=255;
        Ih4(X_coord2,i,3)=0;
    end
        %         fname=fileNames{mn1};
        %         fn=strcat('final_',fname(1:end-4));
    filname_COB_full = strcat(cib_cob_path,'\image',sprintf('%04d',mn1),'.jpg');
    %         imshow(Ih4);
    imwrite(Ih4,filname_COB_full);
    catch ME
    fprintf('Failed to process scan numner %d: %s\n',mn1, ME.message);
    continue;
    end
end
winopen(cib_cob_path);

answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
        handles.cib_3Dsm = CIB;
        handles.cob_3Dsm = COB;
        guidata(hObject,handles)
    case 'No'
    disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in UpdateSegmentations.
function UpdateSegmentations_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateSegmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cib_3Dsm  = handles.cib_3Dsm;
cob_3Dsm  = handles.cob_3Dsm;
RPE_EnfImg = handles.RPE_EnfImg;
% mFd = handles.mainFolder
matFileDir = handles.matFileDir;
% str1 = split(mFd,'\');
% str2 = str1{end}; 
fn = handles.fn;
mkdir(strcat(matFileDir,'Bkp\'));
movefile(strcat(matFileDir,fn,'.mat'),strcat(matFileDir,'Bkp\',fn,'_bkp_',date,'.mat'));
save(strcat(matFileDir,fn,'.mat'),'cib_3Dsm','cob_3Dsm','RPE_EnfImg');

% movefile(strcat(mFd,'\Analysis\MatFile\',str2,'.mat'),strcat(mFd,'\Analysis\MatFile\Bkp\',str2,'_bkp_',date,'.mat'));
% save(strcat(mFd,'\Analysis\MatFile\',str2,'.mat'),'cib_3Dsm','cob_3Dsm','enfImg');


function rpt_scan_no_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_scan_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpt_scan_no as text
%        str2double(get(hObject,'String')) returns contents of rpt_scan_no as a double


% --- Executes during object creation, after setting all properties.
function rpt_scan_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpt_scan_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rpt_corr_scan_range_Callback(hObject, ~, handles)
% hObject    handle to rpt_corr_scan_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpt_corr_scan_range as text
%        str2double(get(hObject,'String')) returns contents of rpt_corr_scan_range as a double


% --- Executes during object creation, after setting all properties.
function rpt_corr_scan_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpt_corr_scan_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CIB_Corr_Ref.
function CIB_Corr_Ref_Callback(hObject, eventdata, handles)
% hObject    handle to CIB_Corr_Ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rpt_scan_no = get(handles.rpt_scan_no,'String');
rpt_range = get(handles.rpt_corr_scan_range,'String');

strr = split(rpt_range,'-')';  


cib_old = handles.cib_3Dsm;
cob_old = handles.cob_3Dsm;
% 
s0 = str2double(rpt_scan_no);
s1 = str2double(strr{1});
s2 = str2double(strr{2});
sd = size(cib_old,2);

% if s1 == 1
%     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
%     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
% else
cib = [cib_old(:,1:s1-1) repmat(cib_old(:,s0),1,s2-s1+1) cib_old(:,s2+1:sd)];
% end

% c2 = handles.c2;
imgs = handles.imgs;
% filePath = handles.filePath;

MFPath = handles.mainFolder;
opOrgFPath = strcat(MFPath,'\Analysis\Corrections\Reference\CIB\');
nvar='cib_sm_rep';
% tic
% newSegPath = plt_wf_cib(imgs,cib_old,cib,cob_old,opOrgFPath,nvar,s1:s2);
newSegPath = plt_wf_cibcob(imgs,cib,cob_old,opOrgFPath,nvar,s1:s2);
winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,imgs,filePath)
        enf_img = enfImg1(cib,imgs);
        RPE_EnfImg = flipud(enf_img');
        figure;imshow(RPE_EnfImg); 
%         title(handles.fn, 'Interpreter', 'none')
%         enf_img = handles.enf_img;
        cib_3Dsm = cib;
        handles.cib_3Dsm = cib_3Dsm;
        cob_3Dsm = cob_old;
        handles.cob_3Dsm = cob_3Dsm;
        
        opMatFPath = strcat(MFPath,'\Analysis\Corrections\Reference\CIB\',date,'\MatFile\cib_corr_rpt_',rpt_scan_no,'_',rpt_range);
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rangs',str3)
        mkdir(opMatFPath);
        save(strcat(opMatFPath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','RPE_EnfImg','cib_old','rpt_scan_no','rpt_range');

%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cib_corr_rpt_',rpt_scan_no,'_',rpt_range)
%         mkdir(strcat(fpath,'\CurvatureAnalysis'));
%         save(strcat(fpath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','enfImg','cib_old','rpt_scan_no','rpt_range');
        guidata(hObject, handles);
%         dessert = 1;
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in COB_Corr_Ref.
function COB_Corr_Ref_Callback(hObject, eventdata, handles)
% hObject    handle to COB_Corr_Ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rpt_scan_no = get(handles.rpt_scan_no,'String');
rpt_range = get(handles.rpt_corr_scan_range,'String');

strr = split(rpt_range,'-')';  


cib_old = handles.cib_3Dsm;
cob_old = handles.cob_3Dsm;
% 
s0 = str2double(rpt_scan_no);
s1 = str2double(strr{1});
s2 = str2double(strr{2});
sd = size(cob_old,2);

% if s1 == 1
%     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
%     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
% else
cob = [cob_old(:,1:s1-1) repmat(cob_old(:,s0),1,s2-s1+1) cob_old(:,s2+1:sd)];
% end

% c2 = handles.c2;
imgs = handles.imgs;
% filePath = handles.filePath;
MFPath = handles.mainFolder;
opOrgFPath = strcat(MFPath,'\Analysis\Corrections\Reference\COB\');
nvar='cob_sm_rep';
% tic
newSegPath = plt_wf_cibcob(imgs,cib_old,cob,opOrgFPath,nvar,s1:s2);
winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?','Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,imgs,filePath)
%         enf_img = enfImg1(cib,imgs);
        RPE_EnfImg = handles.RPE_EnfImg;
%         enfImg = flipud(enf_img');
        figure;imshow(RPE_EnfImg);
%         title(handles.fn, 'Interpreter', 'none')
        cib_3Dsm = cib_old;
        handles.cib_3Dsm = cib_3Dsm;
        cob_3Dsm = cob;
        handles.cob_3Dsm = cob;
        
        opMatFPath = strcat(MFPath,'\Analysis\Corrections\Reference\COB\',date,'\MatFile\cob_corr_rpt_',rpt_scan_no,'_',rpt_range);
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rangs',str3)
        mkdir(opMatFPath);
        save(strcat(opMatFPath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','cob_old','RPE_EnfImg','rpt_scan_no','rpt_range');
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rpt_',rpt_scan_no,'_',rpt_range)
%         mkdir(strcat(fpath,'\CurvatureAnalysis'));
%         save(strcat(fpath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','cob_old','enfImg','rpt_scan_no','rpt_range');
        guidata(hObject, handles);
%         dessert = 1;
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in CIB_COB_Corr_Ref.
function CIB_COB_Corr_Ref_Callback(hObject, eventdata, handles)
% hObject    handle to CIB_COB_Corr_Ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rpt_scan_no = get(handles.rpt_scan_no,'String');
rpt_range = get(handles.rpt_corr_scan_range,'String');

strr = split(rpt_range,'-')';  


cib_old = handles.cib_3Dsm;
cob_old = handles.cob_3Dsm;

% 
s0 = str2double(rpt_scan_no);
s1 = str2double(strr{1});
s2 = str2double(strr{2});
sd = size(cib_old,2);

% if s1 == 1
%     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
%     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
% else
cib = [cib_old(:,1:s1-1) repmat(cib_old(:,s0),1,s2-s1+1) cib_old(:,s2+1:sd)];
cob = [cob_old(:,1:s1-1) repmat(cob_old(:,s0),1,s2-s1+1) cob_old(:,s2+1:sd)];
% end

% c2 = handles.c2;
imgs = handles.imgs;
% filePath = handles.filePath;
MFPath = handles.mainFolder;
opOrgFPath = strcat(MFPath,'\Analysis\Corrections\Reference\CIB_COB\');
nvar='cib_cob_sm_rep';
% tic
newSegPath = plt_wf_cibcob(imgs,cib,cob,opOrgFPath,nvar,s1:s2)
winopen(newSegPath);
answer = questdlg('Boundary corrections, okay?','Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,imgs,filePath)
        enf_img = enfImg1(cib,imgs);
        RPE_EnfImg = flipud(enf_img');
        figure;imshow(RPE_EnfImg);
%         title(handles.fn, 'Interpreter', 'none')
        cib_3Dsm = cib;
        handles.cib_3Dsm = cib_3Dsm;
        cob_3Dsm = cob;
        handles.cob_3Dsm = cob_3Dsm;
%         str1 = split(filePath,'\')
%         str2 = split(str1{7},'_');        
%         kywd = join(str2(1:end-1),'_')
        opMatFPath = strcat(MFPath,'\Analysis\Corrections\Reference\CIB_COB\',date,'\MatFile\cib_cob_corr_rpt_',rpt_scan_no,'_',rpt_range);
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rangs',str3)
        mkdir(opMatFPath);
        save(strcat(opMatFPath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','cib_old','cob_old','RPE_EnfImg','rpt_scan_no','rpt_range');

%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cib_cob_corr_rpt_',rpt_scan_no,'_',rpt_range)
%         mkdir(strcat(fpath,'\CurvatureAnalysis'));
%         save(strcat(fpath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','cib_old','cob_old','enfImg','rpt_scan_no','rpt_range');
        guidata(hObject, handles);
%         dessert = 1;
%         guidata(hObject, handles);
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end



function spurious_snos_Callback(hObject, eventdata, handles)
% hObject    handle to spurious_snos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spurious_snos as text
%        str2double(get(hObject,'String')) returns contents of spurious_snos as a double


% --- Executes during object creation, after setting all properties.
function spurious_snos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spurious_snos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Perfrom_Boundary_Correction_cib.
function Perfrom_Boundary_Correction_cib_Callback(hObject, eventdata, handles)
% hObject    handle to Perfrom_Boundary_Correction_cib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spurious_snos = get(handles.spurious_snos,'String');
% load('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat')
cib_old = handles.cib_3Dsm;
cob_old = handles.cob_3Dsm;
% c2 = handles.c2;
imgs = handles.imgs;

MFPath = handles.mainFolder;
opOrgFPath = strcat(MFPath,'\Analysis\Corrections\Range\CIB\');
[cib_new,rang,~] = chSeg_corr_cib(cib_old,spurious_snos);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='cib_sm_afterCorrection';
% tic
% newSegPath = plt_wf_cib(imgs,cib_old,cib_new,cob_old,opOrgFPath,nvar,rang1)
newSegPath = plt_wf_cibcob(imgs,cib_new,cob_old,opOrgFPath,nvar,rang1);
% plt_ws_sm=toc

% newSegPath=handles.newSegPath;

% set(handles.Output_thickness,'string',out4)
% output_folder=handles.OutFolder;
%  p = genpath(output_folder);
 winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,imgs,filePath)
        enf_img = enfImg1(cib_new,imgs);
        RPE_EnfImg = flipud(enf_img');
        figure;imshow(RPE_EnfImg);
%         title(handles.fn, 'Interpreter', 'none')
        cib_3Dsm = cib_new;
        handles.cib_3Dsm = cib_3Dsm;
        cob_3Dsm = cob_old;
        handles.cob_3Dsm = cob_3Dsm;
%         str1 = split(filePath,'\')
%         str2 = split(str1{7},'_');        
%         kywd = join(str2(1:end-1),'_')
        temp = rang';
        rang_all = unique(temp(:))';
        str3 = [];
        for ind = 1:length(rang_all)
            str3 = strcat(str3,'_',int2str(rang_all(ind)));
        end
        opMatFPath = strcat(MFPath,'\Analysis\Corrections\Range\CIB\',date,'\MatFile\cib_corr_rangs',str3);
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rangs',str3)
        mkdir(opMatFPath);
        save(strcat(opMatFPath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','RPE_EnfImg','cib_old');
%         dessert = 1;
        guidata(hObject,handles);
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in Perfrom_Boundary_Correction_cob.
function Perfrom_Boundary_Correction_cob_Callback(hObject, eventdata, handles)
% hObject    handle to Perfrom_Boundary_Correction_cob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Spurious_scanNumbers = get(handles.spurious_snos,'String');
% load('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat')
cib_old = handles.cib_3Dsm;
cob_old = handles.cob_3Dsm;
% c2 = handles.c2;
imgs = handles.imgs;
% filePath = handles.filePath;
MFPath = handles.mainFolder;
opOrgFPath = strcat(MFPath,'\Analysis\Corrections\Range\COB\');

[cob_new,rang,~] = chSeg_corr_cob(cob_old,Spurious_scanNumbers);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='cob_sm_afterCorrection';
% tic
newSegPath = plt_wf_cibcob(imgs,cib_old,cob_new,opOrgFPath,nvar,rang1)
% plt_ws_sm=toc

% newSegPath=handles.newSegPath;

% set(handles.Output_thickness,'string',out4)
% output_folder=handles.OutFolder;
%  p = genpath(output_folder);
 winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?','Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,imgs,filePath)
%         enf_img = enfImg1(cib_new,imgs);
        enf_img = handles.enf_img;
        RPE_EnfImg = flipud(enf_img');
        figure;imshow(RPE_EnfImg);
%         title(handles.fn, 'Interpreter', 'none')
        cib_3Dsm = cib_old;
        handles.cib_3Dsm = cib_3Dsm;
        cob_3Dsm = cob_new;
        handles.cob_3Dsm = cob_3Dsm;
        temp = rang';
        rang_all = unique(temp(:))';
        str3 = [];
        for ind = 1:length(rang_all)
            str3 = strcat(str3,'_',int2str(rang_all(ind)));
        end
        opMatFPath = strcat(MFPath,'\Analysis\Corrections\Range\COB\',date,'\MatFile\cob_corr_rangs',str3);
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rangs',str3)
        mkdir(opMatFPath);
        save(strcat(opMatFPath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','RPE_EnfImg');
%         dessert = 1;
        guidata(hObject,handles);
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end

% --- Executes on button press in Perfrom_Boundary_Correction_cib_cob.
function Perfrom_Boundary_Correction_cib_cob_Callback(hObject, eventdata, handles)
% hObject    handle to Perfrom_Boundary_Correction_cib_cob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% chSeg_corr(cib,cob,rang)  
% get(hObject,'String')
spurious_snos = get(handles.spurious_snos,'String');
% load('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat')
cib_old = handles.cib_3Dsm;
cob_old = handles.cob_3Dsm;
% c2 = handles.c2;
imgs = handles.imgs;
% filePath = handles.filePath;
MFPath = handles.mainFolder;
opOrgFPath = strcat(MFPath,'\Analysis\Corrections\Range\CIB_COB\');
[cib_new,cob_new,rang,~] = chSeg_corr_cib_cob(cib_old,cob_old,spurious_snos);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i = 1:size(rang,1)
    rang1 = [rang1 rang(i,1):rang(i,2)];
end
nvar='cib_cob_sm_afterCorrection';
newSegPath = plt_wf_cibcob(imgs,cib_new,cob_new,opOrgFPath,nvar,rang1);

 winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,imgs,filePath)
        enf_img = enfImg1(cib_new,imgs);
        RPE_EnfImg = flipud(enf_img');
        cib_3Dsm = cib_new;
        handles.cib_3Dsm = cib_3Dsm;
        cob_3Dsm = cob_new;
        handles.cob_3Dsm = cob_3Dsm;
%         str1 = split(filePath,'\')
%         str2 = split(str1{7},'_');        
%         kywd = join(str2(1:end-1),'_')
        temp = rang';
        rang_all = unique(temp(:))';
        str3 = [];
        for ind = 1:length(rang_all)
            str3 = strcat(str3,'_',int2str(rang_all(ind)));
        end
        opMatFPath = strcat(MFPath,'\Analysis\Corrections\Range\CIB_COB\',date,'\MatFile\cib_cob_corr_rangs',str3);
%         fpath = strcat('D:\Chrd_Segmentation\GUI\Data\Choroid_Topography_MatFiles\',kywd{1},'\cob_corr_rangs',str3)
        mkdir(opMatFPath);
        save(strcat(opMatFPath,'\Data.mat'),'cib_3Dsm','cob_3Dsm','RPE_EnfImg','cib_old','spurious_snos');
        guidata(hObject,handles);
%         dessert = 1;
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in ShowSurfaces.
function ShowSurfaces_Callback(hObject, eventdata, handles)
% hObject    handle to ShowSurfaces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1);
mesh(handles.cib_3Dsm);view(0,90);title("CIB");
figure(2);
mesh(handles.cob_3Dsm);view(0,90);title("COB");
% ,'InitialMagnification','fit'
% strcat(handles.fn,


% --- Executes on button press in sixxsix.
% --- Executes on button press in PerformChoroidVesselSegmentation.
function PerformChoroidVesselSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to PerformChoroidVesselSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RPE_EnfImg = handles.RPE_EnfImg;
mainFolder = handles.mainFolder;
cib_3Dsm = round(handles.cib_3Dsm);
cob_3Dsm = round(handles.cob_3Dsm);
fn = handles.fn;
msk = handles.mask;
imgs0 = handles.imgs;
sz = size(imgs0);
if sz(2) == 500 || sz(2) == 512 || sz(2) == 1024
    sz_2 = 1024;
else
    sz_2 = round((sz(2)/500)*1024);
end
dpth_sf = 2;
offset = 3;
imgs = imresize3(imgs0,[sz(1)/dpth_sf sz_2 sz(3)]);

cib = round(imresize(cib_3Dsm/dpth_sf,[sz_2 sz(3)]))-offset;
cob = round(imresize(cob_3Dsm/dpth_sf,[sz_2 sz(3)]))+offset;
clear vol_40 vol_60 vol1 vol2;
img_rsz = [sz(1)/dpth_sf sz_2];
adp_bsz = [2 2];
phn_bsz = [40 40];
phn_bsz_1 = [60 60];
vol_60 = phnProcessing(imgs,img_rsz,adp_bsz,phn_bsz_1,cib,cob,fn);
vol1 = imfill(vol_60,'holes');
vol_40 = phnProcessing(imgs,img_rsz,adp_bsz,phn_bsz,cib,cob,fn);
clear mask0 mask;
if ~islogical(msk)
    mask0 = imbinarize(squeeze(msk(:,:,1)));
else
    mask0 = msk;
end
vol = zeros(size(vol_40));
se = strel('disk',2);
for sno = 1:size(vol_40,3)
    vol(:,:,sno) = imopen(vol_40(:,:,sno),se);
end
sz1 = size(vol);
mask = imresize(mask0,[sz1(3) sz1(2)]);
vol2 = imresize3(vol.*permute(repmat(mask,[1,1,size(vol,1)]),[3 2 1]),[sz1(1) 256 256]);

collatedImgPth = [mainFolder,'\Analysis\ChBndry_ChVes_Segs\Org_Cib_Cob_Ves_OverlayedImgs\'];
mkdir(collatedImgPth);
% save('temp.mat','imgs','vol60','vol40','collatedImgPth','fn');
plt_bndry_vessel(imgs,vol1,cib,cob,collatedImgPth,fn);
winopen(collatedImgPth);
% plt_vas(mat3D_3Dpts(vol40));
% plt_vas(mat3D_3Dpts(vol60));
matFPth = [mainFolder,'\Analysis\ChBndry_ChVes_Segs\MatFile\'];
status = 1;
if ~exist(matFPth,'dir')
    status = 0;
    mkdir(matFPth);
end
if status == 0
    save(strcat(matFPth,fn,'.mat'),'vol1','vol2','mask','cib_3Dsm','cob_3Dsm','RPE_EnfImg');  %  
else
    save(strcat(matFPth,fn,'.mat'),'vol1','vol2','mask','cib_3Dsm','cob_3Dsm','RPE_EnfImg','-append');  %  
end
handles.vol1 = vol1;
handles.vol2 = vol2;
handles.collatedImgPth = collatedImgPth;
handles.matFPth = matFPth;
guidata(hObject,handles);

% --- Executes on button press in readODMask.
function readODMask_Callback(hObject, eventdata, handles)
% hObject    handle to readODMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msk0 = imread([handles.mainFolder,'\Mask.jpg']);
mask = imbinarize(msk0(:,:,1));
handles.mask = mask;
% sz = size(mask)
fsh(mask)
guidata(hObject, handles);


% --- Executes on button press in ILM_RPE_Detection.
function ILM_RPE_Detection_Callback(hObject, eventdata, handles)
% hObject    handle to ILM_RPE_Detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainFolder = handles.mainFolder;
fn = handles.fn;
ilm_rpe_analysis_Path = [mainFolder,filesep,'Analysis\ILM_RPE\']; mkdir(ilm_rpe_analysis_Path);
orgPath = strcat(mainFolder,'\Org\');
matFPth = strcat(mainFolder,'\Analysis\ChBndry_ChVes_Segs\MatFile\');
status = 1;
if ~exist(matFPth,'dir')
    status = 0;
    mkdir(matFPth);
end
% load(MatFileName,'enfImg_Gmean2');  % 'vol2',
% enfImg_Gmean2 = enfImg_Gmean2;
% vol2 = vol2+1;
% clear vol2;
maskPath = [mainFolder,filesep,'Analysis\ILM_RPE\Mask\'];
mkdir(maskPath);    
rLayer_h5Path = 'D:\Choroid\ChVes_Quant\Code\ScriptsForGeneratingData\11Feb2024\weights-improvement-88.hdf5';
cmd = cell2mat(strcat('python ResUNet2_MaskOverlayed_Org.py',{' '},orgPath,{' '},rLayer_h5Path,{' '},maskPath));
system(cmd);
[ilm, rpe, rLayer, ILM_RPE_Seg_Path] = IlmRpeOverLayRawImg_EnfImg(orgPath,ilm_rpe_analysis_Path,fn); 
% [ilm, rpe, rLayer,imgs] = CibCobOverLayRawImg_EnfImg(orgPath,ilm_rpe_analysis_Path,fno,fn); 
a2 = 0.03;b2 = 0.03;
a3 = 0.05;b3 = 0.05;
enfImg_Gmean1 = rLayer2enfImg_guassian(rLayer,a2,b2);
enfImg_Gmean2 = rLayer2enfImg_guassian(rLayer,a3,b3);
enfImg_Gmean3 = max(enfImg_Gmean1,enfImg_Gmean2);
fsh([enfImg_Gmean2 enfImg_Gmean3]);title(fn,'Interpreter','none');
% mPth1 = [mainFolder,'/Analysis/ChBndry_ChVes_Segs/MatFile/'];
% save(strcat(matFileDir,fn,'.mat'),"cib_2Dsm","cob_2Dsm","cib_3Dsm","cob_3Dsm","RPE_EnfImg");
if status == 0
    save([matFPth,fn,'.mat'],'ilm','rpe','rLayer','enfImg_Gmean2','enfImg_Gmean3','a2','b2','a3','b3');
else
    save([matFPth,fn,'.mat'],'ilm','rpe','rLayer','enfImg_Gmean2','enfImg_Gmean3','a2','b2','a3','b3','-append');
end
handles.enfImg_Gmean1 = enfImg_Gmean1;
handles.enfImg_Gmean2 = enfImg_Gmean2;
handles.enfImg_Gmean3 = enfImg_Gmean3;
handles.ilm = ilm;
handles.rpe = rpe;
handles.rLayer = rLayer;
handles.matFPth = matFPth;
handles.ILM_RPE_Seg_Path = ILM_RPE_Seg_Path;
guidata(hObject, handles);


% --- Executes on button press in ILM_RPE_Segmentations.
function ILM_RPE_Segmentations_Callback(hObject, eventdata, handles)
% hObject    handle to ILM_RPE_Segmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(handles.ILM_RPE_Seg_Path);


% --- Executes on button press in ShowRetinalEnfImage.
function ShowRetinalEnfImage_Callback(hObject, eventdata, handles)
% hObject    handle to ShowRetinalEnfImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fsh([handles.enfImg_Gmean1 handles.enfImg_Gmean2 handles.enfImg_Gmean3]);


% --- Executes on button press in showChVesSegmentations.
function showChVesSegmentations_Callback(hObject, eventdata, handles)
% hObject    handle to showChVesSegmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(handles.collatedImgPth)
