function [coeff,explained,sorted_features] = PCASimFeatureExtraction(matfile_0nm, matfile_25nm, matfile_50nm, matfile_100nm)
%%PCAFeatureExtraction performs principle component analysis on the merged
%%set of data from the input tables
%
%   inputs :
%       matfile_0nm : A string variable pointing to a MAT-file
%       containing the table variable generated from calling the
%       FeatureExtraction application on the directory containing the
%       compiled, and rotated simulated images from the 0-nm displacement
%       model.
%
%       matfile_25nm : A string variable pointing to a MAT-file
%       containing the table variable generated from calling the
%       FeatureExtraction application on the directory containing the
%       compiled, and rotated simulated images from the 25-nm displacement
%       model
%
%       matfile_50nm : A string variable pointing to a MAT-file
%       containing the table variable generated from calling the
%       FeatureExtraction application on the directory containing the
%       compiled, and rotated simulated images from the 50-nm displacement
%       model
%
%       matfile_100nm : A string variable pointing to a MAT-file
%       containing the table variable generated from calling the
%       FeatureExtraction application on the directory containing the
%       compiled, and rotated simulated images from the 100-nm displacement
%       model
%   outputs :
%       coeff : A matrix variable containing the principal components. Each
%       row represents a feature, each column represents a principal
%       component.
%
%       explained : An array variable containing the percentage of total
%       variance explained by each principal component.
%
%       sorted_features : A cell array containing the names of the features
%       listed from most important to least important.
%% Load, convert, and concatenate tables
sim0 = load(matfile_0nm, 'master');
sim25 = load(matfile_25nm, 'master');
sim50 = load(matfile_50nm, 'master');
sim100 = load(matfile_100nm, 'master');
master_table = [sim0.master; sim25.master; sim50.master; sim100.master];
master_array = table2array(master_table);
%% Parse only the relvant data from master_array
idx_array = [2, 12, 5, 6, 13];
features = master_table(:, idx_array).Properties.VariableNames;
feature_array = master_array(:, idx_array);
%% Call PCA on master_array
[coeff,~,~,~,explained] = pca(normalize(feature_array));
%% Sort features by importance (most to least)
max_comps = max(coeff.^2 .* repmat(explained', [numel(features),1]), [],2);
max_mat = sortrows([max_comps, (1:5)'], 'descend');
max_idx = max_mat(:,2);
sorted_features = features(max_idx);
