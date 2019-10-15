function s = runSVM(cse4_table_matfile, nuf2_table_matfile, columns_to_keep)
%%runSVMs Runs a support vector machine classifier using only specified
%variables from the provided tables.
%   inputs :
%       cse4_table_matfile : A string variable pointing to a MAT-file
%       containing the table variable generated from calling the
%       FeatureExtraction application on the directory containing the
%       compiled, and rotated CSE4-GFP images.
%
%       nuf2_table_matfile : A string variable pointing to a MAT-file
%       containing the table variable generated from calling the
%       FeatureExtraction application on the directory containing the
%       compiled, and rotated GFP-NUF2 images.
%
%       columns_to_keep : An array variable specificing which columns to
%       keep in when training the SVM.
%
%   output :
%       s : A structural array contianing the following fields:
%
%           columns_to_keep : The array variable specificing which columns to
%           keep in when training the SVM.
%
%           test_labels : A categorical array contianing the correct
%           classifications of the test set. Meant to be compared to
%           predictions variable.
%
%           predictions : A categorical array containing the predicted
%           classifications of the test set. Meant to be compared to
%           test_labels variable.
%
%           accuracy : A float variable containing the accuracy of the test
%           dataset prediction.
%% Load and convert tables to matrices
cse4 = load(cse4_table_matfile, 'master');
cse4_matrix = normalize(table2array(cse4.master));
nuf2 = load(nuf2_table_matfile, 'master');
nuf2_matrix = normalize(table2array(nuf2.master));
%% Equailize data count between cse4 and nuf2
if size(cse4_matrix,1) < size(nuf2_matrix,1)
    selection = datasample(1:size(nuf2_matrix,1),size(cse4_matrix,1),'Replace',false);
    nuf2_matrix = nuf2_matrix(selection,:);
else
    selection = datasample(1:size(cse4_matrix,1),size(nuf2_matrix,1),'Replace',false);
    cse4_matrix = cse4_matrix(selection,:);
end
%% Parse only columns of interest
cse4_matrix = cse4_matrix(:,columns_to_keep);
nuf2_matrix = nuf2_matrix(:,columns_to_keep);
%% Create train and test matrices and labels
perc_for_train = 70; %percent for training
[cse4_matrixtraining,cse4_matrixtraininglabels,cse4_matrixtest,cse4_matrixtestlabels] = CreateTrainAndTestData(cse4_matrix,'cse4',perc_for_train);
[nuf2_matrixtraining,nuf2_matrixtraininglabels, nuf2_matrixtest,nuf2_matrixtestlabels] = CreateTrainAndTestData(nuf2_matrix,'nuf2',perc_for_train);
%concatenate training set and labels and randomize
training_set = [cse4_matrixtraining;nuf2_matrixtraining];
training_labels = [cse4_matrixtraininglabels;nuf2_matrixtraininglabels];
[training_set,training_labels] = RandomizeSet(training_set,training_labels);
%concatenate test set and labels and randomize
test_set = [cse4_matrixtest;nuf2_matrixtest];
test_labels = [cse4_matrixtestlabels;nuf2_matrixtestlabels];
[test_set,test_labels] = RandomizeSet(test_set,test_labels);
%% Train the SVM
classifier = fitcsvm(training_set,training_labels,'KernelScale','auto','KernelFunction','Gaussian','Verbose',0,'OptimizeHyperparameters','auto');
disp(classifier)
prediction = predict(classifier,test_set);
prediction = categorical(prediction);
test_labels = categorical(test_labels);
numCorrect = nnz(prediction == test_labels);
accuracy = numCorrect/length(prediction);
confusionchart(test_labels,prediction);
%% Determine training set accuracy
train_pred = categorical(predict(classifier,training_set));
training_labels = categorical(training_labels);
training_accuracy = (nnz(train_pred == training_labels))/length(train_pred);
%% Gather all output variables into single struct array
s.classifier = classifier;
s.prediction = prediction;
s.test_labels = test_labels;
s.accuracy = accuracy;
s.training_accuracy = training_accuracy;