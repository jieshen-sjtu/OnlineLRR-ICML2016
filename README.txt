This code is used for the ICML 2016 work "Online Low-Rank Subspace Clustering by Basis Dictionary Pursuit", Jie Shen, Ping Li, Huan Xu.
Feel free to use it for research purpose.

We make the code highly separable and thus flexible, i.e., each file only include one function to do one thing.

1. How to use

In the Matlab command window, run

>> DEMO.m

This should reproduce all the figures in our paper.

If there is any issue in the code or you have any gentle feedback, please contact Jie Shen: js2007@rutgers.edu


2. Baseline code

* OR-PCA is implemented by Jiashi Feng in his NIPS 2013 work "Online Robust PCA via Stochastic Optimization"

* PCP (i.e. inexact_alm_rpca) is implemented by Zhouchen Lin. See his homepage http://www.cis.pku.edu.cn/faculty/vision/zlin/zlin.htm for a newly released version of inexact ALM.

* PROPACK is invoked by PCP, which can be downloaded at http://sun.stanford.edu/~rmunk/PROPACK/

* LRR/LRR2 is implemented by Guangcan Liu. See his homepage https://sites.google.com/site/guangcanliu/

* SSC is available at Ehsan Elhamifar's homepage http://www.ccs.neu.edu/home/eelhami/codes.htm (we use the ADMM version)

* For the function "Misclassification.m" in the SSC toolkit, it invokes "missclassGroups.m" which is not efficient. We download "Hungarian.m" which is a considerably efficient implementation. See http://www.mathworks.com/matlabcentral/fileexchange/47544-point-clustering-via-voting-maximization/content/Hungarian.m

* As we mentioned in the paper, SSC attempted to post-process the solution "X" which makes it tricky to understand the effectiveness of the algorithms. Therefore, we remove these operations. In particular, in line 43 of the file "SSC/SSC.m", we use

CKSym = BuildAdjacency(C);

instead of the original one

CKSym = BuildAdjacency(thrC(C,rho));


3. How to cite

If this code is useful for your research, please kindly cite our work:

@inproceedings{shen2016online,
  title 	= {Online Low-Rank Subspace Clustering by Basis Dictionary Pursuit},
  author	= {Jie Shen and Ping Li and Huan Xu},
  booktitle	= {Proceedings of the 33rd International Conference on Machine Learning},
  pages		= {622--631},
  year		= {2016}
}
