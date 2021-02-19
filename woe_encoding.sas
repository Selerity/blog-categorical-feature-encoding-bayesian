%macro woe_encoding(dataset,var,target);
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
    me_by_bp=mean_encode/bad_prob;
    woe_encode=log(me_by_bp);
  run;

  proc sql noprint;
    create table new as 
    select d.* , s.woe_encode 
    from &dataset as d
    left join stats as s
    on &var=s.gr;
  quit;
%mend;

* Example of weight of evidence encoding
* %woe_encoding(try, drivetrain ,bin);
