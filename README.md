# Bayesian model selection in synthetic biology: factor levels and observation functions

Here the scripts used to generate, analyse and visualise the data presented in the paper are made available. 

The use of the scripts requires the RStan Package, available at the link: 
https://cran.r-project.org/web/packages/rstan/index.html 

The data is organised in the following subfolders:

-	**Inference:**
    -	ODE_Model1.stan, stan statistical model script with Model 1 (Lugagne et.al.) from the paper used to perform Bayesian Inference of the experimental data from [1].
    -	ODE_Model2.stan, stan statistical model script with Model 2 (Intermediate) from the paper used to perform Bayesian Inference of the experimental data from [1].
    -	ODE_Model3.stan, stan statistical model script with Model 3 (New) from the paper used to perform Bayesian Inference of the experimental data from [1].
    - MultiExtractExp.R, script designed to access the experimental data and experimental schemes from [1] to generate an appropriate list  of objects to be passed to the stan model to perform the inference. The csv files are generated using the script DataExtraction.m.
    -	DataExtraction.m, script to extract the desired experimental data and experimental profiles from [1]. 
    -	masterRun.R, script to perform inference through RStan using the designed model ODE_Model.stan and the list of data extracted from MultiExtractExp.R. The script allows performing inference on single datasets in series or on the combined set. 
    -	masterRunOptim.R, script designed as the masterRun.R script but including an initial optimisation process for the initialisation of the 4 MCMC chains used in the inference. 
  
-	**PriorDefinition:**
      - ExtractingInitialPriorsLugagneLog.mat, matlab script to compute the mean and standard deviation of our priors (10 lognormal and 4 normal distributions) based on the results of the fit obtained in [1].

-   **Predictions&Analysis**
      - ODE_Model1_Function.stan, stan script containing the proposed ODE system and the implementation of the event-based representation of the inputs to simulate the response to a selected input (processed with the function MultiExtractExp.R). This Script is for Model 1 (Lugagne et.al.).
      - ODE_Model2_Function.stan, stan script containing the proposed ODE system and the implementation of the event-based representation of the inputs to simulate the response to a selected input (processed with the function MultiExtractExp.R). This Script is for Model 2 (Intermediate).
      - ODE_Model3_Function.stan, stan script containing the proposed ODE system and the implementation of the event-based representation of the inputs to simulate the response to a selected input (processed with the function MultiExtractExp.R). This Script is for Model 3 (New).
      -	PostPredCheckSimulM1.R, function to simulate the ODEs for a determined experimental profile selected using all the MCMC samples from a stanfit object result selected and save the results in CSV format. This Script is for Model 1 (Lugagne et.al.).
      -	PostPredCheckSimulM2.R, function to simulate the ODEs for a determined experimental profile selected using all the MCMC samples from a stanfit object result selected and save the results in CSV format. This Script is for Model 2 (Intermediate).
      -	PostPredCheckSimulM3.R, function to simulate the ODEs for a determined experimental profile selected using all the MCMC samples from a stanfit object result selected and save the results in CSV format. This Script is for Model 3 (New).
      -	ConfidenceIntervalPlotsFunctionM1.R, function to extract all the MCMC samples from a stanfit object and simulate a determined experimental profile, obtaining the 95% confidence intervals and saving the plot of the simulation for checks. This Script is for Model 1 (Lugagne et.al.).
      -	ConfidenceIntervalPlotsFunctionM2.R, function to extract all the MCMC samples from a stanfit object and simulate a determined experimental profile, obtaining the 95% confidence intervals and saving the plot of the simulation for checks. This Script is for Model 2 (Intermediate).
      -	ConfidenceIntervalPlotsFunctionM3.R, function to extract all the MCMC samples from a stanfit object and simulate a determined experimental profile, obtaining the 95% confidence intervals and saving the plot of the simulation for checks. This Script is for Model 3 (New).
      

-	**ModelComparison:**
      -	GaussianMixtureCompM1.R, R script used to produce a Gaussian Mixture fit on the posteriors obtained by the Rstan inference in model 1. 
      -	GaussianMixtureCompM23.R, R script used to produce a Gaussian Mixture fit on the posteriors obtained by the Rstan inference in model 2 and 3. 
      - 
  
-	**BEDms:**
      -	ExtractReducedThetaDraws.R, R script to extract all the draws for the stanfit results on the three models and also generate separate files with only 400 randomly picked draws used for the optimisation. 
      - OptimDataFilesGenerator.R, R script used to generate the necessary CSV files to simulate the three different models according to any input setting obtained during the optimisation. 
      - OptimisationScriptsSingle, directory containing all the Jupyter Notebooks used to perform Bayesian Experimental Design for model selection with the default settings from the BayesianOptimisation package (kernel = Matern2.5, aqf = ucb) for experiments of 2,4,6 and 8 steps considering as a utility function the Bhattacharyya distance from RFP, GFP, the average between the two or the product between the two. 
      - OptimisationScriptsVariants, directory containing the Jupyter Notebooks used o perform Bayesian Experimental Design for model selection with varying kernels for the Gaussian Processes and/or different acquisition functions with different parameters for 4 step experiments. It also contains the script to perform Dynamic Bayesian Experimental Design for model selection on an 8 step experiment where the optimisation is performed every 2 steps. 
      - Packages, PDF file containing the packages used for Gaussian Process Regression and Bayesian Optimisation and where to access them. 
      
-	**Images:**
      -	Optimisation_Results_Plots, Jupyter Notebook containing the code used to generate the figures related to Optimisation results (Fig.3 and Fig.4)
  

To run the scripts plase place all the scripts and data required in the R or Jupyter Notebook working directory. 

The data associated with these scripts can be found at:

https://datasync.ed.ac.uk/index.php/s/mHC9MIiaks15gMc (pwd: BDMS_FOSBE2019_SI_Data)

References:

[1] Jean-Baptiste Lugagne, Sebastián Sosa Carrillo, Melanie Kirch, Agnes Köhler, Gregory Batt & Pascal Hersen, 2017. Balancing a genetic toggle switch by real-time feedback control and periodic forcing. Nature Communications, 8 (1671), pp. 1-7.


