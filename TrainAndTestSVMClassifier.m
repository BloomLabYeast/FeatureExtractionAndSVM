function [classifier,prediction,numCorrect,accuracy,completetrainingset,...
    completetraininglabels,completetestingset,completetestinglabels,...
    firstmatrixtraining,secondmatrixtraining,firstmatrixtraininglabels,...
    secondmatrixtraininglabels,firstmatrixtesting,secondmatrixtesting,...
    firstmatrixtestinglabels,secondmatrixtestinglabels] = ...
    TrainAndTestSVMClassifier(firstmatrix, firststring, secondmatrix,...
    secondstring, ColumnsOfInterests, PercentForTraining)
%%
%TRAINANDTESTSVMCLASSIFIER is used to generate and test a SVM that has been
%given two matricies of measurment values from two different categories.
%
%This function takes in 6 different inputs:
%
%   FIRSTMATRIX is a matrix of data of different measurements or parameters
%   from the first category's population. Every column corresponds to a
%   different type of measurement while every row refers to a different
%   sample point and its specific measurement values.
%
%   FIRSTSTRING is a string that represents the name or title for the first
%   category
%
%   SECONDMATRIX and SECONDSTRING is identical to that of the FIRSTMATRIX
%   and FIRSTSTRING except for the second category
%
%   ColumnsOfInterest is an array of column inices that should be used in
%   the SVM.
%
%   PERCENTFORTRAINING refers to a numerical value ranging from 0-100 that
%   specifies the percent of the sample provides that should be used for
%   training. The rest is used for final testing.

%%
% Check to make sure the amount of samples are equal. If not, randomly
% sample from the larger set to get the same size.

if size(firstmatrix,1) < size(secondmatrix,1)
    selection = datasample(1:size(secondmatrix,1),size(firstmatrix,1),'Replace',false);
    secondmatrix = secondmatrix(selection,:);
elseif size(secondmatrix,1) < size(firstmatrix,1)
    selection = datasample(1:size(firstmatrix,1),size(secondmatrix,1),'Replace',false);
    firstmatrix = firstmatrix(selection,:);
end

%Extract the information from the columns of interest
firstmatrix = firstmatrix(:,ColumnsOfInterests);
secondmatrix = secondmatrix(:,ColumnsOfInterests);

%Create the training and testing data and the associated array of labels
%for both matricies
[firstmatrixtraining,firstmatrixtraininglabels,firstmatrixtesting,firstmatrixtestinglabels] = CreateTrainAndTestData(firstmatrix,firststring,PercentForTraining);
[secondmatrixtraining,secondmatrixtraininglabels,secondmatrixtesting,secondmatrixtestinglabels] = CreateTrainAndTestData(secondmatrix,secondstring,PercentForTraining);

%Combine the two training set and the two testing sets together to form one
%array that has all of the training data and one that has all of the
%testing data
completetrainingset = [firstmatrixtraining;secondmatrixtraining];
completetraininglabels = [firstmatrixtraininglabels;secondmatrixtraininglabels];
completetestingset = [firstmatrixtesting,secondmatrixtesting];
completetestinglabels = [firstmatrixtestinglabels,secondmatrixtestinglabels];

%Randomize the order of samples in the training and testing sets
[completetrainingset,completetraininglabels] = RandomizeSet(completetrainingset,completetraininglabels);
[completetestingset, completetestinglabels] = RandomizeSet(completetestingset, completetestinglabels);

%Build classifier off of the training data
classifier = fitcsvm(completetrainingset,completetraininglabels,'KernelScale','auto','KernelFunction','linear','Verbose',0,'OptimizeHyperparameters','all');
disp(classifier)

%Create predictions of the classification of the testingset using the
%classifier
prediction = predict(classifier,completetestingset);

%Make the predictions into categories to allow for easier manipulation
prediction = categorical(prediction);

%Count the number of correct predictions and associated accuracy
numCorrect = nnz(prediction == categorical(completetestinglabels));
accuracy = numCorrect/length(prediction);

%Create a confusion chart of the classification
confusionchart(categorical(completetestinglabels),prediction)
end


