function [trainingdata, traininglabels, testingdata, testinglabels] = CreateTrainAndTestData(array, string, PFT)

% CREATETRAINANDTESTDATA is a function that is used to create training and
% testing sets from one sample pool, following the percentage provided.

matrixselected = datasample(1:size(array,1),round(size(array,1)*PFT/100),'Replace',false);
trainingdata = array(matrixselected,:);
testingdata = 1:size(array,1);
testingdata(matrixselected) = [];
testingdata = array(testingdata,:);
traininglabels = cell(size(trainingdata,1),1);
testinglabels = cell(size(testingdata,1),1);
traininglabels(:) = {string};
testinglabels(:) = {string};
end