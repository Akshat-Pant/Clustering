%the plot function may produce error sometimes. This is because of the
%random inititalization of the means. If a mean is sufficiently far off
%from the data points, then one or more of the clusters can be empty. Hence
%the error on the plot function.
%simply run the program again if error is encountered.



clear;


data= load('data2.mat');

%set number of clusters
c= 8;

%run kmeans
[centers, clusters]= kmeans(data.X, c);

%use cell array to store different clusters


for i= 1: c         %for each cluster
    setkmeans{i}= [];
    for j= 1: size(data.X, 2)          %for each sample 
        if clusters(j)== i          
            setkmeans{i}= [setkmeans{i} data.X(:, j)];
        end
    end
end


% calculate sse for kmeans
ssekmeans= 0;
for i= 1: c
    sum= 0;
    center= centers(:, i);
    for j= 1: size(setkmeans{i}, 2)
        sample= setkmeans{i}(:, j);
        sum= sum+ norm(sample- center)^2;
    end
    ssekmeans= ssekmeans+ sum;
end


%calculate minimum variance for kmeans
Je= 0;
for i= 1: c
    Si= 0;
    for j= 1: size(setkmeans{i}, 2)
        samplej= setkmeans{i}(:, j);
        sum= 0;
        for k= 1: size(setkmeans{i}, 2)
            samplek= setkmeans{i}(:, k);
            sum= sum+ norm(samplej- samplek)^2;
        end
        Si= Si+sum;
    end
    Si= Si/size(setkmeans{i}, 2)^2;
    Je= Je+ size(setkmeans{i}, 2)*Si;
end
Je= Je/2;

%calculate determinant criteria for kmeans
SW= zeros(2);
for i= 1: c             %for each class
    mean= centers(:, i);
    sum= zeros(2);
    for j= 1: size(setkmeans{i}, 2)         %for each sample in class
        sample= setkmeans{i}(:, j);
        sum= sum+ (sample- mean)*(sample- mean)';
    end
    SW= SW+ sum;
end
SW= det(SW);


%plot the clusters
plot(setkmeans{1}(1, :), setkmeans{1}(2, :), 'o');
hold on;
plot(setkmeans{2}(1, :), setkmeans{2}(2, :), 'x');
hold on;
plot(setkmeans{3}(1, :), setkmeans{3}(2, :), '*');
hold on;
plot(setkmeans{4}(1, :), setkmeans{4}(2, :), 'd');
hold on;
plot(setkmeans{5}(1, :), setkmeans{5}(2, :), '.');
hold on;
plot(setkmeans{6}(1, :), setkmeans{6}(2, :), '+');
hold on;
plot(setkmeans{7}(1, :), setkmeans{7}(2, :), 's');
hold on;
plot(setkmeans{8}(1, :), setkmeans{8}(2, :), '^');
hold off;






function [means, labels]= kmeans(data, n_clusters)
    dim= size(data);
    means= randi([0, 6], dim(1), n_clusters);
    cluster_list= zeros(1, dim(2));
    means_old= zeros(dim(1), n_clusters);
    counter= 0;
    
    while 1
        for i= 1: dim(2)    %for each sample assign each sample to a cluster
            sample= data(:, i);
            norms= [];
            for j= 1: n_clusters        %distance of sample from each mean
                norms= [norms norm(sample- means(:, j))^2];
            end
            [~, I]= sort(norms, 'ascend');
            cluster_list(i)= I(1);  
        end
    
        for i= 1: n_clusters        %recompute means
            sum= zeros(dim(1), 1);
            elements= 0;
            for j= 1: dim(2)
                if cluster_list(j)== i
                    sum= sum+ data(:, j);
                    elements= elements+ 1;
                end
            end
            means(:, i)= sum/elements;
        end
    
        %check for change in means
        if int16(means)== int16(means_old)
            break
        else
            means_old= means;
            counter= counter+ 1
        end
        
    end
    
    labels= cluster_list;

end