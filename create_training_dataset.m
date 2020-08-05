dbpath = 'L:/Samiul/Seedlings';

imagedir = 'AugmentedTrainingData/trainingimg'; % Directory that holds the images and labels
labeldir = 'AugmentedTrainingData/traininglabel';

imagepath = [dbpath '/' imagedir]; % The entire path to the images and labels
labelpath = [dbpath '/' labeldir];
rng(123);
filenames=dir('TrainingData/TrainingImage/*.TIF');
scale=16;
m=round(1920/scale);
n=round(2560/scale);%downsampling by factor of 
for i=1:length(filenames)
    I=imread(strcat('TrainingData/TrainingImage/',filenames(i).name));
    I=imresize(I,[m n]);
    imwrite(I,strcat('AugmentedTrainingData/trainingimg/',filenames(i).name));
    labelname=strsplit(filenames(i).name,'.');
    labelname=[labelname{1},'.png'];
    I=imread(strcat('TrainingData/TrainingLabel/',labelname));
    I=imresize(I,[m n]);
    imwrite(uint8(I),strcat('AugmentedTrainingData/traininglabel/',filenames(i).name));
end
ftype='.TIF';

for i=1:length(filenames)
    I=imread(strcat(imagepath,'/',filenames(i).name)); 
    r=randi([-40 40]);
    IR=imrotate(I,r,'nearest','loose');
    newfilename=filenames(i).name(1:end-length(ftype));    
    I2 = flipdim(I ,2);           %# horizontal flip
    imwrite(I2,strcat(imagepath,'/',newfilename,'_hflip',ftype));    
    I3 = flipdim(I ,1);           %# vertical flip
    imwrite(I3,strcat(imagepath,'/',newfilename,'_vflip',ftype));
    I4 = flipdim(I3,2);    %# horizontal+vertical flip
    imwrite(I4,strcat(imagepath,'/',newfilename,'_hvflip',ftype));    
    L=imread(strcat(labelpath,'/',filenames(i).name(1:end-length(ftype)),ftype));
    L2 = flipdim(L ,2);           %# horizontal flip
    imwrite(L2,strcat(labelpath,'/',newfilename,'_hflip',ftype));
    L3 = flipdim(L ,1);           %# vertical flip
    imwrite(L3,strcat(labelpath,'/',newfilename,'_vflip',ftype));
    L4 = flipdim(L3,2);    %# horizontal+vertical flip
    imwrite(L4,strcat(labelpath,'/',newfilename,'_hvflip',ftype));
    LR = imrotate(L,r,'nearest','loose');           %# vertical flip
    
    IR=imresize(IR,[m n]);
    LR=imresize(LR,[m n]);
    
    imwrite(LR,strcat(labelpath,'/',newfilename,'_rotateflip',ftype));
    imwrite(IR,strcat(imagepath,'/',newfilename,'_rotateflip',ftype));
    
end