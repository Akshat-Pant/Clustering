%the plot function may produce error sometimes. one or more of the clusters can be empty.
%Hence the error on the plot function.
%simply run the program again if error is encountered.

clear;



data= load('data2.mat');

%set number of clusters
c= 8;

%run EM
[u, cov, w, labels]=  EM(data.X, c);

%use cell array to store different clusters

for i= 1: c         %for each cluster
    setEM{i}= [];
    for j= 1: size(data.X, 2)          %for each sample 
        if labels(j)== i          
            setEM{i}= [setEM{i} data.X(:, j)];
        end
    end
end


%calculate sse for EM
sseEM= 0;
for i= 1: c
    sum= 0;
    center= u(:, i);
    for j= 1: size(setEM{i}, 2)
        sample= setEM{i}(:, j);
        sum= sum+ norm(sample- center)^2;
    end
    sseEM= sseEM+ sum;
end

%calculate variance for EM
Je= 0;
for i= 1: c
    Si= 0;
    for j= 1: size(setEM{i}, 2)
        samplej= setEM{i}(:, j);
        sum= 0;
        for k= 1: size(setEM{i}, 2)
            samplek= setEM{i}(:, k);
            sum= sum+ norm(samplej- samplek)^2;
        end
        Si= Si+sum;
    end
    Si= Si/size(setEM{i}, 2)^2;
    Je= Je+ size(setEM{i}, 2)*Si;
end
Je= Je/2;

%calculate determinant criteria for EM
SW= zeros(2);
for i= 1: c             %for each class
    mean= u(:, i);
    sum= zeros(2);
    for j= 1: size(setEM{i}, 2)         %for each sample in class
        sample= setEM{i}(:, j);
        sum= sum+ (sample- mean)*(sample- mean)';
    end
    SW= SW+ sum;
end
SW= det(SW);





plot(setEM{1}(1, :), setEM{1}(2, :), 'o');
hold on;
plot(setEM{2}(1, :), setEM{2}(2, :), '*');
hold on;
plot(setEM{3}(1, :), setEM{3}(2, :), 'x');
hold on;
plot(setEM{4}(1, :), setEM{4}(2, :), 'd');
hold on;
plot(setEM{5}(1, :), setEM{5}(2, :), '.');
hold on;
plot(setEM{6}(1, :), setEM{6}(2, :), 's');
hold on;
plot(setEM{7}(1, :), setEM{7}(2, :), '+');
hold on;
plot(setEM{8}(1, :), setEM{8}(2, :), '^');
hold off;




function prob= gaussian(sample, mean, covariance)
    scalar1= (2*pi)^-1;
    scalar2= det(covariance)^-0.5;
    scalar= scalar1*scalar2;
    exp1= sample- mean;
    exp2= inv(covariance);
    exponent= exp(-0.5*exp1'*exp2*exp1);
    prob= scalar*exponent;
end




function [means, covariances, priors, clusters]= EM(dataset, n_classes)
    %initialize means and covariances
    dim= size(dataset);
    means= randi([-5, 5], dim(1), n_classes);
    covariances= zeros(dim(1), dim(1), n_classes);
    for i= 1: n_classes
        covariances(:, :, i)= eye(dim(1));
    end
    
    %initialize expectation matrix
    expectation= zeros(dim(2), n_classes);
    
    %initialize class prob as equal
    priors= zeros(1, n_classes);
    for i= 1: n_classes
        priors(1: i)= 1/n_classes;
    end
    
    for iter= 1: 100
        %expectation step. calculate expectations for each sample
        for i= 1: dim(2)    %for each sample
            px= 0;
            sample= dataset(:, i);
            for j= 1: n_classes         %for each class
                px= px+ gaussian(sample, means(:, j), covariances(:, :, j))*priors(j);
            end
        
            for j= 1: n_classes
                expectations(i, j)= gaussian(sample, means(:, j), covariances(:, :, j))/px;
            end
        end
    
        %maximization step. recalculate means and covariances for each class
        for class= 1: n_classes         %for each class recalculate means
            denominator= 0;
            numerator= 0;
            for sample= 1: dim(2)
                denominator= denominator+ expectations(sample, class);
                numerator= numerator+ expectations(sample, class)*dataset(:, sample);
            end
            means(:, class)= numerator/denominator;
        end
    
        for class= 1: n_classes         %for each class recalculate  covariances
            denominator= 0;
            numerator= 0;
            for sample= 1: dim(2)
                cov= dataset(:, sample)- means(:, class);
                denominator= denominator+ expectations(sample, class);
                numerator= numerator+ expectations(sample, class)*cov*cov';
            end
            covariances(:, :, class)= numerator/denominator;
        end
    end
    
    %assign each sample to the class with maximum expectation. also
    %recalculate prior probabilities
    clusters= zeros(1, dim(2));
    
    for i= 1: dim(2)                %assign classes
        [~, I]= sort(expectations(i, :), 'descend');
        clusters(i)= I(1);
        priors(I(1))= priors(I(1))+ 1;
    end
    priors= priors/dim(2);

end


