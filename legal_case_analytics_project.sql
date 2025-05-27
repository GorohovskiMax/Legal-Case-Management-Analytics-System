-- Legal Case Management Analytics System
-- This SQL file defines a relational schema for a fictional law firm and includes:
-- 1. Table creation with constraints
-- 2. Business logic (trigger for automated billing calculation)
-- 3. Sample data inserts
-- 4. Analytical SQL queries simulating business insights

--1
create table client(
	cname varchar(20),
	address varchar(50),
	phone char(11),
	email varchar(50),
	primary key(cname)
);

create table lawyer(
	lname varchar(20),
	specialization varchar(20),
	ophone char(11),
	email varchar(50),
	office int,
	hbilling int,
	partner date default null,
	primary key(lname)
);

create table cases(
	cid int,
	title varchar(20),
	description varchar(150),
	status date default null,
	lname varchar(20),
	cname varchar(20),
	primary key(cid),
	foreign key(lname) references lawyer,
	foreign key(cname) references client
);

create table documents(
	cid int,
	dname varchar(20),
	dtype varchar(20),
	primary key(cid,dname)
);

create table billing(
	bdate date,
	lname varchar(20),
	cid int,
	hours int,
	description varchar(150),
	amount int,
	primary key(bdate,lname),
	foreign key(cid) references cases
);

create table onCase(
	cid int,
	lname varchar(20),
	role varchar(20),
	primary key(cid,lname)
);

--2
create or replace function trigf1() returns trigger as $$
begin
	new.amount := new.hours * (select hbilling from lawyer where lname = 
	new.lname);

return new;
end;
$$language plpgsql;

create trigger T1
before insert or update of hours on billing
	for each row
	execute function trigf1();

--3
insert into client values 
	('eric', '123 Main St', '555-1111','eric@client.com'),
	('emily', '456 oak rd', '555-2222','emily@client.com'),
	('robert', '789 elm st', '555-6789', 'robert@client.com'),
	('amy', '654 pine ave', '555-5555', 'amy@client.com'),
	('lucas', '987 oak rd', '555-4321', 'lucas@client.com'),
	('maria', '321 maple st', '555-8765', 'maria@client.com'),
	('john', '123 Oak St', '555-9999', 'john@client.com'),
	('lisa', '321 Maple Ave', '555-4444', 'lisa@client.com'),
	('leroy','591 Aloha Ave','555-9601','leroy@client.com'),
	('maxim','777 Bond Street', '555-9911', 'maxim@client.com'),
	('elise', '777 Bond Street', '555-9922', 'elise@client.com');

insert into lawyer values
	('jessica', 'environmental', '555-0123', 'jessica@lawfirm.com', 1, 750, TO_DATE('5.10.2020', 'DD.MM.YY')), 
	('sarah','employment','555-2345','sarah@lawfirm.com', 5, 150,NULL),
	('david','family','555-5555','david@lawfirm.com',12,200,NULL),
	('paul', 'criminal', '555-6780', 'paul@lawfirm.com', 3, 500, NULL),
	('nina', 'intellectual prop', '555-6781', 'nina@lawfirm.com', 2, 650, TO_DATE('10.12.21', 'DD.MM.YY')),
	('sam', 'environmental', '555-0561', 'sam@lawfirm.com',9,450,NULL);

