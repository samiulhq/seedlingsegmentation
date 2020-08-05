%clear all;

%load network_new.mat
sacle=16;
m=1920/scale;
n=2560/scale;
filenames=dir('TestData\TestImg\*.TIF');
for i=1:length(filenames)
    Ifull=imread(strcat('TestData\TestOriginalImage\',filenames(i).name));
    I=imresize(Ifull,[m n]);
    [C,scores] = semanticseg(I,net);
    idx = grp2idx(C(:));
    idx=reshape(idx,[m,n]);
    idx=imresize(idx,[1920,2560]);
    B=labeloverlay(Ifull,round(idx));
    figure
    imshow(B)
    
    imwrite(B,fullfile('TestData','Prediction',filenames(i).name));
    %result(find(result<1))=0;
    
    
end