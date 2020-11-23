set seed 201807
gen u=uniform()
sort u, stable
gen logDOSE = ln(DOSE)
gen out_of_bag_error = .
gen validation_error = .
gen iter1 = .
local j = 0 
forvalues i = 10(5)500 {
local j = `j' + 1
rforest logDOSE x1 x2 x3 xn in 1/250, type(reg) iter(`i') numvars(1)
qui replace iter1 = `i' in `j'
qui replace out_of_bag_error = `e(OOB_Error)' in `j'
predict p in 251/500
qui replace validation_error = `e(RMSE)' in `j'
drop p
}
label var out_of_bag_error "Out of Bag Error"
label var validation_error "Validation RMSE"
label var iter1 "Iterations"
scatter out_of_bag_error iter1 , mcolor(blue) msize(tiny) || scatter validation_error iter1 , mcolor(red) msize(tiny)
*From the scatter plot you should choose the number of iterations at which Out of Bag Error stabilizes; let's call this number c.
gen oob_error = .
gen val_error = .
gen nvars = .
local j =  0
forvalues i = 1(1)20 {
local j = `j' + 1
rforest logDOSE x1 x2 x3 xn in 1/250, type(reg) iter(300) numvars(`i')
qui replace nvars = `i' in `j'
qui replace oob_error = `e(OOB_Error)' in `j'
predict p in 251/500
qui replace val_error = `e(RMSE)' in `j' 
drop p
}
label var oob_error "Out of Bag Error"
label var nvars "Number of Variables Randomly Selected at Each Split"
label var val_error "Validation RMSE"
scatter oob_error nvars , mcolor(blue) msize(tiny) || scatter val_error nvars , mcolor(red) msize(tiny)
*From the scatter plot you should choose the number of variables selected at each split which make the lowest Validation Error; let's call this number d.
*Final model: train:test=50:50; number of iterations=c, number of vaibles randomly selected at each spit=d.
rforest logDOSE x1 x2 x3 xn in 1/250, type(reg) iter(c) numvars(d)
ereturn list OOB_Error
predict prDOSE in 251/500
ereturn list RMSE
*Variable importance plot
matrix importance = e(importance)
svmat importance 
gen importid = ""
local mynames : rownames importance 
local k : word count `mynames'
if `k' >_N {
set obs `k'
}
forvalues i = 1(1)`k' {
local aword : word `i' of `mynames'
local alabel : variable label `aword'
if ("`alabel'"!= "") qui replace importid = "`alabel'" in `i'
else qui replace importid = "`aword'" in `i'
}
graph hbar (mean) importance , over (importid , sort(1) label (labsize(2))) ytitle (Importance)
