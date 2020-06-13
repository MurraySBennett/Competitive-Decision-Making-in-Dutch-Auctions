% Dutch  Auction  data analyses
%   reads data from Excel files and plots histograms
%   substitue [range] later  with 'find' command to skip NaN and 0 (practice block)
%
% Ami Eidels 10/9/2017  
%   updated 18/10/2017 to include basic warehouse completion analysis

% RACHEL, please note you can change the names of files to read as long as
% you call group data. For each ind' subject i'll need to alter the code
% ALSO, for computer condition we need to DISCARD computer data, and be mindful 
% of trial numbers per block

clear all; close all; clc; format short g

% SPECIFY PARAMETER VALUES
numGroups = 10;     % set the number of data sets (Groups) collected
numTrials = 12;    % set the number of trials per block (should be 12) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% reads Excel data for FAST
dataFast = xlsread('Multi Group Fast Combined', 'Full-MGF'); %29/9/19 - you only have 5 data files (therefore 10groups) til you download the alst one from server 1
%dataFast = xlsread('Fixed Group Fast Combined', 'Full-FGF');

% reads Excel data for SLOW
dataSlow = xlsread('Multi Group Slow Combined', 'Full-MGS');
%dataSlow = xlsread('Fixed Group Slow Combined', 'Full-FGS');


dataFast = sortrows(dataFast, 1);                   % sort data file by block
tempZero = find(dataFast(:, 1) == 0, 1, 'last');    % find the last practice trial
dataFast_price = dataFast(tempZero+1:end, 9);       % PRICE, excluding practice
dataFast_step = dataFast(tempZero+1:end, 7);        % STEP, excluding practice


dataSlow = sortrows(dataSlow, 1);                   % sort data file by block
tempZero = find(dataSlow(:, 1) == 0, 1, 'last');    % find the last practice trial
dataSlow_price = dataSlow(tempZero+1:end, 9);       % PRICE, excluding practice
dataSlow_step = dataSlow(tempZero+1:end, 7);        % STEP, excluding practice
% scale Slow step to Fast-step by some factor x (i suggest 11)
dataSlow_step = dataSlow_step * 11; 


% scatter plot & corr' of Price x Step
%   if they are correlated, it is enough to report just one of them.
%   because of the variability in Initial Price, however, we expect them to
%   not be correlted strongly
figure(1);
subplot(121); scatter(dataSlow_step, dataSlow_price); title('Slow');
    lsline; [r, p] = corr(dataSlow_step, dataSlow_price); 
    text(max(dataSlow_step), max(dataSlow_price), ['R = ' num2str(r)]);
    ylabel('price'); xlabel('step');
subplot(122); scatter(dataFast_step, dataFast_price); title('Fast');
    lsline; [r, p] = corr(dataFast_step, dataFast_price)
    text(max(dataFast_step), max(dataFast_price), ['R = ' num2str(r)]);
    ylabel('price'); xlabel('step');

    
% histograms of Price and Step (x Fast/Slow) 
figure(2)
subplot(221); hist(dataFast_price); title('Fast - price')
subplot(222); hist(dataSlow_price); title('Slow - price')
subplot(223); hist(dataFast_step);title('Fast - step')
    xlim([0 100])
subplot(224); hist(dataSlow_step); title('Slow - step')
    xlim([0 100])
    
    
% plotting ecdf (cumultaive distribution functions) of Price against Step
figure(3)
sgtitle('Cumulative Distribution Function: Price v Step')
subplot(121); ecdf(dataSlow_step); hold on; ecdf(dataFast_step); title('step');
legend('Slow', 'Fast', 'Location', 'Best')
subplot(122); ecdf(dataSlow_price); hold on; ecdf(dataFast_price); title('price')
legend('Slow', 'Fast', 'Location', 'Best')


% statistical comparisons

% create CSV file for Rachel to put in JASP (t-test, Bayes test)
 csvwrite('tempJaspData.csv', [dataFast_price dataFast_step dataSlow_price dataSlow_step]);

% k-s test, between two dist
disp('K-S --- SLOW vs FAST - PRICE')
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
[H,P,KSSTAT] = kstest2(dataSlow_price, dataFast_price)
disp('SLOW vs FAST - STEP')
disp('~~~~~~~~~~~~~~~~~~')
[H,P,KSSTAT] = kstest2(dataSlow_step, dataFast_step)

% t-test
disp('t-test --- SLOW vs FAST - PRICE')
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
[H,P,CI,STATS] = ttest2(dataSlow_price, dataFast_price)
disp('SLOW vs FAST - STEP')
disp('~~~~~~~~~~~~~~~~~~')
[H,P,CI,STATS] = ttest2(dataSlow_step, dataFast_step)


% calculate Price & Step PER BLOCK  
numBlocks = 5;
for i = 1:numBlocks;
    tempFirst = (i-1) * numGroups*numTrials + 1;  % Temp Index to help find the FIRST entry of each block
    tempLast = i * numGroups*numTrials;           % Temp Index to help find the LAST entry of each block
    
    % calculate mean for Step and Price, for each BLOCK (aggregated across groups)
    meanSlowPrice(i) = mean(dataSlow_price(tempFirst:tempLast));
    meanFastPrice(i) = mean(dataFast_price(tempFirst:tempLast));
    meanSlowStep(i) = mean(dataSlow_step(tempFirst:tempLast));
    meanFastStep(i) = mean(dataFast_step(tempFirst:tempLast));
       
     % calculate standard error( SE = stdev / sqrt(N) ) for Step and Price, for each BLOCK (aggregated across groups)
    seSlowPrice(i) = std(dataSlow_price(tempFirst:tempLast)) / sqrt( (length(dataSlow_price) / numBlocks) );
    seFastPrice(i) = std(dataFast_price(tempFirst:tempLast)) / sqrt( (length(dataFast_price) / numBlocks) );
    seSlowStep(i) = std(dataSlow_step(tempFirst:tempLast)) / sqrt( (length(dataSlow_step) / numBlocks) );
    seFastStep(i) = std(dataFast_step(tempFirst:tempLast)) / sqrt( (length(dataFast_step) / numBlocks) );
end
    
figure(4)
% subplot(121); title('Price')
% plot(1:5, meanSlowPrice); hold on
% plot(1:5, meanFastPrice)
% 
% subplot(122); title('Step')
% plot(1:5, meanSlowStep); hold on
% plot(1:5, meanFastStep)
sgtitle('Aggregate Data')
subplot(121); 
errorbar (1:5, meanSlowPrice, seSlowPrice, seSlowPrice); hold on
errorbar (1:5, meanFastPrice, seFastPrice, seFastPrice)
title('Price'); xlim([0 6]); xlabel('Block');xticks(1:5)
ylabel('Funds ($)')
legend('Slow', 'Fast'); axis square
    
subplot(122); 
errorbar (1:5, meanSlowStep, seSlowStep, seSlowStep); hold on
errorbar (1:5, meanFastStep, seFastStep, seFastStep)
title('Step'); xlim([0 6]); xlabel('Block');xticks(1:5)
ylabel('Proportion of Time Remaining')
legend('Slow', 'Fast'); axis square
