
select * from logs 
where action = 'INSERT patient'
order by created_at desc
limit 1;




select amount from medicine where id = 5; -- 15






select paid, abscent 
from schedule
order by id desc
limit 1;


select * 
from purchase
where service_id = 2 and patient_id = 2
order by date_time desc
limit 1;

insert into medic_prescriptions (patient_id, medicine_id, medic_username, dosage, instructions, start_date, end_date)
values (1, 1, 'medic', '1 таблетка 2 раза в день', 'перед едой', current_date, current_date + interval '7 days');

select id, patient_id, medicine_id, medic_username, dosage, start_date, end_date
from medic_prescriptions
order by id desc
limit 1;
