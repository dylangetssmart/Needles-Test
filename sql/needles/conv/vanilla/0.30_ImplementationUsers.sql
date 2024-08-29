-- USE TestNeedles

if exists (select * from sys.objects where name='implementation_users' and type='U')
begin
    drop table implementation_users
end
GO

CREATE TABLE implementation_users
(
    StaffCode varchar(50)
    ,SAloginID varchar(20)
    ,Prefix varchar(10)
    ,SAFirst varchar(50)
    ,SAMiddle varchar(5)
    ,SALast varchar(50)
    ,suffix varchar(15)
    ,Active varchar(1)
    ,visible varchar(1)
)
GO

-- INSERT INTO implementation_users (StaffCode, SAloginID, Prefix, SAFirst, SAMiddle, SALast, suffix, Active, Visible)

-- ds 2024-05-31 // Modified to insert data into the implementation_users table from the dbo.staff table
INSERT INTO implementation_users
(
    StaffCode
    ,SAloginID
    ,Prefix
    ,SAFirst
    ,SAMiddle
    ,SALast
    ,suffix
)
SELECT 
    staff_code                          as StaffCode
    ,staff_code                         as SAloginID
	,prefix                             as Prefix
	,dbo.get_firstword(s.full_name)     as SAFirst
    ,''                                 as SAMiddle
    ,dbo.get_lastword(s.full_name)      as SALast
    ,suffix                             as suffix
FROM [TestNeedles].[dbo].[staff] s
GO

