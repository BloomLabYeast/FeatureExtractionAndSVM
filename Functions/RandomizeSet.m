function [finalset,finallabels] = RandomizeSet(initialset,initiallabels)
randomization = randperm(size(initialset,1));
finalset = initialset(randomization,:);
finallabels = initiallabels(randomization,:);
