function a = MeanAndSTD(table)
format long g
array = table2array(table);
a = [];
for x = 1:size(table,2)
    a = [a;[mean(array(:,x)), std(array(:,x))]];
end