 ---------------------------------------------------------------------------------------
--- Question 1
---------------------------------------------------------------------------------------
-- Book 

---- SQL 
Select Table_catalog as SchemaName, count(distinct(Table_name)) as #Tables, count(distinct(Column_name)) as #records
from [Book].INFORMATION_SCHEMA.COLUMNS
where Table_name != 'sysdiagrams'
group by table_catalog

---- Prodedure 
go
create or alter procedure Book_SchemaInformation
as
Select Table_catalog as SchemaName, count(distinct(Table_name)) as #Tables, count(distinct(Column_name)) as #records
from [Book].INFORMATION_SCHEMA.COLUMNS
where Table_name != 'sysdiagrams'
group by table_catalog
go
exec Book_SchemaInformation

---- UDF
go
create or alter function table_list()
returns table 
as 
return
(
Select Table_catalog as SchemaName, count(distinct(Table_name)) as #Tables, count(distinct(Column_name)) as #records
from [Book].INFORMATION_SCHEMA.COLUMNS
where Table_name != 'sysdiagrams'
group by table_catalog
)
go

select * from table_list()



---------------------------------------------------------------------------------------
--- Question 2
---------------------------------------------------------------------------------------
-- Zeota
---- SQL
-- COUNT ATTRIBUTE
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_ATT 
FROM [ZeotaDB].INFORMATION_SCHEMA.COLUMNS
where Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME

-- COUNT PK
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_PK 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME

-- COUNT FK
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_FK 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME

-- COUNT CC
select CONSTRAINT_SCHEMA, count(*) as num_CC 
from [ZeotaDB].INFORMATION_SCHEMA.CHECK_CONSTRAINTS 
group by CONSTRAINT_SCHEMA

-- COUNT UQ
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_UQ 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'UNIQUE' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME

---- Procedure
-- COUNT ATTRIBUTE
go
create or alter procedure ZeotaDB_ATT
as
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_ATT 
FROM [ZeotaDB].INFORMATION_SCHEMA.COLUMNS
WHERE Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
GO

EXEC ZeotaDB_ATT

-- COUNT PK
go
create or alter procedure ZeotaDB_PK
as
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_PK 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
GO

EXEC ZeotaDB_PK

-- COUNT FK
go
create or alter procedure ZeotaDB_FK
as
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_FK 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
GO

EXEC ZeotaDB_FK

-- COUNT CC
go
create or alter procedure ZeotaDB_CC
as
select CONSTRAINT_SCHEMA, count(*) as num_CC 
from [ZeotaDB].INFORMATION_SCHEMA.CHECK_CONSTRAINTS
group by CONSTRAINT_SCHEMA
GO

EXEC ZeotaDB_CC

-- COUNT UQ
go
create or alter procedure ZeotaDB_UQ
as
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_UQ 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE CONSTRAINT_TYPE = 'UNIQUE' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
GO

EXEC ZeotaDB_UQ




---- UDF
--COUNT ATTRRIBUTE
go
create or alter function count_att ()
returns table 
as 
return
(
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_ATT 
FROM [ZeotaDB].INFORMATION_SCHEMA.COLUMNS 
WHERE Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
)
go

select * from count_att()

--COUNT PK
go
create or alter function count_PK_UDF ()
returns table 
as 
return
(
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_PK 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
)
go

select * from count_PK_UDF()

--COUNT FK
go
create or alter function count_FK_UDF ()
returns table 
as 
return
(
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_FK 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
)
go

select * from count_FK_UDF()

--count CC
go
create or alter function count_CC_UDF ()
returns table 
as 
return
(
select CONSTRAINT_SCHEMA, count(*) as num_CC 
from [ZeotaDB].INFORMATION_SCHEMA.CHECK_CONSTRAINTS
group by CONSTRAINT_SCHEMA
)
go

select * from count_CC_UDF()

--count UQ
go
create or alter function count_UQ_UDF ()
returns table 
as 
return
(
SELECT TABLE_CATALOG, TABLE_NAME, COUNT(*) AS NUM_UQ 
FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'UNIQUE' AND Table_name != 'sysdiagrams'
GROUP BY TABLE_CATALOG,TABLE_NAME
)
go

select * from count_UQ_UDF()

--2 combined
go
create procedure list_count_all as
select a.TABLE_CATALOG, a.TABLE_NAME, NUM_ATT, NUM_PK, NUM_FK, num_CC, NUM_UQ
from
count_att() a left join count_PK_UDF() pk on a.TABLE_NAME = pk.TABLE_NAME
left join count_FK_UDF() fk on fk.TABLE_NAME = a.TABLE_NAME
left join count_UQ_UDF() uq on uq.TABLE_NAME = a.TABLE_NAME
left join count_CC_UDF() cc on cc.CONSTRAINT_SCHEMA = a.TABLE_CATALOG

exec list_count_all

