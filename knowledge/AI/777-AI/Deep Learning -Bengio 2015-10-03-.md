---
title: "Deep Learning -Bengio 2015-10-03-"
source: "Deep Learning -Bengio 2015-10-03-.pdf"
type: pdf
tags: ["pdf"]
path: "777-AI-技术"
created: 2026-07-03
---

# Deep Learning -Bengio 2015-10-03-

## 内容

### Page 1

Deep Learning
Yoshua Bengio
Ian Goodfellow
Aaron Courville
October 03, 2015

### Page 2

Contents
Acknowledgments
vii
Notation
ix
1
Introduction
1
1.1
Who Should Read This Book? . . . . . . . . . . . . . . . . . . . .
8
1.2
Historical Trends in Deep Learning . . . . . . . . . . . . . . . . .
11
I
Applied Math and Machine Learning Basics
26
2
Linear Algebra
28
2.1
Scalars, Vectors, Matrices and Tensors . . . . . . . . . . . . . . .
28
2.2
Multiplying Matrices and Vectors . . . . . . . . . . . . . . . . . .
30
2.3
Identity and Inverse Matrices . . . . . . . . . . . . . . . . . . . .
32
2.4
Linear Dependence and Span
. . . . . . . . . . . . . . . . . . . .
33
2.5
Norms . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
35
2.6
Special Kinds of Matrices and Vectors
. . . . . . . . . . . . . . .
36
2.7
Eigendecomposition . . . . . . . . . . . . . . . . . . . . . . . . . .
38
2.8
Singular Value Decomposition . . . . . . . . . . . . . . . . . . . .
40
2.9
The Moore-Penrose Pseudoinverse
. . . . . . . . . . . . . . . . .
41
2.10
The Trace Operator
. . . . . . . . . . . . . . . . . . . . . . . . .
42
2.11
Determinant . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
43
2.12
Example: Principal Components Analysis
. . . . . . . . . . . . .
43
3
Probability and Information Theory
48
3.1
Why Probability? . . . . . . . . . . . . . . . . . . . . . . . . . . .
48
3.2
Random Variables
. . . . . . . . . . . . . . . . . . . . . . . . . .
51
3.3
Probability Distributions . . . . . . . . . . . . . . . . . . . . . . .
51
3.4
Marginal Probability . . . . . . . . . . . . . . . . . . . . . . . . .
53
3.5
Conditional Probability
. . . . . . . . . . . . . . . . . . . . . . .
53
i

### Page 3

CONTENTS
3.6
The Chain Rule of Conditional Probabilities . . . . . . . . . . . .
54
3.7
Independence and Conditional Independence
. . . . . . . . . . .
54
3.8
Expectation, Variance and Covariance
. . . . . . . . . . . . . . .
55
3.9
Information Theory . . . . . . . . . . . . . . . . . . . . . . . . . .
56
3.10
Common Probability Distributions . . . . . . . . . . . . . . . . .
59
3.11
Useful Properties of Common Functions . . . . . . . . . . . . . .
65
3.12
Bayes’ Rule . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
67
3.13
Technical Details of Continuous Variables
. . . . . . . . . . . . .
67
3.14
Structured Probabilistic Models . . . . . . . . . . . . . . . . . . .
69
3.15
Example: Naive Bayes . . . . . . . . . . . . . . . . . . . . . . . .
70
4
Numerical Computation
77
4.1
Overﬂow and Underﬂow . . . . . . . . . . . . . . . . . . . . . . .
77
4.2
Poor Conditioning
. . . . . . . . . . . . . . . . . . . . . . . . . .
78
4.3
Gradient-Based Optimization . . . . . . . . . . . . . . . . . . . .
79
4.4
Constrained Optimization . . . . . . . . . . . . . . . . . . . . . .
88
4.5
Example: Linear Least Squares . . . . . . . . . . . . . . . . . . .
90
5
Machine Learning Basics
92
5.1
Learning Algorithms . . . . . . . . . . . . . . . . . . . . . . . . .
92
5.2
Example: Linear Regression . . . . . . . . . . . . . . . . . . . . . 100
5.3
Generalization, Capacity, Overﬁtting and Underﬁtting . . . . . . 103
5.4
Hyperparameters and Validation Sets . . . . . . . . . . . . . . . . 113
5.5
Estimators, Bias and Variance . . . . . . . . . . . . . . . . . . . . 115
5.6
Maximum Likelihood Estimation . . . . . . . . . . . . . . . . . . 124
5.7
Bayesian Statistics
. . . . . . . . . . . . . . . . . . . . . . . . . . 127
5.8
Supervised Learning Algorithms . . . . . . . . . . . . . . . . . . . 134
5.9
Unsupervised Learning Algorithms . . . . . . . . . . . . . . . . . 139
5.10
Weakly Supervised Learning . . . . . . . . . . . . . . . . . . . . . 142
5.11
Building a Machine Learning Algorithm . . . . . . . . . . . . . . 143
5.12
The Curse of Dimensionality and Statistical Limitations of Local
Generalization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 145
II
Deep Networks: Modern Practices
156
6
Feedforward Deep Networks
158
6.1
MLPs from the 1980’s
. . . . . . . . . . . . . . . . . . . . . . . . 159
6.2
Estimating Conditional Statistics . . . . . . . . . . . . . . . . . . 163
6.3
Parametrizing a Learned Predictor . . . . . . . . . . . . . . . . . 163
6.4
Flow Graphs and Back-Propagation
. . . . . . . . . . . . . . . . 175
ii

### Page 4

CONTENTS
6.5
Back-propagation through Random Operations and Graphical
Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 188
6.6
Universal Approximation Properties and Depth . . . . . . . . . . 192
6.7
Feature / Representation Learning . . . . . . . . . . . . . . . . . 195
6.8
Piecewise Linear Hidden Units
. . . . . . . . . . . . . . . . . . . 197
6.9
Historical Notes . . . . . . . . . . . . . . . . . . . . . . . . . . . . 199
7
Regularization of Deep or Distributed Models
201
7.1
Regularization from a Bayesian Perspective
. . . . . . . . . . . . 203
7.2
Classical Regularization: Parameter Norm Penalty . . . . . . . . 204
7.3
Classical Regularization as Constrained Optimization . . . . . . . 212
7.4
Regularization and Under-Constrained Problems
. . . . . . . . . 213
7.5
Dataset Augmentation . . . . . . . . . . . . . . . . . . . . . . . . 214
7.6
Classical Regularization as Noise Robustness
. . . . . . . . . . . 216
7.7
Early Stopping as a Form of Regularization . . . . . . . . . . . . 220
7.8
Parameter Tying and Parameter Sharing . . . . . . . . . . . . . . 227
7.9
Sparse Representations . . . . . . . . . . . . . . . . . . . . . . . . 228
7.10
Bagging and Other Ensemble Methods . . . . . . . . . . . . . . . 230
7.11
Dropout . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 232
7.12
Multi-Task Learning . . . . . . . . . . . . . . . . . . . . . . . . . 235
7.13
Adversarial Training . . . . . . . . . . . . . . . . . . . . . . . . . 236
8
Optimization for Training Deep Models
240
8.1
Optimization for Model Training
. . . . . . . . . . . . . . . . . . 241
8.2
Challenges in Neural Network Optimization . . . . . . . . . . . . 246
8.3
Optimization Algorithms I: Basic Algorithms
. . . . . . . . . . . 259
8.4
Optimization Algorithms II: Adaptive Learning Rates
. . . . . . 265
8.5
Optimization Algorithms III: Approximate Second-Order Methods270
8.6
Optimization Algorithms IV: Natural Gradient
Methods . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 280
8.7
Optimization Strategies and Meta-Algorithms . . . . . . . . . . . 282
9
Convolutional Networks
296
9.1
The Convolution Operation . . . . . . . . . . . . . . . . . . . . . 297
9.2
Motivation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 300
9.3
Pooling
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 306
9.4
Convolution and Pooling as an Inﬁnitely Strong Prior
. . . . . . 309
9.5
Variants of the Basic Convolution Function
. . . . . . . . . . . . 310
9.6
Structured Outputs . . . . . . . . . . . . . . . . . . . . . . . . . . 316
9.7
Data Types . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 317
9.8
Eﬃcient Convolution Algorithms . . . . . . . . . . . . . . . . . . 319
iii