insert into cases values
	(1, 'eric vs. all', 'civil dispute over contract',NULL,'sarah','eric'),
	(2,'divorce','family law case of divorce',NULL,'david','robert'),
	(3,'marriage','contract before marriage',NULL, 'david', 'eric'),
	(4, 'emily child custody', 'case of child custody',NULL, 'david', 'emily'),
	(5, 'emily vs. plastic', 'environmental case',NULL, 'jessica', 'emily'),
	(6, 'amy vs. gas', 'environmental case',NULL, 'jessica', 'amy'),
	(7, 'eric new job', 'contract for new job',NULL, 'sarah', 'eric'),
	(8, 'emily vs. NASA', 'environmental case',NULL, 'jessica', 'emily'),
	(9, 'lucas vs. john', 'dispute over property', NULL, 'paul', 'lucas'),
	(10, 'maria vs. company', 'intellectual property case', NULL, 'nina', 'maria'),
	(11, 'amy vs. contractor', 'civil dispute over contract', NULL, 'jessica', 'amy'),
	(12, 'emily vs. landlord', 'dispute over lease', NULL, 'sarah', 'emily'),
	(13, 'john vs. corporation', 'dispute over contract', TO_DATE('15.6.23', 'DD.MM.YY'), 'david', 'john'),
	(14, 'maria vs. university', 'dispute over tuition', TO_DATE('10.7.23', 'DD.MM.YY'), 'nina', 'maria'),
	(15, 'eric vs. neighbor', 'property dispute', TO_DATE('1.5.24', 'DD.MM.YY'), 'sarah', 'eric'),
	(16, 'lisa vs. company', 'dispute over contract', NULL, 'sarah', 'lisa'),
	(17, 'leroy vs. business', 'contract dispute', NULL, 'sarah', 'leroy'),
	(18,'emily vs leroy', 'fight over property', NULL, 'jessica', 'emily'),
	(19, 'eric vs. Starlink', 'privacy issues', null, 'david','eric'),
	(20,'john vs. all','contract issue',null,'david','john'),
	(21, 'maxim vs government', 'law dispute', null, 'nina','maxim'),
	(22, 'elise vs gas','environmental case',NULL,'sam','elise');

insert into documents values
	(1, 'doc1.pdf', 'legal document'),
	(1, 'doc2.docx', 'legal document'),
	(2, 'doc1.ppt', 'legal document'),
	(9, 'doc3.pdf', 'legal document'),
	(10, 'doc4.docx', 'legal document'),
	(11, 'doc5.pdf', 'legal document'),
	(12, 'doc6.docx', 'legal document');

insert into billing values 
	(TO_DATE('25.7.24','DD.MM.YY'), 'jessica', 5 , 3 , 'something', NULL),
	(TO_DATE('27.7.24','DD.MM.YY'), 'jessica', 5 , 3 , 'something important', NULL),
	(TO_DATE('26.7.24','DD.MM.YY'), 'sarah', 5, 4, 'something else',NULL),
	(TO_DATE('1.8.24','DD.MM.YY'), 'sarah', 1 , 2 , 'court appearance', NULL),
	(TO_DATE('20.7.24','DD.MM.YY'), 'sarah', 1 , 6 , 'court appearance', NULL),
	(TO_DATE('2.8.24','DD.MM.YY'), 'david', 1 , 2, 'something', NULL),
	(TO_DATE('30.7.24','DD.MM.YY'), 'david', 2, 5, 'client meeting', NULL),
	(TO_DATE('30.7.24','DD.MM.YY'),'jessica',2, 3, 'court appearance', NULL),
	(TO_DATE('5.8.24','DD.MM.YY'), 'paul', 9, 3, 'initial consultation', NULL),
	(TO_DATE('6.8.24','DD.MM.YY'), 'nina', 10, 4, 'preparation work', NULL),
	(TO_DATE('3.8.24','DD.MM.YY'), 'jessica', 11, 5, 'court appearance', NULL),
	(TO_DATE('4.8.24','DD.MM.YY'), 'sarah', 12, 2, 'legal advice', NULL),
	(TO_DATE('1.6.23', 'DD.MM.YY'), 'david', 13, 5, 'legal consultation', NULL),
	(TO_DATE('5.6.23', 'DD.MM.YY'), 'nina', 14, 3, 'court appearance', NULL),
	(TO_DATE('2.5.24', 'DD.MM.YY'), 'sarah', 15, 4, 'legal advice', NULL),
	(TO_DATE('5.8.24', 'DD.MM.YY'), 'sarah', 16, 2, 'legal consultation', NULL),
	(TO_DATE('13.8.24', 'DD.MM.YY'), 'david', 16, 3, 'court appearance', NULL),
	(TO_DATE('10.8.24', 'DD.MM.YY'), 'sarah', 17, 4, 'contract review', NULL),
	(TO_DATE('6.8.24', 'DD.MM.YY'), 'david', 1, 3, 'court appearance', NULL),
	(TO_DATE('12.8.24','DD.MM.YY'),'david',3,7,'contract review',NULL);

