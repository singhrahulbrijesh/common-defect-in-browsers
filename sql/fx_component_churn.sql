create table fx_component_churn as select p.component_id as component_id, sum( (add+remove) ) as churn from fx_path_component p, fx_git_revision_final r where p.commit=r.commit and p.path=r.path group by p.component_id;

\copy (select c.component_name, ch.component_id, ch.churn from fx_component_churn ch, fx_component c where c.component_id=ch.component_id) TO 'fx_component_churn.csv' DELIMITER ',' CSV HEADER;