### Page 5

CONTENTS
9.9
Random or Unsupervised Features
. . . . . . . . . . . . . . . . . 320
9.10
The Neuroscientiﬁc Basis for Convolutional Networks . . . . . . . 321
9.11
Convolutional Networks and the History of Deep Learning . . . . 327
10 Sequence Modeling: Recurrent and Recursive Nets
330
10.1
Unfolding Flow Graphs and Sharing Parameters . . . . . . . . . . 331
10.2
Recurrent Neural Networks
. . . . . . . . . . . . . . . . . . . . . 333
10.3
Bidirectional RNNs . . . . . . . . . . . . . . . . . . . . . . . . . . 348
10.4
Encoder-Decoder Sequence-to-Sequence Architectures
. . . . . . 348
10.5
Deep Recurrent Networks
. . . . . . . . . . . . . . . . . . . . . . 350
10.6
Recursive Neural Networks
. . . . . . . . . . . . . . . . . . . . . 352
10.7
The Challenge of Long-Term Dependencies
. . . . . . . . . . . . 353
11 Practical methodology
371
11.1
Default Baseline Models . . . . . . . . . . . . . . . . . . . . . . . 373
11.2
Selecting Hyperparameters . . . . . . . . . . . . . . . . . . . . . . 374
11.3
Debugging Strategies . . . . . . . . . . . . . . . . . . . . . . . . . 383
12 Applications
388
12.1
Large Scale Deep Learning . . . . . . . . . . . . . . . . . . . . . . 388
12.2
Computer Vision . . . . . . . . . . . . . . . . . . . . . . . . . . . 396
12.3
Speech Recognition . . . . . . . . . . . . . . . . . . . . . . . . . . 401
12.4
Natural Language Processing and Neural Language Models
. . . 405
12.5
Structured Outputs . . . . . . . . . . . . . . . . . . . . . . . . . . 421
12.6
Other Applications . . . . . . . . . . . . . . . . . . . . . . . . . . 423
III
Deep Learning Research
432
13 Structured Probabilistic Models for Deep Learning
434
13.1
The Challenge of Unstructured Modeling . . . . . . . . . . . . . . 435
13.2
Using Graphs to Describe Model Structure . . . . . . . . . . . . . 439
13.3
Advantages of Structured Modeling . . . . . . . . . . . . . . . . . 453
13.4
Learning about Dependencies . . . . . . . . . . . . . . . . . . . . 454
13.5
Inference and Approximate Inference over Latent Variables
. . . 456
13.6
The Deep Learning Approach to Structured Probabilistic Models 457
14 Monte Carlo Methods
462
14.1
Markov Chain Monte Carlo Methods . . . . . . . . . . . . . . . . 462
14.2
The Diﬃculty of Mixing between Well-Separated Modes . . . . . 464
iv

### Page 6

CONTENTS
15 Linear Factor Models and Auto-Encoders
466
15.1
Regularized Auto-Encoders
. . . . . . . . . . . . . . . . . . . . . 467
15.2
Denoising Auto-encoders . . . . . . . . . . . . . . . . . . . . . . . 470
15.3
Representational Power, Layer Size and Depth
. . . . . . . . . . 472
15.4
Reconstruction Distribution . . . . . . . . . . . . . . . . . . . . . 473
15.5
Linear Factor Models . . . . . . . . . . . . . . . . . . . . . . . . . 474
15.6
Probabilistic PCA and Factor Analysis . . . . . . . . . . . . . . . 475
15.7
Reconstruction Error as Log-Likelihood
. . . . . . . . . . . . . . 479
15.8
Sparse Representations . . . . . . . . . . . . . . . . . . . . . . . . 480
15.9
Denoising Auto-Encoders
. . . . . . . . . . . . . . . . . . . . . . 485
15.10 Contractive Auto-Encoders
. . . . . . . . . . . . . . . . . . . . . 490
16 Representation Learning
493
16.1
Greedy Layerwise Unsupervised Pre-Training . . . . . . . . . . . 494
16.2
Transfer Learning and Domain Adaptation . . . . . . . . . . . . . 501
16.3
Semi-Supervised Learning . . . . . . . . . . . . . . . . . . . . . . 508
16.4
Semi-Supervised Learning and Disentangling Underlying Causal
Factors . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 509
16.5
Assumption of Underlying Factors and Distributed Representation511
16.6
Exponential Gain in Representational Eﬃciency from Distributed
Representations . . . . . . . . . . . . . . . . . . . . . . . . . . . . 515
16.7
Exponential Gain in Representational Eﬃciency from Depth . . . 517
16.8
Priors regarding the Underlying Factors
. . . . . . . . . . . . . . 520
17 The Manifold Perspective on Representation Learning
523
17.1
Manifold Interpretation of PCA and Linear Auto-Encoders
. . . 531
17.2
Manifold Interpretation of Sparse Coding
. . . . . . . . . . . . . 534
17.3
The Entropy Bias from Maximum Likelihood
. . . . . . . . . . . 534
17.4
Manifold Learning via Regularized Auto-Encoders
. . . . . . . . 535
17.5
Tangent Distance, Tangent-Prop, and Manifold Tangent Classiﬁer 536
18 Confronting the Partition Function
540
18.1
The Log-Likelihood Gradient of Energy-Based Models
. . . . . . 541
18.2
Stochastic Maximum Likelihood and Contrastive Divergence . . . 543
18.3
Pseudolikelihood
. . . . . . . . . . . . . . . . . . . . . . . . . . . 550
18.4
Score Matching and Ratio Matching
. . . . . . . . . . . . . . . . 552
18.5
Denoising Score Matching . . . . . . . . . . . . . . . . . . . . . . 554
18.6
Noise-Contrastive Estimation . . . . . . . . . . . . . . . . . . . . 554
18.7
Estimating the Partition Function
. . . . . . . . . . . . . . . . . 556
v

