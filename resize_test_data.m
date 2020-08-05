filenames=dir('TestData\TestImg\*TIF');
scale=16;
for i=1:length(filenames)
    I=imread(fullfile('TestData\TestImg\',filenames(i).name));
    I=imresize(I,1/scale);
    imwrite(I,fullfile('TestData\TestImg\',filenames(i).name));
end

filenames=dir('TestData\TestLabel\*png');
for i=1:length(filenames)
    I=imread(fullfile('TestData\TestLabel\',filenames(i).name));
    I=imresize(I,1/scale);
    imwrite(I,fullfile('TestData\TestLabel\',filenames(i).name));
end