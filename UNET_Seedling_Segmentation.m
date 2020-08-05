dbpath = 'L:/Samiul/Seedlings';

imagedir = 'AugmentedTrainingData/trainingimg'; % Directory that holds the images and labels
labeldir = 'AugmentedTrainingData/traininglabel';
rng(123);

imagepath = [dbpath '/' imagedir]; % The entire path to the images and labels
labelpath = [dbpath '/' labeldir];

labelIDs = [0, 1, 2 ,3, 4]; % Setup the datasets to be used by UNET
className = ["background","root","shoot1","shoot2","hook"];
imds = imageDatastore(imagepath);
pxds = pixelLabelDatastore(labelpath, className, labelIDs);
ds = pixelLabelImageDatastore(imds, pxds); % Create data source for training a semantic segmentation network.

scale=16;
m=round(1920/scale);
n=round(2560/scale);%downsampling by factor of 

imds_validation=imageDatastore('TestData\TestImg\');
pxds_validation=pixelLabelDatastore('TestData\TestLabel\',className,labelIDs);
ds_validation=pixelLabelImageDatastore(imds_validation,pxds_validation);


imageSize = [m, n, 3]; % Parameters for the UNET
numClasses = 5;filtersize = 3;

lgraph = unetLayers(imageSize, numClasses, ... % Create the UNET object
           'FilterSize', filtersize,'EncoderDepth',3);
      
% Last Layer Name is 'Segmentation-Layer' 
% for checking layer name use :- lgraph.Layers 
lgraph2 = removeLayers(lgraph,'Segmentation-Layer'); 
layerlast = pixelClassificationLayer('Classes',className,'ClassWeights',[0.1,2,2,2,2],'Name','New_segmentation_Layer'); 
layer_to_add = [layerlast]; 
lgraph2 = addLayers(lgraph2,layer_to_add);  
lgraph2=connectLayers(lgraph2,'Softmax-Layer','New_segmentation_Layer');
%lgraph=layerGraph(lgraph);    
options = trainingOptions('adam', ...
                          'Plots', 'training-progress', ...
                          'MiniBatchSize', 16, ...
                          'MaxEpochs', 50,'ValidationData',ds_validation);
                      
net = trainNetwork(ds, lgraph2, options); % Train the UNET network
save('unte_projected_sum','net');