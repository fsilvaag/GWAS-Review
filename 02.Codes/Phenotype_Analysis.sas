PROC OPTIONS OPTION=MEMSIZE;
RUN;

proc datasets lib=work kill;
quit;
proc catalog catalog=work.sasmacr kill force;
quit;


filename csvFile url "https://raw.githubusercontent.com/fsilvaag/GWAS-Review/master/01.%20Databases/Plant_Height_Phenotype.csv" termstr=crlf;

proc import 
datafile=csvFile 
out=work.pheno
replace 
dbms=csv; 
guessingrows = 3000;
run;




data d;
set pheno(where = (Plant_Height ne . ));
run;
quit;

ods graphics on;
ods output 
covparms = covparms
tests3 = tests3
lsmeans = lsmeans
solutionf = blues
solutionr = blups
asycov = asycov
g = g
fitstatistics = bic
iterhistory = iteration
covb = covb;


proc mixed data = d noitprint noclprint covtest asycov plots = residualpanel(unpack) lognote;
class location Replication range pass pedigree Population;
model Plant_Height = location Replication(location) Population / noint solution residual outp = resids ddfm = KR covb;
random location*Population pedigree*v(Population) location*pedigree*v(Population) pass(location*Replication) range(location*Replication) / s g;
lsmeans Population location / e corr cov;
run;
quit;

/*
%let path =C:\Users\Aleja\OneDrive\Escritorio\Paper 2. Association Analysis\2. ANALYSIS\Phenotypic_data_analysis\2.best_model\sas\V3.0\;

%macro t(table);

proc export
data = work.&table
outfile = "&path.&table" 
dbms = xlsx
replace;

%mend;
 
%t(covparms);
%t(tests3);
%t(lsmeans);
%t(blues);
%t(blups);
%t(asycov);
%t(g);
%t(covb);
%t(resids);
%t(iteration);
%t(bic);
run;
quit;

*/
