function [classifier,prediction,numCorrect,accuracy,completetrainingset,completetraininglabels] = TrainAndTestKernalClassifier(firstmatrix, firststring, secondmatrix, secondstring, ColumnsOfInterests)
PFT = 100;
if size(firstmatrix,1) < size(secondmatrix,1)
    selection = datasample(1:size(secondmatrix,1),size(firstmatrix,1),'Replace',false);
    secondmatrix = secondmatrix(selection,:);
else
    selection = datasample(1:size(firstmatrix,1),size(secondmatrix,1),'Replace',false);
    firstmatrix = firstmatrix(selection,:);
end
firstmatrix = firstmatrix(:,ColumnsOfInterests);
secondmatrix = secondmatrix(:,ColumnsOfInterests);

[firstmatrixtraining,firstmatrixtraininglabels,~,~] = CreateTrainAndTestData(firstmatrix,firststring,PFT);
[secondmatrixtraining,secondmatrixtraininglabels, ~,~] = CreateTrainAndTestData(secondmatrix,secondstring,PFT);
completetrainingset = [firstmatrixtraining;secondmatrixtraining];
completetraininglabels = [firstmatrixtraininglabels;secondmatrixtraininglabels];
[completetrainingset,completetraininglabels] = RandomizeSet(completetrainingset,completetraininglabels);
classifier = fitckernel(completetrainingset,completetraininglabels,'KernelScale','auto','Verbose',0,'OptimizeHyperparameters','all');
disp(classifier)
prediction = predict(classifier,completetrainingset);
prediction = categorical(prediction);
numCorrect = nnz(prediction == categorical(completetraininglabels));
accuracy = numCorrect/length(prediction);
confusionchart(categorical(completetraininglabels),prediction)
end


