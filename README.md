# Random-Forest-Stata
Random Forest, type classification and regression.

Random Forest with Stata
Random Forest is a machine learning algorithm for prediction. For more insights on the method -> Leo Breiman. Random forests. Machine Learning, 45(1):5-32, 2001.
These scripts represented my first application of Random Forests for two clinical questions regarding the pattern of prescriptions of antipsychotics drugs for people suffering from schizophrenia.
The first was a classification problem, with dichotomous outcome: antipsychotic polytherapy (APP) Yes/No.
The second was a regression problem, with continuous outcome: overall antipsychotic dose (expressed in chlorpromazine equivalent milligrams). For this problem, in order to increase the symmetry of the distribution of the outcome variable, it was transformed in log-scale, therefore the actual outcome was the ln(DOSE).
With Random Forest predictors of APP and of overall antipsychotic dose were determined.
The scripts were written using Stata 15 (StataCorp LLC, College Station, Texas 77845 USA). These are intended for my own education and to give me a chance to explore the models.
Students and researchers interested in approaching Machine Learning techniques, may find Random Forests very stimulating to implement in biomedical researches, and these codes quite simple to apply if you are using Stata.
Expert programmers may provide valuable input and suggestions for helping to improve the codes and the outputs.

-----
Usage:
First, to start the model training process, the entire dataset was arranged in a random order sort. Then, the dataset was split into two subsets: e.g. N=500; 50% (1/250 observations) used for training and 50% (251/500 observations) used for testing (validation). You should decide the ratio of splitting: in small datasets a 50-50 split may reduce the size of the training data too much; for large dataset a 50-50 split is not problematic.
I keep my outcome variables in the .do files, you should replace it with yours (remember: dichotomous outcomes require classification type Random Forest; continuous outcomes require regression type Random Forest).
x1 x2 x3 xn are the predictors you want to assess using the Random Forest model.
a and b, c and d are the number of iterations and of variables randomly selected at each split, for classification and regression Random Forest respectively. You should replace them with number values, following my comments in the scripts.

-----
If you have found these codes useful for your researches and wish to support, please cite this repository. 
