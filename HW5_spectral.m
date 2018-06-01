clear;


data= load('data2.mat');

%set number of clusters
c= 8;

%spectral clustering
[setspectral{1}, setspectral{2}]= spectral(data.X);
[setspectral{1}, setspectral{3}]= spectral(setspectral{1});
[setspectral{2}, setspectral{4}]= spectral(setspectral{2});
[setspectral{1}, setspectral{5}]= spectral(setspectral{1});
[setspectral{2}, setspectral{6}]= spectral(setspectral{2});
[setspectral{3}, setspectral{7}]= spectral(setspectral{3});
[setspectral{4}, setspectral{8}]= spectral(setspectral{4});


%calculate sse for spectral clustering

ssespectral= 0;
for i= 1: c
    sum= 0;
    center= mean(setspectral{i}, 2);
    for j= 1: size(setspectral{i}, 2)
        sample= setspectral{i}(:, j);
        sum= sum+ norm(sample- center)^2;
    end
    ssespectral= ssespectral+ sum;
end

%calculate minimum variance for spectral clustering
Je= 0;
for i= 1: c
    Si= 0;
    for j= 1: size(setspectral{i}, 2)
        samplej= setspectral{i}(:, j);
        sum= 0;
        for k= 1: size(setspectral{i}, 2)
            samplek= setspectral{i}(:, k);
            sum= sum+ norm(samplej- samplek)^2;
        end
        Si= Si+ sum;
    end
    Si= Si/size(setspectral{i}, 2)^2;
    Je= size(setspectral{i}, 2)*Si;
end
Je= Je/2;


%calculate determinant criteria for spectral clustering
SW= zeros(2);
for i= 1: c             %for each class
    center= mean(setspectral{i}, 2);
    sum= zeros(2);
    for j= 1: size(setspectral{i}, 2)         %for each sample in class
        sample= setspectral{i}(:, j);
        sum= sum+ (sample- center)*(sample- center)';
    end
    SW= SW+ sum;
end
SW= det(SW);


%plot the clusters
plot(setspectral{1}(1, :), setspectral{1}(2, :), 'o');
hold on;
plot(setspectral{2}(1, :), setspectral{2}(2, :), 'x');
hold on;
plot(setspectral{3}(1, :), setspectral{3}(2, :), '*');
hold on;
plot(setspectral{4}(1, :), setspectral{4}(2, :), 'd');
hold on;
plot(setspectral{5}(1, :), setspectral{5}(2, :), '.');
hold on;
plot(setspectral{6}(1, :), setspectral{6}(2, :), '+');
hold on;
plot(setspectral{7}(1, :), setspectral{7}(2, :), 's');
hold on;
plot(setspectral{8}(1, :), setspectral{8}(2, :), '^');
hold off;






function [cluster1, cluster2]= spectral(data)
    dim= size(data);
    W= zeros(dim(2));
    D= zeros(dim(2));
    cluster1= [];
    cluster2= [];
    for i= 1: dim(2)
        sample1= data(:, i);
        di= 0;
        for j= 1: dim(2)
            sample2= data(:, j);
            W(i, j)= exp(-(norm(sample1- sample2)^2)*0.1);
            di= di+ W(i, j);
           
        end
        D(i, i)= di;
    end
    
    
    L= D- W;
    matrix= (D^-0.5)*L*(D^-0.5);
    [V, d]= eig(matrix);
  
    
    [~, I]= sort(diag(d), 'ascend');
    V= V(:, [I]);
    
    y= (D^0.5)*V(:, 2);
    
    for i= 1: dim(2)
        if y(i)> 0
            cluster1= [cluster1 data(:, i)];
        else
            cluster2= [cluster2 data(:, i)];
        
        end
    end

end