### Page 7

CONTENTS
19 Approximate inference
564
19.1
Inference as Optimization
. . . . . . . . . . . . . . . . . . . . . . 566
19.2
Expectation Maximization . . . . . . . . . . . . . . . . . . . . . . 567
19.3
MAP Inference: Sparse Coding as a Probabilistic Model . . . . . 568
19.4
Sequence Modeling with Graphical Models . . . . . . . . . . . . . 569
19.5
Combining Neural Networks and Search . . . . . . . . . . . . . . 579
19.6
Variational Inference and Learning . . . . . . . . . . . . . . . . . 584
19.7
Stochastic Inference
. . . . . . . . . . . . . . . . . . . . . . . . . 588
19.8
Learned Approximate Inference . . . . . . . . . . . . . . . . . . . 588
20 Deep Generative Models
590
20.1
Boltzmann Machines . . . . . . . . . . . . . . . . . . . . . . . . . 590
20.2
Restricted Boltzmann Machines . . . . . . . . . . . . . . . . . . . 593
20.3
Training Restricted Boltzmann Machines . . . . . . . . . . . . . . 596
20.4
Deep Belief Networks . . . . . . . . . . . . . . . . . . . . . . . . . 600
20.5
Deep Boltzmann Machines . . . . . . . . . . . . . . . . . . . . . . 603
20.6
Boltzmann Machines for Real-Valued Data . . . . . . . . . . . . . 614
20.7
Convolutional Boltzmann Machines . . . . . . . . . . . . . . . . . 617
20.8
Other Boltzmann Machines
. . . . . . . . . . . . . . . . . . . . . 618
20.9
Directed Generative Nets
. . . . . . . . . . . . . . . . . . . . . . 618
20.10 Auto-Regressive Networks . . . . . . . . . . . . . . . . . . . . . . 621
20.11 A Generative View of Autoencoders
. . . . . . . . . . . . . . . . 626
20.12 Generative Stochastic Networks . . . . . . . . . . . . . . . . . . . 632
20.13 Methodological Notes . . . . . . . . . . . . . . . . . . . . . . . . . 634
Bibliography
638
Index
686
vi

### Page 8

Acknowledgments
This book would not have been possible without the contributions of many people.
We would like to thank those who commented on our proposal for the book
and helped plan its contents and organization: Hugo Larochelle, Guillaume Alain,
Kyunghyun Cho, C¸a˘glar G¨ul¸cehre, Razvan Pascanu, David Krueger and Thomas
Roh´ee.
We would like to thank the people who oﬀered feedback on the content of
the book itself.
Some oﬀered feedback on many chapters: Mart´ın Abadi, Ju-
lian Serban, Laurent Dinh, Guillaume Alain, Kelvin Xu, Meire Fortunato, Ilya
Sutskever, Vincent Vanhoucke, David Warde-Farley, Augustus Q. Odena, David
Sussillo, Matko Boˇsnjak, Stephan Dreseitl, Jurgen Van Gael, Dustin Webb, Jo-
hannes Roith, Ion Androutsopoulos, Karl Pichotta, Pawel Chilinski, Halis Sak,
Fr´ed´eric Francis, Jonathan Hunt and Grigory Sapunov.
We would also like to thank those who provided us with useful feedback on
individual chapters:
• Chapter 1, Introduction: Johannes Roith, Eric Morris, Samira Ebrahimi,
Ozan C¸a˘glayan and Sebastien Bratieres.
• Chapter 2, Linear Algebra: Pierre Luc Carrier, Li Yao, Thomas Roh´ee,
Colby Toland, Amjad Almahairi, Sergey Oreshkov, Istv´an Petr´as, Dennis
Prangle Alessandro Vitale Nikola Bani´c and Eric Fosler-Lussier.
• Chapter 3, Probability and Information Theory: Rasmus Antti, Stephan
Gouws, Vincent Dumoulin, Artem Oboturov, Li Yao, John Philip Anderson,
Rui Fa, Kai Arulkumaran, and Miao Fan.
• Chapter 4, Numerical Computation: Tran Lam An.
• Chapter 5, Machine Learning Basics: Dzmitry Bahdanau and Zheng Sun.
• Chapter 6, Feedforward Deep Networks: David Krueger.
• Chapter 7, Regularization of Deep or Distributed Models: Wei Xue.
vii

### Page 9

CONTENTS
• Chapter 8, Optimization for Training Deep Models: James Martens and
Marcel Ackermann.
• Chapter 9, Convolutional Networks: Mehdi Mirza, C¸a˘glar G¨ul¸cehre and
Mart´ın Arjovsky.
• Chapter 10, Sequence Modeling: Recurrent and Recursive Nets: Mihaela
Rosca, Razvan Pascanu, Dmitriy Serdyuk and Dongyu Shi.
• Chapter 18, Confronting the Partition Function: Sam Bowman and Ozan
C¸a˘glayan.
• Chapter 20, Deep Generative Models: Fady Medhat
• Bibliography, Leslie N. Smith.
We also want to thank those who allowed us to reproduce images, ﬁgures
or data from their publications: David Warde-Farley, Matthew D. Zeiler, Rob
Fergus, Chris Olah, Jason Yosinski, Nicolas Chapados and James Bergstra. We
indicate their contributions in the ﬁgure captions throughout the text.
Finally, we would like to thank Google for allowing Ian Goodfellow to work
on the book as his 20% project while at Google. In particular, we would like to
thank Ian’s former manager, Greg Corrado, and his subsequent manager, Samy
Bengio, for their support of this eﬀort.
viii

### Page 10

Notation
This section provides a concise reference describing the notation used throughout
this book. If you are unfamiliar with any of these mathematical concepts, this
notation reference may seem intimidating. However, do not despair, we describe
most of these ideas in chapters 1-3.
Numbers and Arrays
a
A scalar (integer or real) value with the name “a”
a
A vector with the name “a”
A
A matrix with the name “A”
A
A tensor with the name “A”
In
Identity matrix with n rows and n columns
I
Identity matrix with dimensionality implied by context
ei
Standard basis vector [0, . . . , 0, 1, 0, . . . ,0] with a 1 at position i.
diag(a)
A square, diagonal matrix with entries given by a
a
A scalar random variable with the name “a”
a
A vector-valued random variable with the name “a”
A
A matrix-valued random variable with the name “A”
ix

### Page 11

CONTENTS
Sets and Graphs
A
A set with the name “A”
R
The set of real numbers
{0, 1}
The set containing 0 and 1
{0, 1, . .. , n}
The set of all integers between 0 and n
[a, b]
The real interval including a and b
(a, b]
The real interval excluding a but including b
A\B
Set subtraction, i.e., the elements of A that are not in B
G
A graph with the name “G”
PaG(xi)
The parents of xi in G.
Indexing
a i
Element i of vector a, with indexing starting at 1
a−i
All elements of vector a except for element i
Ai,j
Element i, j of matrix A
Ai,:
Row i of matrix A
A:,i
Column i of matrix A
Ai,j,k
Element (i, j, k) of a 3-D tensor A
A:,:,i
2-D slice of a 3-D tensor
a i
Element i of the random vector a
Linear Algebra Operations
A>
Transpose of matrix A
A+
Moore-Penrose pseudoinverse of A
A B
Element-wise (Hadamard) product of A and B
x