--SELECT '@PORTAL', '@PORTAL', '', 'Mary', '', 'McCabe', '', 'N', 'Y' UNION
--SELECT 'ABRIL', 'ABRIL', 'Ms.', 'Abril', '', 'Garcia', '', 'N', '' UNION
--SELECT 'ACEDENO', 'ACEDENO', '', 'Ashley', '', 'Cedeno', '', 'Y', 'Y' UNION
--SELECT 'ADMIN', 'aadmin', '', '', '', '', '', 'Y', '' UNION
--SELECT 'ADRIENNE', 'ADRIENNE', '', 'Adrienne', '', 'Trent', '', 'N', '' UNION
--SELECT 'AFL', 'AFL', '', 'Analytics', '', 'for Lawyers', '', 'N', 'N' UNION
--SELECT 'AHI', 'AHI', '', 'After', '', 'Hours Intake', '', 'N', '' UNION
--SELECT 'ALEX', 'ALEX', 'Ms.', 'Alexandria', '', 'Harris', '', 'N', '' UNION
--SELECT 'ALISSA', 'ALISSA', 'Ms.', 'Alissa', '', 'Chapman', '', 'N', '' UNION
--SELECT 'ALLYSA', 'ALLYSA', 'Ms.', 'Allysa', '', 'Pollard', '', 'Y', 'Y' UNION
--SELECT 'ALVINA', 'ALVINA', '', 'Alvina', '', 'Jones', '', 'N', '' UNION
--SELECT 'ALYSSA', 'ALYSSA', 'Ms.', 'Alyssa', '', 'Fetterolf', 'Esq.', 'Y', 'Y' UNION
--SELECT 'AMANDA', 'AMANDA', 'Ms.', 'Amanda', '', 'Rhodes', '', 'N', '' UNION
--SELECT 'AMELLIA', 'AMELLIA', 'Ms.', 'Amellia', '', 'Boyer', '', 'N', '' UNION
--SELECT 'AMY', 'AMY', 'Ms.', 'Amy', 'L.', 'Whitacre', '', 'N', '' UNION
--SELECT 'ANDI', 'ANDI', 'Ms.', 'Andi', '', 'Hayes', '', 'N', '' UNION
--SELECT 'ANDREA', 'ANDREA', '', 'Andrea', '', 'Underhill', '', 'N', '' UNION
--SELECT 'ANDREI', 'ANDREI', '', 'Andrei', '', 'Lipan', '', 'N', '' UNION
--SELECT 'ANDREW', 'ANDREW', '', 'Andrew', '', 'Lucchetti', '', 'N', '' UNION
--SELECT 'ANDREWT', 'ANDREWT', '', 'Andrew', '', 'Thompson', '', 'Y', 'Y' UNION
--SELECT 'ANGELA', 'ANGELA', 'Ms.', 'Angela', '', 'Smith', '', 'N', '' UNION
--SELECT 'ANN', 'ANN', '', 'Ann', '', 'Teconchuk', '', 'N', '' UNION
--SELECT 'ANNA', 'ANNA', '', 'Anna', '', 'Judy', '', 'N', '' UNION
--SELECT 'ANNAK', 'ANNAK', '', 'Anna', '', 'Kortze', '', 'Y', 'Y' UNION
--SELECT 'ANNAM', 'ANNAM', '', 'Anna', '', 'McDonald', '', 'N', '' UNION
--SELECT 'ANOOSHA', 'ANOOSHA', 'Ms.', 'Anoosha', '', 'Lamica', '', 'N', '' UNION
--SELECT 'ANTONIO', 'ANTONIO', 'Mr.', 'Antonio', '', 'Figueroa', '', 'N', '' UNION
--SELECT 'APARKER', 'APARKER', 'Mrs.', 'Andrea', 'E.A.', 'Parker', 'Esq.', 'N', '' UNION
--SELECT 'APRIL', 'APRIL', '', 'April', '', 'Sullivan', '', 'Y', 'Y' UNION
--SELECT 'ARC1', 'ARC1', '', 'ARC1', '', 'ARC1', '', 'Y', 'Y' UNION
--SELECT 'ARC2', 'ARC2', '', 'ARC2', '', 'ARC2', '', 'Y', 'Y' UNION
--SELECT 'ARCCC', 'ARCCC', '', 'ARC', '', 'Corey', '', 'Y', 'Y' UNION
--SELECT 'AREIL', 'AREIL', 'Ms.', 'Areil', '', 'Robinson', '', 'Y', 'Y' UNION
--SELECT 'ARIAN', 'ARIAN', 'Ms.', 'Arian', '', 'Fisher', '', 'N', '' UNION
--SELECT 'ARIEL', 'ARIEL', '', 'Ariel', '', 'Pettis', '', 'N', '' UNION
--SELECT 'ARZOO', 'ARZOO', '', 'Arzoo', '', 'Jiwani', '', 'N', '' UNION
--SELECT 'ASHARA', 'ASHARA', '', 'Ashara', '', 'Meade', '', 'N', '' UNION
--SELECT 'ASHKIRA', 'ASHKIRA', 'Ms.', 'Ashkira', '', 'Mohamud', '', 'N', '' UNION
--SELECT 'ASHLEY', 'ASHLEY', '', 'Ashley', 'N.', 'Miller', '', 'N', '' UNION
--SELECT 'ASIA', 'ASIA', '', 'Asia', '', 'Prentiss', '', 'Y', 'Y' UNION
--SELECT 'AU', 'AU', '', 'AU', '', 'AU', '', 'N', '' UNION
--SELECT 'AWADE', 'AWADE', 'Mr.', 'Austin', '', 'Wade', '', 'Y', 'Y' UNION
--SELECT 'AWILLIAM', 'AWILLIAM', '', 'Allison', '', 'Williams', '', 'N', '' UNION
--SELECT 'BASIL', 'BASIL', '', 'Basil', '', 'Surgent', '', 'N', '' UNION
--SELECT 'BEN', 'BEN', '', 'Ben', '', 'Culpepper', '', 'N', '' UNION
--SELECT 'BENJAMIN', 'BENJAMIN', '', 'Benjamin', 'M.', 'Andrews', 'Esq.', 'N', '' UNION
--SELECT 'BERNROB', 'BERNROB', '', 'Bernadette', '', 'Robinson', '', 'N', '' UNION
--SELECT 'BETTY', 'BETTY', 'Ms.', 'Elizabeth', 'A.', 'Griffin', '', 'N', '' UNION
--SELECT 'BGALINDO', 'BGALINDO', '', 'Brandon', '', 'Galindo', '', 'Y', 'Y' UNION
--SELECT 'BHALLO', 'BHALLO', '', 'Bob', '', 'Halloran', '', 'N', '' UNION
--SELECT 'BILL', 'BILL', 'Mr.', 'William', 'E.', 'Spruill', '', 'N', '' UNION
--SELECT 'BILLCARR', 'BILLCARR', 'Mr.', 'William', 'C.', 'Carr', 'Esq.', 'N', '' UNION
--SELECT 'BLAIR', 'BLAIR', '', 'Blair', '', 'Millican', '', 'N', '' UNION
--SELECT 'BLAIRM', 'BLAIRM', 'Ms.', 'Blair', 'M.', 'Mathiax', 'Esq.', 'Y', 'Y' UNION
--SELECT 'BLAIRS', 'BLAIRS', '', 'Blair', '', 'Starrett', 'R.N.', 'Y', 'Y' UNION
--SELECT 'BOBH', 'BOBH', '', 'Bob', '', 'Halloran', '', 'N', '' UNION
--SELECT 'BONNIE', 'BONNIE', 'Ms.', 'Bonnie', 'H.', 'Netherland', '', 'N', '' UNION
--SELECT 'BRANDON', 'BRANDON', 'Mr.', 'Brandon', '', 'Menzie', '', 'N', '' UNION
--SELECT 'BREANNA', 'BREANNA', 'Ms.', 'Breanna', 'N.', 'West', '', 'N', '' UNION
--SELECT 'BRENDA', 'BRENDA', 'Ms.', 'Brenda', '', 'Harbison', 'Esq.', 'N', '' UNION
--SELECT 'BRIAN', 'BRIAN', 'Mr.', 'Brian', '', 'Dunn', '', 'N', '' UNION
--SELECT 'BRIANNA', 'BRIANNA', 'Ms.', 'Brianna', '', 'Pleasants', '', 'N', '' UNION
--SELECT 'BRIANNAR', 'BRIANNAR', '', 'Brianna', '', 'Reyes', '', 'Y', 'Y' UNION
--SELECT 'BRIANNE', 'BRIANNE', '', 'Brianne', '', 'Coughlin', '', 'N', '' UNION
--SELECT 'BRITTANY', 'BRITTANY', 'Ms.', 'Brittany', '', 'Greene', '', 'N', '' UNION
--SELECT 'BRODY', 'BRODY', 'Mr.', 'Brody', 'H.', 'Reid', 'Esq.', 'N', '' UNION
--SELECT 'BRYN', 'BRYN', '', 'Bryn', '', 'Swartz', 'Esq.', 'N', '' UNION
--SELECT 'CAITLIN', 'CAITLIN', '', 'Caitlin', '', 'Beckner', '', 'N', '' UNION
--SELECT 'CALEB', 'CALEB', '', 'Caleb', '', 'Myers', '', 'N', '' UNION
--SELECT 'CALVIN', 'CALVIN', 'Mr.', 'Calvin', '', 'Bartelle', 'Jr.', 'N', '' UNION
--SELECT 'CANDACE', 'CANDACE', '', 'Candace', '', 'Slingerland', '', 'N', '' UNION
--SELECT 'CANDICE', 'CANDICE', 'Ms.', 'Candice', '', 'Arnold', '', 'N', '' UNION
--SELECT 'CAROL', 'CAROL', '', 'Carol', '', 'Goodman', '', 'N', '' UNION
--SELECT 'CAROLINA', 'CAROLINA', '', 'Carolina', '', 'Arango', '', 'Y', 'Y' UNION
--SELECT 'CAROLYN', 'CAROLYN', '', 'Carolyn', '', 'Higginbotham', '', 'N', '' UNION
--SELECT 'CB', 'CB', '', 'CB', '', 'CB', '', 'N', '' UNION
--SELECT 'CBD/GEOF', 'CBD/GEOF', '', 'CBD', '', 'Geoff', '', 'N', '' UNION
--SELECT 'CBD/GREG', 'CBD/GREG', '', 'CBD', '', 'Greg', '', 'N', '' UNION
--SELECT 'CCOSNER', 'CCOSNER', 'Ms.', 'Cheryl', '', 'Cosner', '', 'N', '' UNION
--SELECT 'CELESTE', 'CELESTE', '', 'Celeste', '', 'Buccola', '', 'N', '' UNION
--SELECT 'CFAGAN', 'CFAGAN', '', 'Christian', '', 'Fagan', '', 'N', '' UNION
--SELECT 'CH', 'CH', '', 'CH', '', 'CH', '', 'N', '' UNION
--SELECT 'CHAD', 'CHAD', '', 'Chad ', '', 'Dudley', '', 'N', '' UNION
--SELECT 'CHAGG', 'CHAGG', '', 'Charlsley', '', 'Haggerty', '', 'Y', 'Y' UNION
--SELECT 'CHAMP', 'CHAMP', 'Mr.', 'Chris', '', 'Thomas', '', 'N', '' UNION
--SELECT 'CHANTAL', 'CHANTAL', '', 'Chantal', '', 'Towles', '', 'N', '' UNION
--SELECT 'CHANTAL2', 'CHANTAL2', '', 'Chantal', '', 'Towles2', '', 'N', '' UNION
--SELECT 'CHANTAL3', 'CHANTAL3', '', 'Chantal', '', 'Towles3', '', 'N', '' UNION
--SELECT 'CHARNS', 'CHARNS', 'Ms.', 'Christine', 'H.', 'Milburn', '', 'N', '' UNION
--SELECT 'CHELSEA', 'CHELSEA', 'Ms.', 'Chelsea', 'M.', 'Witte', '', 'N', '' UNION
--SELECT 'CHELSIE', 'CHELSIE', '', 'Chelsie', '', 'Jones', '', 'Y', 'Y' UNION
--SELECT 'CHERYL', 'CHERYL', '', 'Cheryl', '', 'Henderson', '', 'N', '' UNION
--SELECT 'CHERYLL', 'CReid', 'Ms.', 'Cheryll', '', 'Reid', '', 'Y', 'Y' UNION
--SELECT 'CHRIS', 'CHRIS', '', 'Chris', '', 'Booberg', '', 'N', '' UNION
--SELECT 'CHRISL', 'CHRISL', '', 'Chris', '', 'Long', '', 'N', '' UNION
--SELECT 'CHRISSY', 'CHRISSY', '', 'Chrissy', '', 'Reill', '', 'N', '' UNION
--SELECT 'CHRISTIN', 'CHRISTIN', '', 'Christine', '', 'Smith', '', 'N', '' UNION
--SELECT 'CIRCUIT', 'CIRCUIT', '', 'Circuit', '', 'Court', '', 'N', 'Y' UNION
--SELECT 'CJ', 'CJ', '', 'CJ', '', 'Advertising', '', 'N', '' UNION
--SELECT 'CKUNN', 'CKUNN', '', 'Chelsea', '', 'Kunnecke', '', 'Y', 'Y' UNION
--SELECT 'CLAUDIA', 'CLAUDIA', 'Ms.', 'Claudia', 'R.', 'Estrada', '', 'N', '' UNION
--SELECT 'CNETHER', 'CNETHER', 'Mr.', 'Chad ', '', 'Netherton', '', 'N', '' UNION
--SELECT 'COBB', 'COBB', '', 'Jeff', '', 'Blount', '', 'N', 'N' UNION
--SELECT 'CONFA', 'CONFA', '', 'Front', '', 'Conference Room', '', 'Y', 'Y' UNION
--SELECT 'CONFB', 'CONFB', '', 'Small', '', 'Conference Room', '', 'Y', 'Y' UNION
--SELECT 'CONFC', 'CONFC', '', 'Back', '', 'Conference Room', '', 'N', '' UNION
--SELECT 'CONFF', 'CONFF', '', 'Fargo', '', 'Conference Room', '', 'N', 'N' UNION
--SELECT 'CONTINA', 'CONTINA', '', 'Contina', '', 'Dennis', '', 'N', '' UNION
--SELECT 'CORT', 'CORT', '', 'Cort', '', 'Enoksen', '', 'N', '' UNION
--SELECT 'COURTNI', 'COURTNI', 'Ms.', 'Courtni', '', 'Weaver', '', 'N', '' UNION
--SELECT 'CPYLE', 'CPYLE', 'Ms.', 'Cassandra', 'R.', 'Pyle', '', 'N', '' UNION
--SELECT 'CRAIG', 'CRAIG', '', 'Craig', 'B.', 'Davis', '', 'N', '' UNION
--SELECT 'CRYSTAL', 'CRYSTAL', '', 'Crystal', '', 'Williams', '', 'N', '' UNION
--SELECT 'CTHOMAS', 'CTHOMAS', '', 'Chelsea', '', 'Thomas', '', 'Y', 'Y' UNION
--SELECT 'CTHOMP', 'CTHOMP', '', 'Caleb', '', 'Thomas', '', 'Y', 'Y' UNION
--SELECT 'CURTIS', 'Cpowell', '', 'Curtis', '', 'Powell', '', 'Y', 'Y' UNION
--SELECT 'CYNTHIA', 'CYNTHIA', '', 'Cynthia', '', 'Talley', '', 'N', '' UNION
--SELECT 'CYNTISHA', 'CYNTISHA', 'Ms.', 'Cyntisha', '', 'Stewart', '', 'Y', 'Y' UNION
--SELECT 'DAMON', 'DAMON', 'Mr.', 'Damon', 'L.', 'Pendleton', 'Esq.', 'N', '' UNION
--SELECT 'DANA', 'DANA', 'Ms.', 'Dana', '', 'Charback', 'Esq.', 'N', '' UNION
--SELECT 'DANAI', 'DANAI', 'Ms.', 'Dana', '', 'Isaacoff', '', 'N', '' UNION
--SELECT 'DANIEL', 'DANIEL', '', 'Daniel', '', 'Wilson', '', 'N', '' UNION
--SELECT 'DANIELLE', 'DANIELLE', 'Ms.', 'Danielle', '', 'King', '', 'N', '' UNION
--SELECT 'DARRIEL', 'DARRIEL', '', 'Darriel', '', 'Martinez', '', 'N', '' UNION
--SELECT 'DARRYL', 'DARRYL', 'Mr.', 'Darryl', '', 'Lee', '', 'N', '' UNION
--SELECT 'DAWN', 'DAWN', 'Ms.', 'Dawn', '', 'Medlin', '', 'N', '' UNION
--SELECT 'DAWNH', 'DAWNH', '', 'Dawn', '', 'Helms', '', 'N', '' UNION
--SELECT 'DENNIS', 'DENNIS', '', 'Dennis', '', 'Sisk', '', 'N', '' UNION
--SELECT 'DESNI', 'DESNI', '', 'Desni', '', 'Lambert', '', 'N', '' UNION
--SELECT 'DHIDALGO', 'DHIDALGO', '', 'Dinanyiris', '', 'Hidalgo', '', 'Y', 'Y' UNION
--SELECT 'DIAMOND', 'DIAMOND', '', 'Diamond', '', 'Jackson', '', 'N', '' UNION
--SELECT 'DMEHALL', 'DMEHALL', 'Ms.', 'Danielle', '', 'Mehall', 'Esq.', 'N', '' UNION
--SELECT 'DONNA', 'DONNA', '', 'Donna', '', 'Donna', '', 'N', '' UNION
--SELECT 'DONNAW', 'DONNAW', '', 'Donna', '', 'Wood', '', 'N', '' UNION
--SELECT 'DOUG', 'DOUG', '', 'Douglas', '', 'Weatherley', '', 'N', '' UNION
--SELECT 'DS', 'DS', '', 'DS', '', 'DS', '', 'N', '' UNION
--SELECT 'DTENNYSO', 'DTENNYSO', '', '', '', 'Donaven', '', 'N', '' UNION
--SELECT 'DUWAYNE', 'DUWAYNE', 'Mr.', 'Duwayne', '', 'Janney', '', 'N', '' UNION
--SELECT 'DVALL', 'DVALL', '', 'Daniel', '', 'Vall-llobera', '', 'Y', 'Y' UNION
--SELECT 'EKATERIN', 'EKATERIN', 'Ms.', 'Ekaterina', '', 'Beletskaya', '', 'N', '' UNION
--SELECT 'ELIZABET', 'ELIZABET', '', 'Elizabeth', '', 'Griffin', '', 'N', '' UNION
--SELECT 'ELLEN', 'ELLEN', '', 'Ellen', '', 'Scarff', '', 'N', '' UNION
--SELECT 'ELYSE', 'ELYSE', 'Ms.', 'Elyse', 'H.', 'Stiner', 'Esq.', 'N', '' UNION
--SELECT 'EMABRY', 'EMABRY', '', 'Emily', '', 'Mabry', '', 'N', '' UNION
--SELECT 'EMILY', 'EMILY', 'Ms.', 'Emily', '', 'Horne', '', 'N', '' UNION
--SELECT 'EMILYC', 'EMILYC', '', 'Emily', '', 'Curtis', '', 'Y', 'Y' UNION
--SELECT 'EMILYF', 'EMILYF', '', 'Emily', '', 'Felenstein', '', 'N', '' UNION
--SELECT 'EMMY', 'EMMY', '', 'Emily', '', 'Smith', '', 'N', '' UNION
--SELECT 'ERICA', 'ERICA', 'Ms.', 'Erica', 'B.', 'Sledz', '', 'N', '' UNION
--SELECT 'ERIK', 'ERIK', '', 'Erik', '', 'Chavez', '', 'N', '' UNION
--SELECT 'ERIKA', 'ERIKA', '', 'Erika', '', 'Jackson', '', 'N', '' UNION
--SELECT 'ERIKS', 'ERIKS', 'Mr.', 'Erik', '', 'Skolrood', 'Esq.', 'N', '' UNION
--SELECT 'ERIN', 'ERIN', 'Ms.', 'Erin', 'E.', 'Maruskin', 'Esq.', 'N', '' UNION
--SELECT 'ESANDY', 'ESANDY', 'Ms.', 'Emily', '', 'Sandy', '', 'N', '' UNION
--SELECT 'ESUH', 'ESUH', '', 'Erik', '', 'Suh', '', 'N', '' UNION
--SELECT 'ETOCAR', 'ETOCAR', '', 'Elizabeth', '', 'Tocarchick', '', 'N', '' UNION
--SELECT 'ETOPHAM', 'ETOPHAM', 'Ms.', 'Ellen', '', 'Topham', '', 'N', '' UNION
--SELECT 'EUGENE', 'EUGENE', '', 'Eugene', '', 'Chigna', '', 'N', '' UNION
--SELECT 'EVELYN', 'EVELYN', 'Ms.', 'Evelyn ', '', 'Rivera', '', 'N', '' UNION
--SELECT 'EVELYNM', 'EVELYNM', 'Ms.', 'Evelyn', 'Y.', 'Menendez', '', 'N', '' UNION
--SELECT 'FOCUSGRP', 'FOCUSGRP', '', 'Focus', '', 'Group', '', 'N', 'Y' UNION
--SELECT 'FRANK', 'FHupfl', 'Mr.', 'Frank', 'H.', 'Hupfl', 'Esq.', 'Y', 'Y' UNION
--SELECT 'GARY', 'GARY', 'Mr.', 'Gary', '', 'Nelson', '', 'N', '' UNION
--SELECT 'GDC', 'GDC', '', 'General', '', 'Distrinct Court', '', 'N', 'Y' UNION
--SELECT 'GEOFF', 'GMcDonald', 'Mr.', 'Geoffrey', 'R.', 'McDonald', 'Esq.', 'Y', 'Y' UNION
--SELECT 'GEORGE', 'GEORGE', '', 'George', '', 'Stanley', '', 'N', '' UNION
--SELECT 'GEORGEK', 'GEORGEK', 'Mr.', 'George', 'A.', 'Kinsey', '', 'N', '' UNION
--SELECT 'GEORGEV', 'GEORGEV', 'Mr.', 'George', '', 'Vergara', 'Jr.', 'N', '' UNION
--SELECT 'GIANNI', 'GIANNI', 'Mr.', 'Gianni', '', 'Puglielli', 'Esq.', 'Y', 'Y' UNION
--SELECT 'GMA', 'GMA', '', 'GMA', '', 'GMA', '', 'N', '' UNION
--SELECT 'GR', 'GR', '', 'GR', '', 'GR', '', 'N', '' UNION
--SELECT 'GRACE', 'GRACE', '', 'Grace', '', 'Ross', '', 'N', '' UNION
--SELECT 'GREG', 'GREG', 'Mr.', 'Greg', 'O.', 'Harbison', 'Esq.', 'N', '' UNION
--SELECT 'GTROGDON', 'GTROGDON', 'Mr.', 'Gregory', 'W.', 'Trogdon', '', 'N', '' UNION
--SELECT 'HANNAH', 'HANNAH', 'Ms.', 'Hannah ', '', 'Weeks', '', 'N', '' UNION
--SELECT 'HAYLEY', 'HAYLEY', '', 'Hayley', '', 'Anderson', '', 'N', '' UNION
--SELECT 'HAZEL', 'HAZEL', '', 'Hazel', '', 'Ponce', '', 'N', '' UNION
--SELECT 'HEATHER', 'HEATHER', 'Ms.', 'Heather', '', 'Marti', '', 'N', '' UNION
--SELECT 'HEATHERF', 'HEATHERF', '', 'Heather', '', 'Fitchett', '', 'N', '' UNION
--SELECT 'INTAKE', 'INTAKE', '', 'Intake', '', 'Specialist', '', 'N', '' UNION
--SELECT 'JACKIE', 'JACKIE', 'Ms.', 'Jackie', '', 'Lopez', '', 'N', '' UNION
--SELECT 'JADA', 'JADA', 'Ms.', 'Jada', '', 'Northington', '', 'Y', 'Y' UNION
--SELECT 'JADAY', 'JADAY', '', 'Jaday', '', 'Perdomo', '', 'N', '' UNION
--SELECT 'JADE', 'JADE', '', 'Jade', '', 'Lawson', '', 'Y', 'Y' UNION
--SELECT 'JAMEA', 'JAMEA', '', 'Jamea', '', 'Bervine', '', 'N', '' UNION
--SELECT 'JAMIE', 'JAMIE', 'Ms.', 'Jamie', 'L.', 'Karek', 'Esq.', 'N', '' UNION
--SELECT 'JAMISON', 'JAMISON', 'Mr.', 'Jamison', 'D.', 'Davis', '', 'N', '' UNION
--SELECT 'JANA', 'JANA', 'Ms.', 'Jana', 'J.', 'Barnett', '', 'N', '' UNION
--SELECT 'JANE', 'JANE', '', 'Jane', 'G.', 'Taylor', '', 'N', '' UNION
--SELECT 'JANELLA', 'JANELLA', '', 'Janella', '', 'Loaiza', 'Esq.', 'N', '' UNION
--SELECT 'JANICA', 'JANICA', '', 'Janica', '', 'Gaines', '', 'N', '' UNION
--SELECT 'JARROD', 'JARROD', 'Mr.', 'Jarrod', '', 'Austin', '', 'N', '' UNION
--SELECT 'JASMINE', 'JASMINE', 'Ms.', 'Jasmine', '', 'Parks', '', 'Y', 'Y' UNION
--SELECT 'JASON', 'JASON', '', 'Jason', '', 'Guard', '', 'N', '' UNION
--SELECT 'JASONB', 'JASONB', '', 'Jason', '', 'Bruce', '', 'N', '' UNION
--SELECT 'JBOAT', 'JBOAT', 'Mr.', 'John', '', 'Boatwright', '', 'N', '' UNION
--SELECT 'JBOONE', 'JBOONE', '', 'Jordan', '', 'Boone', '', 'Y', 'Y' UNION
--SELECT 'JDUGGAN', 'JDUGGAN', 'Ms.', 'Jennifer', '', 'Duggan', '', 'N', '' UNION
--SELECT 'JEANETTE', 'JEANETTE', 'Ms.', 'Jeanette', '', 'Weinberg', '', 'N', '' UNION
--SELECT 'JEFFREY', 'JEFFREY', 'Mr.', 'Jeffrey', '', 'Fitzgerald', '', 'N', '' UNION
--SELECT 'JEN', 'JEN', '', 'Jennifer', '', 'Walton', '', 'N', '' UNION
--SELECT 'JENNA', 'JENNA', 'Ms.', 'Jenna', '', 'Garabedian', '', 'N', '' UNION
--SELECT 'JENNIFER', 'JENNIFER', 'Ms.', 'Jennifer', '', 'Velazquez', '', 'N', '' UNION
--SELECT 'JEREMY', 'JEREMY', '', 'Jeremy', '', 'Sharp', '', 'N', '' UNION
--SELECT 'JERMOINE', 'JERMOINE', '', 'Jermoine', '', 'Royster', '', 'N', '' UNION
--SELECT 'JESSE', 'JESSE', 'Mr.', 'Jesse', '', 'Pellot-Rosa', '', 'Y', 'Y' UNION
--SELECT 'JESSICA', 'JESSICA', '', 'Jessica', '', 'Henley', '', 'N', '' UNION
--SELECT 'JESSIKA', 'JESSIKA', '', 'Jessika', '', 'Pellot-Rosa', '', 'N', '' UNION
--SELECT 'JH', 'JH', '', 'JH', '', 'JH', '', 'N', '' UNION
--SELECT 'JHUANG', 'JHUANG', '', 'Jessica', '', 'Huang', '', 'N', '' UNION
--SELECT 'JIM', 'JIM', '', 'James', '', 'Eades', '', 'N', '' UNION
--SELECT 'JKLEMPA', 'JKLEMPA', 'Ms.', 'Jamie', 'L.', 'Stealy', '', 'N', '' UNION
--SELECT 'JLI', 'JLI', '', 'John', '', 'Li', '', 'N', '' UNION
--SELECT 'JMARQUEZ', 'JMARQUEZ', 'Ms.', 'Jessica', 'J.', 'Marquez', '', 'N', '' UNION
--SELECT 'JOAN', 'JOAN', '', 'Joan', '', 'Bumbulsky', '', 'N', '' UNION
--SELECT 'JOANNE', 'JOANNE', '', 'Joanne', '', 'Clary', '', 'N', '' UNION
--SELECT 'JOHN', 'JOHN', 'Mr.', 'John', 'D.', 'Gilbody', 'Esq.', 'N', '' UNION
--SELECT 'JOHNM', 'JOHNM', 'Mr.', 'John', '', 'Murray', 'III', 'N', '' UNION
--SELECT 'JONAS', 'JONAS', '', 'Jonas', '', 'Callis', 'Esq.', 'N', '' UNION
--SELECT 'JONATHAN', 'JONATHAN', 'Mr.', 'Jonathan', 'E.', 'Halperin', 'Esq.', 'N', '' UNION
--SELECT 'JORDAN', 'JORDAN', '', 'Jordan', '', 'Dey', '', 'N', '' UNION
--SELECT 'JOSH', 'JOSH', 'Mr.', 'Joshua', 'N.', 'Lief', 'Esq.', 'N', '' UNION
--SELECT 'JOSHM', 'JOSHM', 'Mr.', 'Josh', '', 'Martinez', '', 'N', '' UNION
--SELECT 'JOSHV', 'JOSHV', '', 'Joshua', '', 'Voelkel', '', 'Y', 'Y' UNION
--SELECT 'JR', 'JR', '', 'JR', '', 'Pruden', '', 'N', '' UNION
--SELECT 'JRILEY', 'JRILEY', '', 'Joanne', 'E.', 'Riley', '', 'N', '' UNION
--SELECT 'JROEBUCK', 'JROEBUCK', '', 'Josephine', '', 'Roebuck', '', 'Y', 'Y' UNION
--SELECT 'JSTAPLES', 'JSTAPLES', '', 'Jennifer', '', 'Staples', '', 'N', '' UNION
--SELECT 'JUDITH', 'JUDITH', '', 'Judith', '', 'Flynn', '', 'N', '' UNION
--SELECT 'JUDY', 'JUDY', '', 'Judy', '', 'Coan', '', 'N', '' UNION
--SELECT 'JULIET', 'JULIET', '', 'Juliet', '', 'Edwards', '', 'N', '' UNION
--SELECT 'JUSTIN', 'JUSTIN', '', 'Justin', '', 'Sheldon', 'Esq.', 'N', '' UNION
--SELECT 'JWHITE', 'JWHITE', 'Mr.', 'Jeremy', 'L.', 'White', 'Esq.', 'N', '' UNION
--SELECT 'KABLE', 'KABLE', '', 'Kable', '', 'Rizzo', '', 'N', '' UNION
--SELECT 'KAITLIN', 'KAITLIN', 'Ms.', 'Kaitlin', '', 'Zebrak', '', 'N', '' UNION
--SELECT 'KAITLYN', 'KAITLYN', '', 'Kaitlyn', '', 'Zebrak', '', 'N', '' UNION
--SELECT 'KALLISON', 'KALLISON', '', 'Kasey', '', 'Monger', '', 'N', '' UNION
--SELECT 'KARA', 'KCrane', 'Ms.', 'Kara', '', 'Crane', '', 'Y', 'Y' UNION
--SELECT 'KAREN', 'KAREN', 'Ms.', 'Karen ', '', 'Lasorsa', '', 'N', '' UNION
--SELECT 'KASEY', 'KASEY', 'Ms.', 'Kasey', '', 'Shumaker', '', 'N', '' UNION
--SELECT 'KATE', 'KATE', 'Ms.', 'Kate', '', 'McLin', '', 'N', '' UNION
--SELECT 'KATEK', 'KATEK', '', 'Katherine', '', 'Kulbok', 'Esq.', 'N', '' UNION
--SELECT 'KATELYN', 'KATELYN', '', 'Katelyn', '', 'Johnson', '', 'N', '' UNION
--SELECT 'KATHERIN', 'KATHERIN', '', 'Katherine', '', 'Hammond', '', 'N', '' UNION
--SELECT 'KATIEC', 'KATIEC', '', 'Katherine', '', 'Carroll', 'Esq.', 'Y', 'Y' UNION
--SELECT 'KATRINA', 'KATRINA', '', 'Katrina', '', 'Woodcock', '', 'N', '' UNION
--SELECT 'KAY', 'KAY', '', 'Kay', '', 'Fullem', '', 'N', '' UNION
--SELECT 'KECIA', 'KECIA', '', 'Kecia', '', 'Harvey', '', 'N', '' UNION
--SELECT 'KEITH', 'KEITH', '', 'Keith', '', 'Hennett', '', 'N', '' UNION
--SELECT 'KELLY', 'KELLY', 'Ms.', 'Kelly', 'C.', 'Jurusik', '', 'N', '' UNION
--SELECT 'KENDALL', 'KENDALL', 'Ms.', 'Kendall', '', 'Lawson', '', 'N', '' UNION
--SELECT 'KENISE', 'KENISE', 'Ms.', 'Kenise', '', 'Jenkins', 'B.A.', 'N', '' UNION
--SELECT 'KEYLA', 'KEYLA', 'Ms.', 'Keyla', '', 'Vasquez', '', 'N', '' UNION
--SELECT 'KIM', 'KIM', 'Ms.', 'Kimberly', 'J.', 'Raab', 'Esq.', 'N', '' UNION
--SELECT 'KINNERET', 'KINNERET', 'Ms.', 'Kinneret', '', 'Colon', '', 'N', '' UNION
--SELECT 'KISHARA', 'KISHARA', '', 'Kishara', '', 'Diggs', '', 'N', '' UNION
--SELECT 'KRISTIN', 'KRISTIN', 'Ms.', 'Kristin', '', 'Ely', '', 'N', '' UNION
--SELECT 'KRYSTLE', 'KRYSTLE', '', 'Krystle ', '', 'Harrell', '', 'N', '' UNION
--SELECT 'KTATUM', 'KTATUM', '', 'Kara', '', 'Tatum', '', 'N', '' UNION
--SELECT 'KTORRES', 'KTORRES', 'Ms.', 'Kelly', '', 'Torres-Gonzalez', '', 'N', '' UNION
--SELECT 'KYLE', 'KYLE', '', 'Kyle', '', 'Swan', '', 'N', '' UNION
--SELECT 'KYLEM', 'KYLEM', 'Mr.', 'Kyle', '', 'Matykowksi', '', 'N', '' UNION
--SELECT 'LATOURR', 'LATOURR', '', 'Courtney', '', 'Latourrette', '', 'N', '' UNION
--SELECT 'LAURA', 'LAURA', '', 'Laura', 'A.', 'McDonald', '', 'N', '' UNION
--SELECT 'LAURAH', 'LAURAH', '', 'Laura', '', 'Hite', '', 'N', '' UNION
--SELECT 'LAUREN', 'LAUREN', '', 'Lauren', '', 'Johnson', '', 'N', '' UNION
--SELECT 'LCARROLL', 'LCARROLL', 'Ms.', 'Lauren', '', 'Carroll', 'Esq.', 'N', '' UNION
--SELECT 'LESLIE', 'LESLIE', '', 'Leslie', '', 'Randolph', '', 'N', '' UNION
--SELECT 'LISA', 'LISA', '', 'Lisa', '', 'Puryear', '', 'N', '' UNION
--SELECT 'LISE', 'LISE', 'Ms.', 'Lise', '', 'Wheeler', '', 'N', '' UNION
--SELECT 'LITIFY', 'LITIFY', '', 'Litify', '', 'Team', '', 'N', '' UNION
--SELECT 'LIZ', 'LIZ', '', 'Elizabeth', '', 'Morris', '', 'N', '' UNION
--SELECT 'LMEJIA', 'LMEJIA', 'Ms.', 'Lori', 'E.', 'Mejia', '', 'N', '' UNION
--SELECT 'LORI', 'LORI', 'Ms.', 'Lori', 'A.', 'Ligon', '', 'N', '' UNION
--SELECT 'LOU', 'LOU', '', 'Louis', 'D.', 'Snesil', '', 'N', '' UNION
--SELECT 'LOUISE', 'LOUISE', '', 'Louise', '', 'Tate', '', 'N', '' UNION
--SELECT 'LSTEPHEN', 'LSTEPHEN', '', 'Lauren', '', 'Stephens', '', 'N', '' UNION
--SELECT 'LUIZ', 'LUIZ', 'Mr.', 'Luiz', '', 'Silva', '', 'N', '' UNION
--SELECT 'LYFT', 'LYFT', '', 'LYFT', '', 'LYFT', '', 'N', 'Y' UNION
--SELECT 'LYNNE', 'LYNNE', '', 'Lynne', '', 'Robinson', '', 'N', '' UNION
--SELECT 'MACARIA', 'MACARIA', 'Ms.', 'Macaria', '', 'Wheeler', '', 'N', '' UNION
--SELECT 'MADELINE', 'MADELINE', 'Ms.', 'Madeline', '', 'Alvarez', '', 'N', '' UNION
--SELECT 'MAGGIE', 'MAGGIE', '', 'Magdalene', 'D.', 'Warner', '', 'N', '' UNION
--SELECT 'MAKERS', 'MAKERS', '', 'Michele', '', 'Akers', '', 'N', '' UNION
--SELECT 'MARCUS', 'MARCUS', '', 'Marcus', '', 'Davis', '', 'N', '' UNION
--SELECT 'MARIA', 'MARIA', '', 'Maria', '', 'Cortes', '', 'N', '' UNION
--SELECT 'MARK', 'MARK', '', 'Mark', '', 'James', '', 'N', '' UNION
--SELECT 'MARTIN', 'MARTIN', '', 'Martin', 'R.', 'Johnson', '', 'N', '' UNION
--SELECT 'MATT', 'MATT', '', 'Matthew', 'W.', 'Lastrapes', 'Esq.', 'N', '' UNION
--SELECT 'MCCABE', 'MCCABE', '', 'Mary', '', 'McCabe', '', 'N', '' UNION
--SELECT 'MCHARN', 'MCHARN', '', 'Michele', '', 'Charnock', '', 'N', '' UNION
--SELECT 'MEDINA', 'MEDINA', '', 'Medina', '', 'Smajlagic', '', 'N', '' UNION
--SELECT 'MEETING1', 'MEETING1', '', 'Small', '', 'Meeting Room', '', 'N', 'Y' UNION
--SELECT 'MEETING2', 'MEETING2', '', 'Large', '', 'Meeting Room', '', 'N', 'Y' UNION
--SELECT 'MELISSA', 'MELISSA', '', 'Melissa', '', 'Nowlin', '', 'N', '' UNION
--SELECT 'MELISSAH', 'MELISSAH', '', 'Melissa', '', 'Hunter', '', 'N', '' UNION
--SELECT 'MICHAEL', 'MICHAEL', 'Mr.', 'Michael', 'J.', 'Beste', 'Esq.', 'N', '' UNION
--SELECT 'MICHELE', 'MICHELE', '', 'Michele', '', 'Poff', '', 'N', '' UNION
--SELECT 'MIKEY', 'MIKEY', 'Mr.', 'Mikey', '', 'McDonald', '', 'N', '' UNION
--SELECT 'MIRIAM', 'MIRIAM', 'Ms.', 'Miriam', '', 'Lader', '', 'N', '' UNION
--SELECT 'MLEWIS', 'MLEWIS', 'Ms.', 'Meredith', '', 'Lewis', '', 'N', '' UNION
--SELECT 'MLITMAN', 'MLITMAN', '', 'Michael', '', 'Litman', '', 'N', '' UNION
--SELECT 'MLOVITT', 'MLOVITT', '', 'Morgan', '', 'Lovitt', '', 'Y', 'Y' UNION
--SELECT 'MN', 'MN', '', 'MN', '', 'MN', '', 'N', '' UNION
--SELECT 'MOLLY', 'MOLLY', 'Ms.', 'Molly', '', 'Blanton', '', 'N', '' UNION
--SELECT 'MONIQUE', 'MONIQUE', 'Ms.', 'Monique', 'S.', 'Badger', '', 'N', '' UNION
--SELECT 'MORGAN', 'MORGAN', '', 'Morgan', '', 'Sears', '', 'N', '' UNION
--SELECT 'MST', 'MST', '', 'Mindshift', '', 'Support', '', 'N', '' UNION
--SELECT 'MSTANLEY', 'MSTANLEY', '', 'Michele', '', 'Stanley', '', 'N', '' UNION
--SELECT 'NACOLE', 'NACOLE', '', 'Nacole', '', 'Smith', '', 'N', '' UNION
--SELECT 'NADJA', 'NADJA', 'Ms.', 'Nadja Jaganjac', '', 'Bosnjak', '', 'N', '' UNION
--SELECT 'NAHOMY', 'NAHOMY', 'Ms.', 'Nahomy', '', 'Burgos Rivera', '', 'N', '' UNION
--SELECT 'NAKIA', 'NAKIA', '', 'Nakia', '', 'Smith', '', 'N', '' UNION
--SELECT 'NEDESHA', 'NEDESHA', '', 'Nedesha', '', 'Coleman', '', 'N', '' UNION
--SELECT 'NEVANS', 'NEVANS', 'Ms.', 'Nacole', '', 'Evans', '', 'Y', 'Y' UNION
--SELECT 'NICOLE', 'NICOLE', '', 'Nicole', '', 'Zatkoff', '', 'N', '' UNION
--SELECT 'NIKI', 'NIKI', '', 'Nikisha', 'J.', 'Bailey', '', 'N', '' UNION
--SELECT 'NIKITA', 'NIKITA', '', 'Nikita', '', 'Wolf', 'Esq.', 'N', '' UNION
--SELECT 'NVARNEY', 'NVARNEY', '', 'Nicholas', '', 'Varney', '', 'N', '' UNION
--SELECT 'OLIVIA', 'OLIVIA', '', 'Sheila', 'O.', 'Martin', '', 'N', '' UNION
--SELECT 'OTTIE', 'OTTIE', '', 'Ottie', '', 'Allgood', '', 'N', '' UNION
--SELECT 'PAUL', 'PAUL', '', 'Paul', '', 'Emigholz', '', 'N', '' UNION
--SELECT 'PAULETTE', 'PAULETTE', 'Ms.', 'Paulette ', '', 'Scott', '', 'N', '' UNION
--SELECT 'PDULL', 'PDULL', 'Mr.', 'Paul', 'A.', 'Dull', 'Esq.', 'N', '' UNION
--SELECT 'PETEM', 'PMcNamara', '', 'Pete', '', 'McNamara', '', 'Y', 'Y' UNION
--SELECT 'PKEURA', 'PKEURA', '', 'Paul', '', 'Keurajian', '', 'N', '' UNION
--SELECT 'PTO-STAF', 'PTO-STAF', '', 'PTO', '', 'Staff', '', 'N', '' UNION
--SELECT 'QUINN', 'QUINN', '', 'Walter', '', 'Bundy', 'V', 'Y', 'Y' UNION
--SELECT 'RACHEL', 'RACHEL', '', 'Rachel', '', 'Tischler', '', 'N', '' UNION
--SELECT 'RAINE', 'RAINE', '', 'Raine', '', 'Cummings', '', 'N', '' UNION
--SELECT 'RAMON', 'RAMON', 'Mr.', 'Ramon', '', 'Jones', '', 'N', '' UNION
--SELECT 'REGANNE', 'REGANNE', '', 'Reganne', '', 'Ezell', '', 'N', '' UNION
--SELECT 'ROBERT', 'ROBERT', '', 'Robert', '', 'Reidy', '', 'Y', 'Y' UNION
--SELECT 'ROBIN', 'ROBIN', '', 'Robin', '', 'Stephen', '', 'N', '' UNION
--SELECT 'RONNEEN', 'RONNEEN', '', 'Ronneen', '', 'Johnson', '', 'N', '' UNION
--SELECT 'RTALBOT', 'RTalbot', '', 'Richard', 'H.', 'Talbot', 'Esq.', 'Y', 'Y' UNION
--SELECT 'RUEBEN', 'RUEBEN', 'Mr.', 'Rueben', '', 'Cabrera', '', 'Y', 'Y' UNION
--SELECT 'RUTH', 'RUTH', '', 'Ruth', '', 'Nathanson', 'Esq.', 'N', '' UNION
--SELECT 'RYAN', 'RYAN', '', 'Ryan', '', 'Dunne', '', 'N', '' UNION
--SELECT 'SAILSWOR', 'SAILSWOR', 'Ms.', 'Sarah', '', 'Ailsworth', '', 'N', '' UNION
--SELECT 'SAM', 'SAM', 'Mr.', 'Sam', '', 'Schaffer', '', 'N', '' UNION
--SELECT 'SAMANTHA', 'SAMANTHA', '', 'Samantha', '', 'Cohn', 'Esq.', 'Y', 'Y' UNION
--SELECT 'SARAH', 'SARAH', '', 'Sarah', 'D.', 'Mulik', '', 'N', '' UNION
--SELECT 'SBOWLES', 'SBOWLES', '', 'Sharon', '', 'Bowles', '', 'N', '' UNION
--SELECT 'SDEMONT', 'SDEMONT', '', 'Stephanie', '', 'Demont', '', 'N', '' UNION
--SELECT 'SELENA', 'SELENA', 'Ms.', 'Selena', '', 'Deal', '', 'N', '' UNION
--SELECT 'SELF', 'SELF', '', 'Stephanie', '', 'Self', '', 'N', '' UNION
--SELECT 'SETH', 'SETH', 'Mr.', 'Seth', '', 'Carroll', 'Esq.', 'N', '' UNION
--SELECT 'SHAKERA', 'SHAKERA', 'Ms.', 'Shakera', '', 'Thompson', '', 'N', '' UNION
--SELECT 'SHANNON', 'SHANNON', 'Mrs.', 'Shannon', '', 'McDonald', '', 'N', '' UNION
--SELECT 'SHAREKA', 'SHAREKA', '', 'Shareka', '', 'Jackson', '', 'N', '' UNION
--SELECT 'SHARON', 'SHARON', 'Ms.', 'Sharon', '', 'Colescott', '', 'N', '' UNION
--SELECT 'SHELLY', 'SHELLY', '', 'Shelly', '', 'Archer', '', 'Y', 'Y' UNION
--SELECT 'SILVIA', 'SILVIA', '', 'Silvia', '', 'Castillo', '', 'N', '' UNION
--SELECT 'SKYLAR', 'SKYLAR', '', 'Skyler', '', 'Mosley', '', 'N', '' UNION
--SELECT 'SLOHMANN', 'SLOHMANN', 'Mr.', 'Scott', '', 'Lohmann', '', 'Y', 'Y' UNION
--SELECT 'SNORTH', 'SNORTH', '', 'Susan', '', 'North', '', 'N', '' UNION
--SELECT 'SNOWAK', 'SNOWAK', '', 'Sarah', '', 'Nowak', '', 'N', '' UNION
--SELECT 'SOPHIE', 'SOPHIE', '', 'Sophie', '', 'Booker', '', 'N', '' UNION
--SELECT 'SSUMMERS', 'SSUMMERS', 'Ms.', 'Susan', '', 'Summers', '', 'N', '' UNION
--SELECT 'STACEY', 'STACEY', '', 'Stacey', '', 'Vega', '', 'Y', 'Y' UNION
--SELECT 'STACIE', 'STACIE', '', 'Stacie', '', 'Bell', '', 'N', '' UNION
--SELECT 'STAR', 'STAR', '', 'Star', '', 'Mason', '', 'N', '' UNION
--SELECT 'STEPH', 'STEPH', 'Ms.', 'Stephanie', 'W.', 'Nuttycombe', '', 'N', '' UNION
--SELECT 'STEPHANE', 'STEPHANE', '', 'Stephanie', '', 'Solis', '', 'N', '' UNION
--SELECT 'STEPHANI', 'STEPHANI', '', 'Stephanie', '', 'Wilkins', '', 'N', '' UNION
--SELECT 'STEPHH', 'STEPHH', '', 'Stephanie', '', 'Hernandez', '', 'N', '' UNION
--SELECT 'SUSAN', 'SUSAN', 'Ms.', 'Susan ', '', 'Cottle', '', 'N', '' UNION
--SELECT 'SW', 'SW', '', 'SW', '', 'SW', '', 'N', '' UNION
--SELECT 'SYSTEM', 'SYSTEM', '', 'McDonald', '', '& Associates', '', 'N', '' UNION
--SELECT 'TABITHA', 'TABITHA', '', 'Tabitha', '', 'Burks', '', 'N', '' UNION
--SELECT 'TAJ', 'THenley', 'Mr.', 'Taj', '', 'Henley', '', 'Y', 'Y' UNION
--SELECT 'TAMARA', 'TAMARA', '', 'Tamara', '', 'Merdach', '', 'N', '' UNION
--SELECT 'TAMIA', 'TAMIA', '', 'Tamia', '', 'Bryant', '', 'N', '' UNION
--SELECT 'TAMMY', 'TAMMY', '', 'Tammy', '', 'Bennett', '', 'N', '' UNION
--SELECT 'TASHA', 'TASHA', 'Ms.', 'Tasha', '', 'Gray', '', 'N', '' UNION
--SELECT 'TBRACEY', 'TBRACEY', 'Ms.', 'Tammy', '', 'Bracey', '', 'N', '' UNION
--SELECT 'TEMP', 'TEMP', '', 'Temporary', '', 'Help', '', 'N', '' UNION
--SELECT 'TERRA', 'TERRA', '', 'Terra', '', 'Fuentes', '', 'N', '' UNION
--SELECT 'THEO', 'THEO', '', 'Theodore', '', 'Briscoe', '', 'Y', 'Y' UNION
--SELECT 'THODGSON', 'THODGSON', '', 'Thomas', '', 'Hodgson', '', 'N', '' UNION
--SELECT 'THOMAS', 'THOMAS', '', 'Thomas', '', 'Selman', '', 'N', '' UNION
--SELECT 'TODD', 'TODD', 'Mr.', 'Todd', 'H.', 'Ranson', 'Esq.', 'Y', 'Y' UNION
--SELECT 'TOM', 'TOM', 'Mr.', 'Thomas', '', 'Pearce', '', 'N', '' UNION
--SELECT 'TOMMY', 'TOMMY', 'Mr.', 'Tommy', '', 'Streat', '', 'N', '' UNION
--SELECT 'TRACEY', 'TRACEY', '', 'Tracey', 'L.', 'Kinchen', '', 'N', '' UNION
--SELECT 'TRACI', 'TRACI', '', 'Traci', '', 'Lee', '', 'N', '' UNION
--SELECT 'TSTOKES', 'TSTOKES', 'Mr.', 'Tommy', '', 'Stokes', 'Esq.', 'N', '' UNION
--SELECT 'TYLER', 'TYLER', '', 'Tyler ', '', 'Crowe', '', 'N', '' UNION
--SELECT 'VBURTON', 'VBURTON', 'Ms.', 'Victoria', '', 'Burton', '', 'N', '' UNION
--SELECT 'VICTORIA', 'VICTORIA', 'Ms.', 'Victoria', '', 'Robinson', '', 'N', '' UNION
--SELECT 'WENDY', 'WENDY', 'Ms.', 'Wendy', '', 'March', '', 'N', '' UNION
--SELECT 'WILL', 'WILL', '', 'Will', '', 'Clough', '', 'N', '' UNION
--SELECT 'WILLIAM', 'WILLIAM', '', 'William', '', 'Sweeney', 'Jr., Esq.', 'Y', 'Y' UNION
--SELECT 'EDNA', 'EDNA', 'Ms.', 'Edna', '', 'Colucci', 'Esq.', 'Y', 'Y' UNION
--SELECT 'AMYSCOTT', 'AMYSCOTT', 'Ms.', 'Amy', '', 'Scott', '', 'Y', 'Y' UNION
--SELECT 'KEONDRE', 'KEONDRE', '', 'Keondre', '', 'Barnes', '', 'Y', 'Y' UNION
--SELECT 'LILLY', 'LILLY', '', 'Lilly', '', 'Snyder', '', 'Y', 'Y' UNION
--SELECT 'GENESIS', 'GENESIS', '', 'Genesis', '', 'Chavarria', '', 'Y', 'Y' UNION
--SELECT 'TESS', 'TESS', '', 'Christine', '', 'Ransone', '', 'Y', 'Y' 


--select * From implementation_users

--update implementation_users
--set Active = case when Active = 'N' then 0
--					when Active = 'Y' then 1
--					else 0 end,
--	visible = Case when active = 'Y' then 1
--					else 0 end