%macro mean_encoding(dataset,var,target);
  proc sql;
    create table mean_table as
    select distinct(&var) as gr, round(mean(&target),00.1) As mean_encode
    from &dataset
    group by gr;

    create table new as 
    select d.* , m.mean_encode
    from &dataset as d
    left join mean_table as m
      on &var=m.gr;
  quit;
%mend;

* Example of Mean Encoding
* %mean_encoding(sashelp.cars,origin,msrp);
