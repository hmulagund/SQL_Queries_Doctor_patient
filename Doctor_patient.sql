-- Create Doctor table

create table doctor
(doc_id varchar(4) primary key,
fname varchar(20),
lname varchar(20),
specialty varchar(20),
phone number(10)
);


insert into doctor values('d1','arun','patel','ortho',9675093453);
insert into doctor values('d2','tim','patil','general',9674560453);
insert into doctor values('d3','abhay','sharma','heart',9675993453);

select * from doctor;
--------------------------------------------------------------------------------
-- Create patient table

create table patient
(pat_id varchar(4) primary key,
fname varchar(20),
lname varchar(20),
ins_comp varchar(20),
phone number(10)
);


insert into patient values('p1','akul','shankar','y',9148752347);

insert into patient values('p2','aman','shetty','y',9512896317);

insert into patient values('p3','ajay','shetty','n',9987321564);

insert into patient values('p4','akshay','pandit','y',9112255889);

insert into patient values('p5','adi','shankar','n',9177788821);

-------------------------------------------------------------------------------------------------
-- Create Case table

create table case
(admission_date date,
pat_id varchar(4) references patient(pat_id),
doc_id varchar(4) references doctor(doc_id),
diagnosis varchar(40),
fee FLOAT,
constraint con_cpk primary key(admission_date,pat_id)
);

insert into case values('10-jun-16','p1','d1','fracture',500);
insert into case values('03-may-16','p2','d1','bone cancer',789.99);
insert into case values('17-apr-16','p2','d2','fever',345);
insert into case values('28-oct-15','p3','d2','cough',999);
insert into case values('10-jun-16','p3','d1','fracture',120);
insert into case values('1-jan-16','p3','d1','bone cramp',654);
insert into case values('11-sep-15','p3','d3','heart attack',675);
insert into case values('30-nov-15','p4','d3','heart hole',900);
insert into case values('10-nov-15','p4','d3','angioplasty',854);
insert into case values('1-jan-16','p5','d3','angiogram',789);

insert into case values('18-jan-23','p5','d3','angiogram',789);

select * from doctor;
select * from patient;
select * from case;

commit;

------------------------------------------------------------------------------------------------------------
--1. Find all the patients who are treated in the first week of this month.

select concat(fname,lname) as Name from patient p inner join case c
on p.pat_id = c.pat_id and to_char(admission_date, 'w-mm-yy') = to_char(trunc(date '2016-05-03','mm'),'w-mm-yy');

-----------------------------------------------------------------------------------------------------------------
--2. Find all the doctors who have more than 3 admissions today
select concat(fname,lname),count(c.pat_id) as num_of_patient from doctor d inner join case c
on c.doc_id= d.doc_id 
where to_char(c.admission_date,'dd-mm-yy') = to_char(sysdate,'dd-mm-yy')
group by concat(fname,lname)
having count(c.pat_id) >= 1;

--------------------------------------------------------------------------------------------------------------------------------
--3.Find the patient name (first,last) who got admitted today where the doctor is ‘TIM’

select  concat(p.fname,p.lname) as Nme from patient p,case c,doctor d
where p.pat_id = c.pat_id and c.doc_id= d.doc_id and d.fname='tim' 
and to_char(c.admission_date, 'dd-mm-yy') = to_char(date '2016-04-17','dd-mm-yy') ;

---------------------------------------------------------------------------------------------------------------------------
--4. Find the Doctors whose phone numbers were not update (phone number is null)
select concat(fname,lname) as Doctor_name from doctor
where phone is   null;

-------------------------------------------------------------------------------------------------------
--5. Display the doctors whose specialty is same as Doctor ‘TIM’

select concat(fname,lname) as Doctor_name from doctor
where specialty in (select specialty from doctor where fname ='tim');

-----------------------------------------------------------------------------------------
--6. Find out the number of cases monthly wise for the current year

select to_char(admission_date,'month-yyyy'),count(*) from case
where to_char(admission_date,'yy') =15
group by to_char(admission_date,'month-yyyy');


-----------------------------------------------------------------------------------------------
--7. Display the doctors who don’t have any cases registered this week

select concat(fname,lname) as Doctor_name from doctor
where doc_id  not in (select doc_id from case where to_char(admission_date,'w-mm-yy') = to_char(sysdate,'w-mm-yy') );


--------------------------------------------------------------------------------------------
--8. Display Doctor Name, Patient Name, Diagnosis for all the admissions which happened on 1st of Jan this year

select concat(d.fname,d.lname)as Doctor_name, concat(p.fname,p.lname) as Patient_nmae, c.diagnosis from patient p,case c,doctor d
where p.pat_id = c.pat_id and c.doc_id= d.doc_id and to_char(admission_date,'dd-mm-yy') = to_char(trunc(sysdate,'yy'),'dd-mm-yy');

---------------------------------------------------------------------------------------------------
--9. Display Doctor Name, patient count based on the cases registered in the hospital.

select concat(d.fname,d.lname)as Doctor_name,count(c.pat_id) as no_of_patients from case c,doctor d
where c.doc_id= d.doc_id 
group by concat(d.fname,d.lname);

--------------------------------------------------------------------------------------------------------------------------
--10. Display the Patient_name, phone, insurance company, insurance code (first 3 characters of insurance company)

select fname || ' ' || lname as Patient_name, phone,ins_comp,substr(fname,1,3) from patient;

----------------------------------------------------------------------------------------------------------------------
--11. Create a view which gives the doctors whose specialty is ‘ORTHO’ and call it as ortho_doctors

create view ortho_doctors as
select * from doctor
where specialty ='ortho';

select * from ortho_doctors;
select sysdate