### Page 12

CONTENTS
Calculus
dy
dx
Derivative of y with respect to x
∂y
∂x
Partial derivative of y with respect to x
∇xy
Gradient of y with respect to x
∇X y
Matrix derivatives of y with respect to x
∂f
∂x
Jacobian matrix J ∈Rm×n of a function f : Rn →Rm
∇2
xf(x) or H(f)(x)
The Hessian matrix of f at input point x
Z
f(x)dx
Deﬁnite integral over the entire domain of x
Z
S
f(x)dx
Deﬁnite integral with respect to x over the set S
Probability and Information Theory
a⊥b
The random variables a and b are independent.
a⊥b | c
They are are conditionally independent given c.
Ex∼P[f(x)] or Ef(x)
Expectation of f(x) with respect to P(x)
Var(f(x))
Variance of f(x) under P (x)
Cov(f(x), g(x))
Covariance of f(x) and g(x) under P (x, y)
H(x)
Shannon entropy of the random variable x
DKL(PkQ)
Kullback-Leibler divergence of P and Q
xi

### Page 13

CONTENTS
Functions
f ◦g
Composition of the functions f and g
f(x; θ)
A function of x parameterized by θ
log x
Natural logarithm of x
σ(x)
Logistic sigmoid, 1/(1 + exp(−x))
ζ(x)
Softplus, log(1 + exp(x))
||x||p
Lp norm of x
x+
Positive part of x, i.e., max(0, x)
1 condition
is 1 if the condition is true, 0 otherwise.
Sometimes we write f(x), f(X), or f(X), when f is a function of a scalar rather
than a vector, matrix, or tensor. In this case, we mean to apply f to the array
element-wise. For example, if C = σ(X), then Ci,j,k = σ(Xi,j,k) for all valid values
of i, j and k.
Datasets and distributions
X
A set of training examples
x(i)
The i-th example (input) from a dataset
y (i) or y (i)
The target associated with x(i) for supervised learning
X
The m × n matrix with input example x(i) in row Xi,:
xii

### Page 14

Chapter 1
Introduction
Inventors have long dreamed of creating machines that think.
Ancient Greek
myths tell of intelligent objects, such as animated statues of human beings and
tables that arrive full of food and drink when called.
When programmable computers were ﬁrst conceived, people wondered whether
they might become intelligent, over a hundred years before one was built (Lovelace,
1842). Today, artiﬁcial intelligence (AI) is a thriving ﬁeld with many practical
applications and active research topics.
We look to intelligent software to au-
tomate routine labor, understand speech or images, make diagnoses in medicine
and to support basic scientiﬁc research.
In the early days of artiﬁcial intelligence, the ﬁeld rapidly tackled and solved
problems that are intellectually diﬃcult for human beings but relatively straight-
forward for computers—problems that can be described by a list of formal, math-
ematical rules. The true challenge to artiﬁcial intelligence proved to be solving
the tasks that are easy for people to perform but hard for people to describe
formally—problems that we solve intuitively, that feel automatic, like recognizing
spoken words or faces in images.
This book is about a solution to these more intuitive problems. This solution
is to allow computers to learn from experience and understand the world in terms
of a hierarchy of concepts, with each concept deﬁned in terms of its relation
to simpler concepts.
By gathering knowledge from experience, this approach
avoids the need for human operators to formally specify all of the knowledge that
the computer needs.
The hierarchy of concepts allows the computer to learn
complicated concepts by building them out of simpler ones. If we draw a graph
showing how these concepts are built on top of each other, the graph is deep, with
many layers. For this reason, we call this approach to AI deep learning.
Many of the early successes of AI took place in relatively sterile and formal
environments and did not require computers to have much knowledge about the
1

### Page 15

CHAPTER 1. INTRODUCTION
world. For example, IBM’s Deep Blue chess-playing system defeated world cham-
pion Garry Kasparov in 1997 (Hsu, 2002). Chess is of course a very simple world,
containing only sixty-four locations and thirty-two pieces that can move in only
rigidly circumscribed ways. Devising a successful chess strategy is a tremendous
accomplishment, but the challenge is not due to the diﬃculty of describing the
relevant concepts to the computer. Chess can be completely described by a very
brief list of completely formal rules, easily provided ahead of time by the pro-
grammer.
Ironically, abstract and formal tasks that are among the most diﬃcult mental
undertakings for a human being are among the easiest for a computer.
Com-
puters have long been able to defeat even the best human chess player, but are
only recently matching some of the abilities of average human beings to recog-
nize objects or speech. A person’s everyday life requires an immense amount of
knowledge about the world. Much of this knowledge is subjective and intuitive,
and therefore diﬃcult to articulate in a formal way. Computers need to capture
this same knowledge in order to behave in an intelligent way. One of the key
challenges in artiﬁcial intelligence is how to get this informal knowledge into a
computer.
Several artiﬁcial intelligence projects have sought to hard-code knowledge
about the world in formal languages. A computer can reason about statements in
these formal languages automatically using logical inference rules. This is known
as the knowledge base approach to artiﬁcial intelligence. None of these projects
has lead to a major success. One of the most famous such projects is Cyc (Lenat
and Guha, 1989). Cyc is an inference engine and a database of statements in
a language called CycL. These statements are entered by a staﬀof human su-
pervisors. It is an unwieldy process. People struggle to devise formal rules with
enough complexity to accurately describe the world. For example, Cyc failed to
understand a story about a person named Fred shaving in the morning (Linde,
1992). Its inference engine detected an inconsistency in the story: it knew that
people do not have electrical parts, but because Fred was holding an electric razor,
it believed the entity “FredWhileShaving” contained electrical parts. It therefore
asked whether Fred was still a person while he was shaving.
The diﬃculties faced by systems relying on hard-coded knowledge suggest that
AI systems need the ability to acquire their own knowledge, by extracting patterns
from raw data. This capability is known as machine learning. The introduction
of machine learning allowed computers to tackle problems involving knowledge
of the real world and make decisions that appear subjective. A simple machine
learning algorithm called logistic regression can determine whether to recommend
cesarean delivery (Mor-Yosef et al., 1990). A simple machine learning algorithm
called naive Bayes can separate legitimate e-mail from spam e-mail.
2

### Page 16