go
create or alter function count_all_detail ()
returns table 
as 
return
(
select a.TABLE_CATALOG, a.TABLE_NAME, NUM_ATT, NUM_PK, NUM_FK, num_CC, NUM_UQ
from
count_att() a left join count_PK_UDF() pk on a.TABLE_NAME = pk.TABLE_NAME
left join count_FK_UDF() fk on fk.TABLE_NAME = a.TABLE_NAME
left join count_UQ_UDF() uq on uq.TABLE_NAME = a.TABLE_NAME
left join count_CC_UDF() cc on cc.CONSTRAINT_SCHEMA = a.TABLE_CATALOG
)
go

select * from count_all_detail()



---------------------------------------------------------------------------------------
--- Question 3
---------------------------------------------------------------------------------------
-- PROP
---- SQL
select c.table_catalog as SchemaName, c.table_name, c.column_name, tc.constraint_name,
tc.constraint_type from [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
inner join [PROP2].INFORMATION_SCHEMA.COLUMNS c on c.TABLE_CATALOG = tc.CONSTRAINT_CATALOG
group by c.TABLE_CATALOG, c.TABLE_NAME, c.COLUMN_NAME, tc.CONSTRAINT_NAME, tc.CONSTRAINT_TYPE

---- Procedure
go
create or alter procedure Schema_Table_Information
as
select c.table_catalog as SchemaName, c.table_name, c.column_name, tc.constraint_name,
tc.constraint_type from [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
inner join [PROP2].INFORMATION_SCHEMA.COLUMNS c on c.TABLE_CATALOG = tc.CONSTRAINT_CATALOG
group by c.TABLE_CATALOG, c.TABLE_NAME, c.COLUMN_NAME, tc.CONSTRAINT_NAME, tc.CONSTRAINT_TYPE
go

exec Schema_Table_Information

---- UDF
go
create or alter function use_case3()
returns table 
as 
return
(
select c.table_catalog as SchemaName, c.table_name, c.column_name, tc.constraint_name,
tc.constraint_type from [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
inner join [PROP2].INFORMATION_SCHEMA.COLUMNS c on c.TABLE_CATALOG = tc.CONSTRAINT_CATALOG
group by c.TABLE_CATALOG, c.TABLE_NAME, c.COLUMN_NAME, tc.CONSTRAINT_NAME, tc.CONSTRAINT_TYPE
)
go

select * from use_case3()

---------------------------------------------------------------------------------------
--- Question 4
---------------------------------------------------------------------------------------
-- Book 
---- SQL
SELECT distinct TABLE_NAME FROM [book].INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'



SELECT CONSTRAINT_CATALOG, TABLE_NAME, CONSTRAINT_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'







---- Procedure

go
create or alter procedure PK_WOUT_FK_IDX
as

SELECT CONSTRAINT_CATALOG, TABLE_NAME, CONSTRAINT_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
go

EXEC PK_WOUT_FK_IDX



SELECT * FROM [book].INFORMATION_SCHEMA.COLUMNS



go
create or alter procedure WITH_PK_WOUT_PK_IDX
as
SELECT distinct TABLE_NAME, COLUMN_NAME FROM [book].INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
go 

EXEC WITH_PK_WOUT_PK_IDX

---- UDF
go
create or alter function use_case4()
returns table 
as 
return
(
SELECT CONSTRAINT_CATALOG, TABLE_NAME, CONSTRAINT_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND TABLE_NAME not in (SELECT TABLE_NAME FROM [book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
)
go

select * from use_case4()


---------------------------------------------------------------------------------------
--- Question 5
---------------------------------------------------------------------------------------
-- SP
---- SQL
select table_catalog, rank () over (order by count (IS_NULLABLE)) NN_Rank, count(IS_NULLABLE) CountNN
from [SP].information_schema.COLUMNS
where IS_NULLABLE = 'NO' AND Table_name != 'sysdiagrams'
group by table_catalog;

---- Procedure
go
create or alter procedure RANK_NN
as
select table_catalog, rank () over (order by count (IS_NULLABLE)) NN_Rank, count(IS_NULLABLE) CountNN
from [SP].information_schema.COLUMNS
where IS_NULLABLE = 'NO' AND Table_name != 'sysdiagrams'
group by table_catalog;
go 

EXEC RANK_NN


---- UDF
go
create or alter function use_case5()
returns table 
as 
return
(
select table_catalog, rank () over (order by count (IS_NULLABLE)) NN_Rank, count(IS_NULLABLE) CountNN
from [SP].information_schema.COLUMNS
where IS_NULLABLE = 'NO' AND Table_name != 'sysdiagrams'
group by table_catalog
)
go

select * from use_case5()


---------------------------------------------------------------------------------------
--- Question 6
---------------------------------------------------------------------------------------
-------------------------------------------
-- Zeota
---- SQL
SELECT distinct TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME not in (SELECT TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY')
AND Table_name != 'sysdiagrams'

---- Procedure
go
create or alter procedure WOUT_PK
as
SELECT distinct TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME not in (SELECT TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY')
AND Table_name != 'sysdiagrams'
GO

EXEC WOUT_PK

---- UDF
go
create or alter function table_no_pk ()
returns table 
as 
return
(
SELECT distinct TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME not in (SELECT TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'PRIMARY KEY')
AND Table_name != 'sysdiagrams'
)
go

select * from table_no_pk()


---------------------------------------------------------------------------------------
--- Question 7
---------------------------------------------------------------------------------------
-- Zeota
---- SQL
SELECT DISTINCT TABLE_NAME FROM [ZeotaDB].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'



---- Procedure
go
create or alter procedure WOUT_IDX
as
SELECT DISTINCT TABLE_NAME FROM [ZeotaDB].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
GO

EXEC WOUT_IDX



---- UDF
go
create or alter function table_no_idx ()
returns table 
as 
return
(
SELECT DISTINCT TABLE_NAME FROM [ZeotaDB].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
)
go

select * from table_no_idx()


---------------------------------------------------------------------------------------
--- Question 8
---------------------------------------------------------------------------------------
-- PROP2
---- SQL
select CONSTRAINT_CATALOG, TABLE_NAME from [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND Table_name != 'sysdiagrams'

---- Procedure
go
create or alter procedure WITH_PK_WOUT_FK
as
select CONSTRAINT_CATALOG, TABLE_NAME from [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND Table_name != 'sysdiagrams'
GO

EXEC WITH_PK_WOUT_FK

---- UDF
go
create or alter function count_PK_no_FK ()
returns table 
as 
return
(
select CONSTRAINT_CATALOG, TABLE_NAME from [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [PROP2].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY')
AND Table_name != 'sysdiagrams'
)
go

select * from count_PK_no_FK()


---------------------------------------------------------------------------------------
--- Question 9
---------------------------------------------------------------------------------------
-- Book 
---- SQL
select CONSTRAINT_CATALOG, TABLE_NAME from [Book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [Book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'

---- Procedure
go
create or alter procedure WITH_PK_WOUT_IDX
as
select CONSTRAINT_CATALOG, TABLE_NAME from [Book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [Book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
GO

EXEC WITH_PK_WOUT_IDX

---- UDF
go
create or alter function count_PK_no_IDX ()
returns table 
as 
return
(
select CONSTRAINT_CATALOG, TABLE_NAME from [Book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME NOT IN
(SELECT TABLE_NAME FROM [Book].INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'IDX')
AND Table_name != 'sysdiagrams'
)
go

select * from count_PK_no_IDX()

---------------------------------------------------------------------------------------
--- Question 10
---------------------------------------------------------------------------------------
-- Zeota
---- SQL
select CONSTRAINT_CATALOG, TABLE_NAME from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'CHECK' 
AND Table_name != 'sysdiagrams'

---- Procedure
go
create or alter procedure WITH_CC
as
select CONSTRAINT_CATALOG, TABLE_NAME from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'CHECK' 
AND Table_name != 'sysdiagrams'
GO

EXEC WITH_CC

---- UDF
go
create or alter function count_CC ()
returns table 
as 
return
(
select CONSTRAINT_CATALOG, TABLE_NAME from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'CHECK' 
AND Table_name != 'sysdiagrams'
)
go

select * from count_CC()
---------------------------------------------------------------------------------------
--- Question 11
---------------------------------------------------------------------------------------
-- Zeota
---- SQL
select CONSTRAINT_CATALOG, TABLE_NAME from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'PGM' 
AND Table_name != 'sysdiagrams'

select CONSTRAINT_CATALOG, TABLE_NAME,CONSTRAINT_TYPE from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS


---- Procedure
go
create or alter procedure WITH_CC
as
select CONSTRAINT_CATALOG, TABLE_NAME from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'CHECK' 
AND Table_name != 'sysdiagrams'
GO

EXEC WITH_CC

---- UDF
go
create or alter function count_CC ()
returns table 
as 
return
(
select CONSTRAINT_CATALOG, TABLE_NAME from [ZeotaDB].INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'CHECK' 
AND Table_name != 'sysdiagrams'
)
go

select * from count_CC()










---------------------------------------------------------------------------------------
--- Question 12
---------------------------------------------------------------------------------------
-- PROP2
---- SQL





---- Procedure






---- UDF









---------------------------------------------------------------------------------------
--- Question 13
---------------------------------------------------------------------------------------
-- SP
---- SQL





---- Procedure






---- UDF















---------------------------------------------------------------------------------------
--- Question 14
---------------------------------------------------------------------------------------
-- Book 
---- SQL





---- Procedure






---- UDF









---------------------------------------------------------------------------------------
--- Question 15
---------------------------------------------------------------------------------------
-- PROP2
---- SQL





---- Procedure






---- UDF










---------------------------------------------------------------------------------------
--- Question 16
---------------------------------------------------------------------------------------
-- SP
---- SQL





---- Procedure






---- UDF















---------------------------------------------------------------------------------------
--- Question 17
---------------------------------------------------------------------------------------
-- Zeota
---- SQL





---- Procedure






---- UDF

















