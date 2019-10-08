function [coeff,explained,sorted_features] = PCAFeatureExtraction(cse4_table_matfile, nuf2_table_matfile)
%%PCAFeatureExtraction performs principle component analysis on the merged
%%set of data from the input tables
%
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
cse4 = load(cse4_table_matfile, 'master');
cse4_table = cse4.master;
nuf2 = load(nuf2_table_matfile, 'master');
nuf2_table = nuf2.master;
master_table = [cse4_table; nuf2_table];
master_array = table2array(master_table);
%% Parse only the relvant data from master_array
idx_array = [2, 12, 5, 6, 13];
features = master_table(1,idx_array).Properties.VariableNames;
%% Call PCA on master_array
[coeff,~,~,~,explained] = pca(normalize(master_array(:,idx_array)));
%% Sort features by importance (most to least)
max_comps = max(coeff.^2 .* repmat(explained', [numel(features),1]), [],2);
max_mat = sortrows([max_comps, (1:5)'], 'descend');
max_idx = max_mat(:,2);
sorted_features = features(max_idx);