CHAPTER 1. INTRODUCTION
The performance of these simple machine learning algorithms depends heavily
on the representation of the data they are given.
For example, when logistic
regression is used to recommend cesarean delivery, the AI system does not examine
the patient directly. Instead, the doctor tells the system several pieces of relevant
information, such as the presence or absence of a uterine scar.
Each piece of
information included in the representation of the patient is known as a feature.
Logistic regression learns how each of these features of the patient correlates with
various outcomes.
However, it cannot inﬂuence the way that the features are
deﬁned in any way.
If logistic regression was given a 3-D MRI image of the
patient, rather than the doctor’s formalized report, it would not be able to make
useful predictions. Individual voxels1 in an MRI scan have negligible correlation
with any complications that might occur during delivery.
This dependence on representations is a general phenomenon that appears
throughout computer science and even daily life. In computer science, operations
such as searching a collection of data can proceed exponentially faster if the collec-
tion is structured and indexed intelligently. People can easily perform arithmetic
on Arabic numerals, but ﬁnd arithmetic on Roman numerals much more time
consuming. It is not surprising that the choice of representation has an enormous
eﬀect on the performance of machine learning algorithms. For a simple visual
example, see Fig. 1.1.
Many artiﬁcial intelligence tasks can be solved by designing the right set of
features to extract for that task, then providing these features to a simple machine
learning algorithm. For example, a useful feature for speaker identiﬁcation from
sound is the pitch. The pitch can be formally speciﬁed—it is the lowest frequency
major peak of the spectrogram. It is useful for speaker identiﬁcation because it
is determined by the size of the vocal tract, and therefore gives a strong clue as
to whether the speaker is a man, woman, or child.
However, for many tasks, it is diﬃcult to know what features should be ex-
tracted. For example, suppose that we would like to write a program to detect
cars in photographs. We know that cars have wheels, so we might like to use the
presence of a wheel as a feature. Unfortunately, it is diﬃcult to describe exactly
what a wheel looks like in terms of pixel values. A wheel has a simple geometric
shape but its image may be complicated by shadows falling on the wheel, the sun
glaring oﬀthe metal parts of the wheel, the fender of the car or an object in the
foreground obscuring part of the wheel, and so on.
One solution to this problem is to use machine learning to discover not only
the mapping from representation to output but also the representation itself.
This approach is known as representation learning. Learned representations of-
1A voxel is the value at a single point in a 3-D scan, much as a pixel as the value at a single
point in an image.
3

### Page 17

CHAPTER 1. INTRODUCTION
Figure 1.1: Example of diﬀerent representations: suppose we want to separate two cate-
gories of data by drawing a line between them in a scatterplot. In the plot on the left, we
represent some data using Cartesian coordinates, and the task is impossible. In the plot
on the right, we represent the data with polar coordinates and the task becomes simple
to solve with a vertical line. (Figure credit: David Warde-Farley)
ten result in much better performance than can be obtained with hand-designed
representations. They also allow AI systems to rapidly adapt to new tasks, with
minimal human intervention. A representation learning algorithm can discover a
good set of features for a simple task in minutes, or a complex task in hours to
months. Manually designing features for a complex task requires a great deal of
human time and eﬀort; it can take decades for an entire community of researchers.
The quintessential example of a representation learning algorithm is the au-
toencoder. An autoencoder is the combination of an encoder function that converts
the input data into a diﬀerent representation, and a decoder function that converts
the new representation back into the original format. Autoencoders are trained
to preserve as much information as possible when an input is run through the
encoder and then the decoder, but are also trained to make the new representa-
tion have various nice properties. Diﬀerent kinds of autoencoders aim to achieve
diﬀerent kinds of properties.
When designing features or algorithms for learning features, our goal is usually
to separate the factors of variation that explain the observed data. In this context,
we use the word “factors” simply to refer to separate sources of inﬂuence; the
factors are usually not combined by multiplication. Such factors are often not
quantities that are directly observed but they may exist either as unobserved
objects or forces in the physical world that aﬀect observable quantities, or they
are constructs in the human mind that provide useful simplifying explanations
4

### Page 18

CHAPTER 1. INTRODUCTION
or inferred causes of the observed data. They can be thought of as concepts or
abstractions that help us make sense of the rich variability in the data. When
analyzing a speech recording, the factors of variation include the speaker’s age,
their sex, their accent and the words that they are speaking. When analyzing an
image of a car, the factors of variation include the position of the car, its color,
and the angle and brightness of the sun.
A major source of diﬃculty in many real-world artiﬁcial intelligence applica-
tions is that many of the factors of variation inﬂuence every single piece of data
we are able to observe. The individual pixels in an image of a red car might be
very close to black at night. The shape of the car’s silhouette depends on the
viewing angle. Most applications require us to disentangle the factors of variation
and discard the ones that we do not care about.
Of course, it can be very diﬃcult to extract such high-level, abstract features
from raw data. Many of these factors of variation, such as a speaker’s accent,
can only be identiﬁed using sophisticated, nearly human-level understanding of
the data. When it is nearly as diﬃcult to obtain a representation as to solve the
original problem, representation learning does not, at ﬁrst glance, seem to help
us.
Deep learning solves this central problem in representation learning by intro-
ducing representations that are expressed in terms of other, simpler represen-
tations.
Deep learning allows the computer to build complex concepts out of
simpler concepts. Fig. 1.2 shows how a deep learning system can represent the
concept of an image of a person by combining simpler concepts, such as corners
and contours, which are in turn deﬁned in terms of edges.
The quintessential example of a deep learning model is the feedforward deep
network or multilayer perceptron (MLP). A multilayer perceptron is just a mathe-
matical function mapping some set of input values to output values. The function
is formed by composing many simpler functions. We can think of each applica-
tion of a diﬀerent mathematical function as providing a new representation of the
input.
The idea of learning the right representation for the data provides one per-
spective on deep learning. Another perspective on deep learning is that it allows
the computer to learn a multi-step computer program. Each layer of the repre-
sentation can be thought of as the state of the computer’s memory after executing
another set of instructions in parallel. Networks with greater depth can execute
more instructions in sequence. Being able to execute instructions sequentially of-
fers great power because later instructions can refer back to the results of earlier
instructions. According to this view of deep learning, not all of the information
in a layer’s representation of the input necessarily encodes factors of variation
that explain the input. The representation is also used to store state information
5

### Page 19

CHAPTER 1. INTRODUCTION
Visible layer
(input pixels)
1st hidden layer
(edges)
2nd hidden layer
(corners and
contours)
3rd hidden layer
(object parts)
CAR
PERSON
ANIMAL
Output
(object identity)
Figure 1.2: Illustration of a deep learning model. It is diﬃcult for a computer to un-
derstand the meaning of raw sensory input data, such as this image represented as a
collection of pixel values. The function mapping from a set of pixels to an object identity
is very complicated. Learning or evaluating this mapping seems insurmountable if tack-
led directly. Deep learning resolves this diﬃculty by breaking the desired complicated
mapping into a series of nested simple mappings, each described by a diﬀerent layer of
the model. The input is presented at the visible layer, so named because it contains the
variables that we are able to observe. Then a series of hidden layers extracts increasingly
abstract features from the image. These layers are called “hidden” because their values
are not given in the data; instead the model must determine which concepts are useful
for explaining the relationships in the observed data. The images here are visualizations
of the kind of feature represented by each hidden unit. Given the pixels, the ﬁrst layer
can easily identify edges, by comparing the brightness of neighboring pixels. Given the
ﬁrst hidden layer’s description of the edges, the second hidden layer can easily search for
corners and extended contours, which are recognizable as collections of edges. Given the
second hidden layer’s description of the image in terms of corners and contours, the third
hidden layer can detect entire parts of speciﬁc objects, by ﬁnding speciﬁc collections of
contours and corners. Finally, this description of the image in terms of the object parts
it contains can be used to recognize the objects present in the image. Images reproduced
with permission from Zeiler and Fergus (2014).
6

