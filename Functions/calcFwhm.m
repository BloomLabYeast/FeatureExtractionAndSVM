function [fwhm, rsq] = calcFwhm(fociIm,rows)
%%clacFwhm Calculate the full-width half-max in X and Y of an image of a
%%foci
%% parse the middle 7 columns (X) from fociIm and middle 15 rows (Y)
%The foci are centered around the brightest pixel
if mod(size(fociIm,1), 2) == 0
    mid = (size(fociIm,1))/2;
else
    mid = (size(fociIm,1) + 1)/2;
end
midFoci = fociIm(mid-floor(rows/2):mid+floor(rows/2), mid-3:mid+3);
%% Collapse midFoci into 1D array and process for fitting
sumY = sum(midFoci,2);
subVal = mean([sumY(1), sumY(end)]);
subY = sumY - subVal;
subY(subY < 0) = 0;
X = 0:length(subY) - 1;
%% Fit 2D gaussian to fociIm
[fitresult, gof] = customGauss1fit(X, subY);
%% Extract sigmaX and sigmaY
coefficients = coeffvalues(fitresult);
sigma = coefficients(end);
%% Convert to FWHM
fwhm = sigma*2.355;
%% Extract R squared value
rsq = gof.rsquare;