insert into onCase values 
	(5, 'sarah', 'associate'), 
	(5,'david','associate'),
	(2, 'jessica', 'associate'),
	(9, 'nina', 'associate'),
	(10, 'jessica', 'associate'),
	(11, 'david', 'associate'),
	(12, 'paul', 'associate'),
	(10, 'paul', 'associate'),
	(14, 'sarah', 'associate'),
	(15, 'david', 'associate'),
	(16, 'sarah', 'associate'),
	(16, 'david', 'associate'), 
    (1, 'sam', 'associate'),
    (2, 'sam', 'associate'),
    (3, 'sam', 'associate'),
    (4, 'sam', 'associate'),
    (5, 'sam', 'associate'),
    (6, 'sam', 'associate'),
    (7, 'sam', 'associate'),
    (8, 'sam', 'associate'),
    (9, 'sam', 'associate'),
    (10, 'sam', 'associate'),
    (11, 'sam', 'associate'),
    (12, 'sam', 'associate'),
    (13, 'sam', 'associate'),
    (14, 'sam', 'associate'),
    (15, 'sam', 'associate'),
    (16, 'sam', 'associate'),
    (17, 'sam', 'associate'),
    (18, 'sam', 'associate'),
    (19, 'sam', 'associate'),
    (20, 'sam', 'associate'),
    (21, 'sam', 'associate');


--4
select cid, title, lname , specialization
from cases natural join lawyer
where status is null
;


--5
select cname
from cases 
where cname in (
	select cname
	from cases
	group by cname
	having count(cid) = 1	
) and cid not in(select cid from onCase);


--6
select distinct C1.cname, C1.cid, C2.cid
from cases as C1 join cases as C2
	on C1.cname = C2.cname and 
	   C1.lname = C2.lname and
	   C1.cid < C2.cid
join lawyer as L1 on 
	C1.lname = L1.lname
where C1.status is NULL and C2.status is NULL
	and L1.partner is not null
	;


--7
select B1.lname,C1.cid,sum(B1.amount) as total_amount
from lawyer natural join billing as B1 join cases as C1 
	on B1.cid = C1.cid
where date_part('month',B1.bdate) = date_part('month',current_date) and
	date_part('year', B1.bdate) = date_part('year',current_date)
group by B1.lname,C1.cid
;

--8
select L1.lname,L1.specialization
from lawyer as L1
where (
	select sum(hours)
	from billing
	where lname = L1.lname 
) > 7 
and (select count(distinct B2.cid) from billing as B2 
	where B2.lname = L1.lname) > 
(select count(distinct cid) from cases where lname = 'jessica');

--9
with lawyer_count as
(
	select C1.cid, count(O1.lname) + 1 as num_lawyers
	from cases as C1 join onCase as O1 on
		C1.cid = O1.cid
	where C1.status is null
	and C1.lname in(select lname from lawyer where partner is null)
	and O1.lname in(select lname from lawyer where partner is null)
	group by C1.cid
)
select cid,num_lawyers
from lawyer_count
where num_lawyers = 
(
	select max(num_lawyers)
	from lawyer_count
);

--10
select L1.lname
from lawyer as L1
where L1.partner is null 
and (select count(cid) from cases where lname = L1.lname) = 1
and not exists(
	select C1.cid
	from cases as C1
	where C1.lname != L1.lname and not exists(
		select O1.cid
		from onCase as O1
		where O1.cid = C1.cid and O1.lname = L1.lname
	)
);
