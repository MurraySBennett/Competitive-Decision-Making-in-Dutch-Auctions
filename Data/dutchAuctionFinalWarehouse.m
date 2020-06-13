    
%%
% Final warehouse status by block
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
numBlocks = 5;
numGroups = 10;

dataFinalWare_FixedFast = [...
    xlsread('Multi Group Fast Combined', 'MGF-P234-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P567-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P8910-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P111213-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P141516-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P232425-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P262728-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P293031-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P323334-BLOCK');...
    xlsread('Multi Group Fast Combined', 'MGF-P353637-BLOCK')];
    
dataFinalWare_FixedFast = sortrows(dataFinalWare_FixedFast, 3)

dataFinalWare_FixedSlow = [...
    xlsread('Multi Group Slow Combined', 'MGS-P234-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P567-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P8910-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P111213-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P141516-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P171819-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P202122-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P232425-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P262728-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P293031-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P323334-BLOCK');...
    xlsread('Multi Group Slow Combined', 'MGS-P353637-BLOCK')];

dataFinalWare_FixedSlow = sortrows(dataFinalWare_FixedSlow, 3)

for i = 1:numBlocks;
    tempFirst = i * numGroups * 3 + 1          % Temp Index to help find the FIRST entry of each block
    tempLast = (i+1) * numGroups * 3           % Temp Index to help find the LAST entry of each block
    
    % calculate Final Warehous status for each BLOCK (aggregated across groups and players)
    meanFinalWare_FixedFast(i) = mean(dataFinalWare_FixedFast(tempFirst:tempLast));
    meanFinalWare_FixedSlow(i) = mean(dataFinalWare_FixedSlow(tempFirst:tempLast));
    
    
     % calculate standard error( SE = stdev / sqrt(N) ) for Final Warehous status for each BLOCK (aggregated across groups)
    seFinalWare_FixedFast(i) = std(dataFinalWare_FixedFast(tempFirst:tempLast)) / sqrt( (length(dataFinalWare_FixedFast) / (numBlocks*3)) );
    seFinalWare_FixedSlow(i) = std(dataFinalWare_FixedSlow(tempFirst:tempLast)) / sqrt( (length(dataFinalWare_FixedSlow) / (numBlocks*3)) );
    
end

figure
errorbar(1:5,meanFinalWare_FixedFast,seFinalWare_FixedFast,'rs'); hold on
errorbar(1:5,meanFinalWare_FixedSlow,seFinalWare_FixedSlow,'bd')
title('Multi: Warehouse Total');xlabel('Block');xticks(1:5);xlim([0 6]);ylabel('Stock');ylim([300 500])
legend('Fast','Slow');axis square
