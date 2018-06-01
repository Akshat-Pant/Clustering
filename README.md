# Clustering
Clustering is an unsupervised learning technique. It seperates the smaples into different clusters based on some underlying similarity in the data.

## K-Means
K-Means clustering starts off by randomly initializing means followed by hard assignment of each sample to a cluster. This assignment is done based on some distance metric. I chose the euclidean distance.
The means are then recalculated. This is an iterative procedure. It converges to a solution when the number of samples changing clusters is minimal or the means do not move much from their positions.

## Expectation Maximization
The EM algorithm is an iterative approach to estimate the parameters of distributions in data. It has two steps
  1) The Expectation step
  2) The maximization step
The expectation step calculates the expectation of each sample belonging to each class/distribution. The maximization step updates the parameters of each distribution using the expectations from the previous step.

## Spectral clustering
Spectral clustering makes use of a graph based approach instead of the geometrical approach used in k-means clustering.
The Shi-Malik algorithm partitions samples into two sets based on the eigen-vecctor corresponding to the second smallest eigen value of the Laplacian matrix L= D-A, where D is the diagonal matrix with degree of nodes on the diagonal and A is the similarity matrix.