### Page 20

CHAPTER 1. INTRODUCTION
x1

w1
⇥
x2
w2
⇥
+
Element set
+
⇥

x
w
Element set
Logistic 
Regression
Logistic 
Regression
Figure 1.3: Illustration of computational ﬂow graphs mapping an input to an output
where each node performs an operation. Depth is the length of the longest path from input
to output but depends on the deﬁnition of what constitutes a possible computational step.
The computation depicted in these graphs is the output of a logistic regression model,
σ(wT x), where σ is the logistic sigmoid function. If we use addition, multiplication and
logistic sigmoids as the elements of our computer language, then this model has depth
three. If we view logistic regression as an element itself, then this model has depth one.
that helps to execute a program that can make sense of the input. This state
information could be analogous to a counter or pointer in a traditional computer
program. It has nothing to do with the content of the input speciﬁcally, but it
helps the model to organize its processing.
There are two main ways of measuring the depth of a model.
The ﬁrst view is based on the number of sequential instructions that must
be executed to evaluate the architecture. We can think of this as the length of
the longest path through a ﬂow chart that describes how to compute each of the
model’s outputs given its inputs. Just as two equivalent computer programs will
have diﬀerent lengths depending on which language the program is written in, the
same function may be drawn as a ﬂow chart with diﬀerent depths depending on
which functions we allow to be used as individual steps in the ﬂow chart. Fig. 1.3
illustrates how this choice of language can give two diﬀerent measurements for
the same architecture.
Another approach, used by deep probabilistic models, illustrates not the depth
of the computational graph but the depth of the graph describing how concepts are
related to each other. In this case, the depth of the ﬂow-chart of the computations
needed to compute the representation of each concept may be much deeper than
the graph of the concepts themselves. This is because the system’s understanding
of the simpler concepts can be reﬁned given information about the more complex
concepts. For example, an AI system observing an image of a face with one eye in
7

### Page 21

CHAPTER 1. INTRODUCTION
shadow may initially only see one eye. After detecting that a face is present, it can
then infer that a second eye is probably present as well. In this case, the graph of
concepts only includes two layers—a layer for eyes and a layer for faces—but the
graph of computations includes 2n layers if we reﬁne our estimate of each concept
given the other n times.
Because it is not always clear which of these two views—the depth of the
computational graph, or the depth of the probabilistic modeling graph—is most
relevant, and because diﬀerent people choose diﬀerent sets of smallest elements
from which to construct their graphs, there is no single correct value for the depth
of an architecture, just as there is no single correct value for length of a computer
program. Nor is there a consensus about how much depth a model requires to
qualify as “deep.” However, deep learning can safely be regarded as the study of
models that either involve a greater amount of composition of learned functions
or learned concepts than traditional machine learning does.
To summarize, deep learning, the subject of this book, is an approach to AI.
Speciﬁcally, it is a type of machine learning, a technique that allows computer
systems to improve with experience and data. According to the authors of this
book, machine learning is the only viable approach to building AI systems that can
operate in complicated, real-world environments. Deep learning is a particular
kind of machine learning that achieves great power and ﬂexibility by learning
to represent the world as a nested hierarchy of concepts and representations,
with each concept deﬁned in relation to simpler concepts, and more abstract
representations computed in terms of less abstract ones. Fig. 1.4 illustrates the
relationship between these diﬀerent AI disciplines.
Fig. 1.5 gives a high-level
schematic of how each works.
1.1
Who Should Read This Book?
This book can be useful for a variety of readers, but we wrote it with two main
target audiences in mind. One of these target audiences is university students (un-
dergraduate or graduate) learning about machine learning, including those who
are beginning a career in deep learning and artiﬁcial intelligence research. The
other target audience is software engineers who do not have a machine learning or
statistics background, but want to rapidly acquire one and begin using deep learn-
ing in their product or platform. Software engineers working in a wide variety of
industries are likely to ﬁnd deep learning to be useful, as it has already proven
successful in many areas including computer vision, speech and audio processing,
natural language processing, robotics, bioinformatics and chemistry, video games,
search engines, online advertising and ﬁnance.
This book has been organized into three parts in order to best accommodate
8

### Page 22

CHAPTER 1. INTRODUCTION
AI
Machine learning
Representation learning
Deep learning
Example:
Knowledge
bases
Example:
Logistic
regression
Example:
Shallow
autoencoders
Example:
MLPs
Figure 1.4: A Venn diagram showing how deep learning is a kind of representation learn-
ing, which is in turn a kind of machine learning, which is used for many but not all
approaches to AI. Each section of the Venn diagram includes an example of an AI tech-
nology.
9

### Page 23

CHAPTER 1. INTRODUCTION
Figure 1.5: Flow-charts showing how the diﬀerent parts of an AI system relate to each
other within diﬀerent AI disciplines. Shaded boxes indicate components that are able to
learn from data.
10

### Page 24

CHAPTER 1. INTRODUCTION
a variety of readers.
Part 1 introduces basic mathematical tools and machine
learning concepts. Part 2 describes the most established deep learning algorithms
that are essentially solved technologies. Part 3 describes more speculative ideas
that are widely believed to be important for future research in deep learning.
Readers should feel free to skip parts that are not relevant given their interests
or background. Readers familiar with linear algebra, probability, and fundamental
machine learning concepts can skip part 1, for example, while readers who just
want to implement a working system need not read beyond part 2.
We do assume that all readers come from a computer science background. We
assume familiarity with programming, a basic understanding of computational
performance issues, complexity theory, introductory level calculus and some of
the terminology of graph theory.
1.2
Historical Trends in Deep Learning
It is easiest to understand deep learning with some historical context. Rather
than providing a detailed history of deep learning, we identify a few key trends:
• Deep learning has had a long and rich history, but has gone by many names
reﬂecting diﬀerent philosophical viewpoints, and has waxed and waned in
popularity.
• Deep learning has become more useful as the amount of available training
data has increased.
• Deep learning models have grown in size over time as computer hardware
and software infrastructure for deep learning has improved.
• Deep learning has solved increasingly complicated applications with increas-
ing accuracy over time.
1.2.1
The Many Names and Changing Fortunes of Neural Net-
works
We expect that many readers of this book have heard of deep learning as an
exciting new technology, and are surprised to see a mention of “history” in a
book about an emerging ﬁeld. In fact, deep learning has a long and rich history.
Deep learning only appears to be new, because it was relatively unpopular for
several years preceding its current popularity, and because it has gone through
many diﬀerent names. While the term “deep learning” is relatively new, the ﬁeld
dates back to the 1950s. The ﬁeld has been rebranded many times, reﬂecting the
inﬂuence of diﬀerent researchers and diﬀerent perspectives.
11

