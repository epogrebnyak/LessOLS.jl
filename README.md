[![Build Status](https://travis-ci.org/epogrebnyak/LessOLS.jl.svg?branch=master)](https://travis-ci.org/epogrebnyak/LessOLS.jl)

# LessOLS.jl
Build your own econometrics package

## Our approach

Simulation is a good way to study estimator properties. In real life 
we rarely know the true data generating process and have to search for 
better model and parameter estimation procedure. In `LessOLS.jl` we catalogue 
several types of data generting processes, which depart from ideal conditions, 
and show how applying different models and estimators leads to different 
quality of parameters estimated. Quality of parameters is related to decision costs 
based on model predictions. 

## Steps

1. Define true data generating process (unknown in practice)
2. Create a sample of observations (we usually have just a single sample, not a series of samples) 
3. Propose a model and estimation procedure
4. Derive model parameters
5. Repeat sampling and derive distribution of a parameter
6. Show estimator quality 
7. Tranfsorm estimator quality to understandable decision costs


## Data structures

- `Sample` holds cross-section observations. It has `.X` and `Y.` members
- `LinearModel`  
- `Process`

## 
- `make_sample(p:Process, n::Int)` creates a sample with 
   x, y and error generation process defined by `p`

- `ols` estimation function retruns linear model 
- `r2`, `yhat`, `desc` work on liner model

