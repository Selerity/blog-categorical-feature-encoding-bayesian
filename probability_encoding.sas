%macro probability_encoding(dataset,var,target);
  proc sql noprint;
    create table stats as
    select distinct(&var) as gr, round(mean(&target),00.1) as mean_encode 
    from &dataset
    group by gr;
  quit;

  data stats;
    set stats;
    bad_prob=1-mean_encode;
    if bad_prob=0 then bad_prob=0.0001;
    prob_encode=mean_encode/bad_prob;
  run;

  proc sql noprint;
    create table new as 
    select d.* , s.prob_encode 
    from &dataset as d
    left join stats as s
      on &var=s.gr;
  quit;
%mend;

* Example of probability ratio encoding
* %probability_encoding(sashelp.cars, drivetrain ,msrp);