### Page 25

CHAPTER 1. INTRODUCTION
A comprehensive history of deep learning is beyond the scope of this peda-
gogical textbook. However, some basic context is useful for understanding deep
learning. Broadly speaking, there have been three waves of development of deep
learning: deep learning known as cybernetics in the 1940s-1960s, deep learning
known as connectionism in the 1980s-1990s, and the current resurgence under the
name deep learning beginning in 2006. See Figure 1.6 for a basic timeline.
Figure 1.6: The three historical waves of artiﬁcial neural nets research, starting with
cybernetics in the 1940-1960’s, with the perceptron (Rosenblatt, 1958) to train a
single neuron, then the connectionist approach of the 1980-1995 period, with back-
propagation (Rumelhart et al., 1986a) to train a neural network with one or two hidden
layers, and the current wave, deep learning, started around 2006 (Hinton et al., 2006;
Bengio et al., 2007a; Ranzato et al., 2007a), which allows us to train very deep networks.
Some of the earliest learning algorithms we recognize today were intended
to be computational models of biological learning, i.e. models of how learning
happens or could happen in the brain. As a result, one of the names that deep
learning has gone by is artiﬁcial neural networks (ANNs).
The corresponding
perspective on deep learning models is that they are engineered systems inspired
by the biological brain (whether the human brain or the brain of another ani-
mal). The neural perspective on deep learning is motivated by two main ideas.
One idea is that the brain provides a proof by example that intelligent behavior
is possible, and a conceptually straightforward path to building intelligence is to
reverse engineer the computational principles behind the brain and duplicate its
functionality. Another perspective is that it would be deeply interesting to under-
stand the brain and the principles that underlie human intelligence, so machine
learning models that shed light on these basic scientiﬁc questions are useful apart
from their ability to solve engineering applications.
12

### Page 26

CHAPTER 1. INTRODUCTION
The modern term “deep learning” goes beyond the neuroscientiﬁc perspective
on the current breed of machine learning models. It appeals to a more general
principle of learning multiple levels of composition, which can be applied in ma-
chine learning frameworks that are not necessarily neurally inspired.
The earliest predecessors of modern deep learning were simple linear models
motivated from a neuroscientiﬁc perspective.
These models were designed to
take a set of n input values x1, . . . , xn and associate them with an output y.
These models would learn a set of weights w1, . . . , wn and compute their output
f(x, w) = x1w1 + · · · + xnw n. This ﬁrst wave of neural networks research was
known as cybernetics (see Fig. 1.6).
The McCulloch-Pitts Neuron (McCulloch and Pitts, 1943) was an early model
of brain function. This linear model could recognize two diﬀerent categories of
inputs by testing whether f(x, w) is positive or negative. Of course, for the model
to correspond to the desired deﬁnition of the categories, the weights needed to be
set correctly. These weights could be set by the human operator. In the 1950s,
the perceptron (Rosenblatt, 1958, 1962) became the ﬁrst model that could learn
the weights deﬁning the categories given examples of inputs from each category.
The Adaptive Linear Element (ADALINE), which dates from about the same
time, simply returned the value of f(x) itself to predict a real number (Widrow
and Hoﬀ, 1960), and could also learn to predict these numbers from data.
These simple learning algorithms greatly aﬀected the modern landscape of ma-
chine learning. The training algorithm used to adapt the weights of the ADALINE
was a special case of an algorithm called stochastic gradient descent. Slightly mod-
iﬁed versions of the stochastic gradient descent algorithm remain the dominant
training algorithms for deep learning models today.
Models based on the f(x, w) used by the perceptron and ADALINE are called
linear models. These models remain some of the most widely used machine learn-
ing models, though in many cases they are trained in diﬀerent ways than the
original models were trained.
Linear models have many limitations. Most famously, they cannot learn the
XOR function, where f([0, 1], w) = 1 and f([1, 0], w) = 1 but f([1, 1], w) = 0
and f([0, 0], w) = 0. Critics who observed these ﬂaws in linear models caused
a backlash against biologically inspired learning in general (Minsky and Papert,
1969). This is the ﬁrst dip in the popularity of neural networks in our broad
timeline (Fig. 1.6).
Today, neuroscience is regarded as an important source of inspiration for deep
learning researchers, but it is no longer the predominant guide for the ﬁeld.
The main reason for the diminished role of neuroscience in deep learning
research today is that we simply do not have enough information about the brain
to use it as a guide. To obtain a deep understanding of the actual algorithms
13

### Page 27

CHAPTER 1. INTRODUCTION
used by the brain, we would need to be able to monitor the activity of (at the
very least) thousands of interconnected neurons simultaneously. Because we are
not able to do this, we are far from understanding even some of the most simple
and well-studied parts of the brain (Olshausen and Field, 2005).
Neuroscience has given us a reason to hope that a single deep learning algo-
rithm can solve many diﬀerent tasks. Neuroscientists have found that ferrets can
learn to “see” with the auditory processing region of their brain if their brains
are rewired to send visual signals to that area (Von Melchner et al., 2000). This
suggests that much of the mammalian brain might use a single algorithm to solve
most of the diﬀerent tasks that the brain solves. Before this hypothesis, machine
learning research was more fragmented, with diﬀerent communities of researchers
studying natural language processing, vision, motion planning and speech recog-
nition. Today, these application communities are still separate, but it is common
for deep learning research groups to study many or even all of these application
areas simultaneously.
We are able to draw some rough guidelines from neuroscience. The basic idea
of having many computational units that become intelligent only via their inter-
actions with each other is inspired by the brain. The Neocognitron (Fukushima,
1980) introduced a powerful model architecture for processing images that was
inspired by the structure of the mammalian visual system and later became the
basis for the modern convolutional network (LeCun et al., 1998b), as we will see
in Chapter 9.10. Most neural networks today are based on a model neuron called
the rectiﬁed linear unit. These units were developed from a variety of viewpoints,
with (Nair and Hinton, 2010b) and Glorot et al. (2011a) citing neuroscience as an
inﬂuence, and Jarrett et al. (2009a) citing more engineering-oriented inﬂuences.
While neuroscience is an important source of inspiration, it need not be taken
as a rigid guide. We know that actual neurons compute very diﬀerent functions
than modern rectiﬁed linear units, but greater neural realism has not yet found
a machine learning value or interpretation. Also, while neuroscience has success-
fully inspired several neural network architectures, we do not yet know enough
about biological learning for neuroscience to oﬀer much guidance for the learning
algorithms we use to train these architectures.
Media accounts often emphasize the similarity of deep learning to the brain.
While it is true that deep learning researchers are more likely to cite the brain
as an inﬂuence than researchers working in other machine learning ﬁelds such
as kernel machines or Bayesian statistics, one should not view deep learning as
an attempt to simulate the brain. Modern deep learning draws inspiration from
many ﬁelds, especially applied math fundamentals like linear algebra, probabil-
ity, information theory, and numerical optimization. While some deep learning
researchers cite neuroscience as an important inﬂuence, others are not concerned
14

