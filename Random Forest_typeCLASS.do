set seed 201807
gen u=uniform()
sort u, stable
gen out_of_bag_error = .
gen validation_error = .
gen iter1 = .
local j = 0
forvalues i = 10(5)1000 {
local j = `j' + 1
rforest APP x1 x2 x3 xn in 1/250, type(class) iter(`i') numvars(1)
qui replace iter1 = `i' in `j'
qui replace out_of_bag_error = `e(OOB_Error)' in `j'
predict p in 251/500
qui replace validation_error = `e(error_rate)' in `j'
drop p
}
label var out_of_bag_error "Out of Bag Error"
label var iter1 "Iterations"
label var validation_error "Validation Error"
scatter out_of_bag_error iter1 , mcolor (blue) msize (tiny) || scatter validation_error iter1 , mcolor (red) msize (tiny)
*From the scatter plot you should choose the number of iterations at which Out of Bag Error stabilizes; let's call this number a.
gen oob_error = .
gen nvars = .
gen val_error = .
local j = 0
forvalues i = 1(1)20 {
local j = `j' + 1
rforest APP x1 x2 x3 xn in 1/250, type(class) iter(a) numvars(`i')
qui replace nvars = `i' in `j'
qui replace oob_error = `e(OOB_Error)' in `j'
predict p in 251/500
qui replace val_error = `e(error_rate)' in `j'
drop p 
}
label var oob_error "Out of Bag Error"
label var val_error "Validation Error"
label var nvars "Number of Variables Randomly Selected at Each Split"
scatter oob_error nvars , mcolor(blue) msize(tiny) || scatter val_error nvars , mcolor (red) msize(tiny)
*From the scatter plot you should choose the number of variables selected at each split which make the lowest Validation Error; let's call this number b.
*Final model: train:test=50:50; number of iterations=a, number of vaibles randomly selected at each spit=b
rforest APP x1 x2 x3 xn in 1/250, type(class) iter(a) numvars(b)
di e(OOB_Error)
predict prAPP in 251/500
di e(error_rate)
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
if ("`alabel'"!="") qui replace importid = "`alabel'" in `i'
else qui replace importid = "`aword'" in `i'
}
graph hbar (mean) importance , over(importid, sort(1) label(labsize(2))) ytitle (Importance)