### Page 28

CHAPTER 1. INTRODUCTION
with neuroscience at all.
It is worth noting that the eﬀort to understand how the brain works on an
algorithmic level is alive and well. This endeavor is primarily known as “compu-
tational neuroscience” and is a separate ﬁeld of study from deep learning. It is
common for researchers to move back and forth between both ﬁelds. The ﬁeld
of deep learning is primarily concerned with how to build computer systems that
are able to successfully solve tasks requiring intelligence, while the ﬁeld of compu-
tational neuroscience is primarily concerned with building more accurate models
of how the brain actually works.
In the 1980s, the second wave of neural network research emerged in great part
via a movement called connectionism or parallel distributed processing (Rumelhart
et al., 1986d). Connectionism arose in the context of cognitive science. Cognitive
science is an interdisciplinary approach to understanding the mind, combining
multiple diﬀerent levels of analysis. During the early 1980s, most cognitive sci-
entists studied models of symbolic reasoning. Despite their popularity, symbolic
models were diﬃcult to explain in terms of how the brain could actually imple-
ment them using neurons. The connectionists began to study models of cognition
that could actually be grounded in neural implementations, reviving many ideas
dating back to the work of psychologist Donald Hebb in the 1940s (Hebb, 1949).
The central idea in connectionism is that a large number of simple compu-
tational units can achieve intelligent behavior when networked together. This
insight applies equally to neurons in biological nervous systems and to hidden
units in computational models.
Several key concepts arose during the connectionism movement of the 1980s
that remain central to today’s deep learning.
One of these concepts is that of distributed representation. This is the idea that
each input to a system should be represented by many features, and each feature
should be involved in the representation of many possible inputs. For example,
suppose we have a vision system that can recognize cars, trucks, and birds and
these objects can each be red, green, or blue. One way of representing these inputs
would be to have a separate neuron or hidden unit that activates for each of the
nine possible combinations: red truck, red car, red bird, green truck, and so on.
This requires nine diﬀerent neurons, and each neuron must independently learn
the concept of color and object identity. One way to improve on this situation is
to use a distributed representation, with three neurons describing the color and
three neurons describing the object identity. This requires only six neurons total
instead of nine, and the neuron describing redness is able to learn about redness
from images of cars, trucks and birds, not only from images of one speciﬁc category
of objects. The concept of distributed representation is central to this book, and
will be described in greater detail in Chapter 16.
15

### Page 29

CHAPTER 1. INTRODUCTION
Another major accomplishment of the connectionist movement was the suc-
cessful use of back-propagation to train deep neural networks with internal repre-
sentations and the popularization of the back-propagation algorithm (Rumelhart
et al., 1986a; LeCun, 1987). This algorithm has waxed and waned in popularity
but as of this writing is currently the dominant approach to training deep models.
The second wave of neural networks research lasted until the mid-1990s. At
that point, the popularity of neural networks declined again. This was in part due
to a negative reaction to the failure of neural networks (and AI research in general)
to fulﬁll excessive promises made by a variety of people seeking investment in
neural network-based ventures, but also due to improvements in other ﬁelds of
machine learning: kernel machines (Boser et al., 1992; Cortes and Vapnik, 1995;
Sch¨olkopf et al., 1999) and graphical models (Jordan, 1998).
Kernel machines enjoy many nice theoretical guarantees. In particular, train-
ing a kernel machine is a convex optimization problem (this will be explained in
more detail in Chapter 4) which means that the training process can be guar-
anteed to ﬁnd the optimal model eﬃciently. This made kernel machines very
amenable to software implementations that “just work” without much need for
the human operator to understand the underlying ideas. Soon, most machine
learning applications consisted of manually designing good features to provide to
a kernel machine for each diﬀerent application area.
During this time, neural networks continued to obtain impressive performance
on some tasks (LeCun et al., 1998c; Bengio et al., 2001a). The Canadian Institute
for Advanced Research (CIFAR) helped to keep neural networks research alive
via its Neural Computation and Adaptive Perception research initiative. This
program united machine research groups led by Geoﬀrey Hinton at University of
Toronto, Yoshua Bengio at University of Montreal, and Yann LeCun at New York
University. It had a multi-disciplinary nature that also included neuroscientists
and experts in human and computer vision.
At this point in time, deep networks were generally believed to be very diﬃcult
to train. We now know that algorithms that have existed since the 1980s work
quite well, but this was not apparent circa 2006. The issue is perhaps simply that
these algorithms were too computationally costly to allow much experimentation
with the hardware available at the time.
The third wave of neural networks research began with a breakthrough in
2006. Geoﬀrey Hinton showed that a kind of neural network called a deep be-
lief network could be eﬃciently trained using a strategy called greedy layer-wise
pretraining (Hinton et al., 2006), which will be described in more detail in Chap-
ter 16.1. The other CIFAR-aﬃliated research groups quickly showed that the
same strategy could be used to train many other kinds of deep networks (Bengio
et al., 2007a; Ranzato et al., 2007a) and systematically helped to improve gen-
16

### Page 30

CHAPTER 1. INTRODUCTION
eralization on test examples. This wave of neural networks research popularized
the use of the term deep learning to emphasize that researchers were now able to
train deeper neural networks than had been possible before, and to emphasize the
theoretical importance of depth (Bengio and LeCun, 2007a; Delalleau and Ben-
gio, 2011; Pascanu et al., 2014a; Montufar et al., 2014). Deep neural networks
displaced kernel machines with manually designed features for several important
application areas during this time—in part because the time and memory cost
of training a kernel machine is quadratic in the size of the dataset, and datasets
grew to be large enough for this cost to outweigh the beneﬁts of convex optimiza-
tion. This third wave of popularity of neural networks continues to the time of
this writing, though the focus of deep learning research has changed dramatically
within the time of this wave. The third wave began with a focus on new unsuper-
vised learning techniques and the ability of deep models to generalize well from
small datasets, but today there is more interest in much older supervised learning
algorithms and the ability of deep models to leverage large labeled datasets.
1.2.2
Increasing Dataset Sizes
One may wonder why deep learning has only recently become recognized as a
crucial technology if it has existed since the 1950s. Deep learning has been suc-
cessfully used in commercial applications since the 1990s, but was often regarded
as being more of an art than a technology and something that only an expert could
use, until recently. It is true that some skill is required to get good performance
from a deep learning algorithm.
Fortunately, the amount of skill required re-
duces as the amount of training data increases. The learning algorithms reaching
human performance on complex tasks today are nearly identical to the learning
algorithms that struggled to solve toy problems in the 1980s, though the models
we train with these algorithms have undergone changes that simplify the train-
ing of very deep architectures.
The most important new development is that
today we can provide these algorithms with the resources they need to succeed.
Fig. 1.7 shows how the size of benchmark datasets has increased remarkably over
time. This trend is driven by the increasing digitization of society. As more and
more of our activities take place on computers, more and 
