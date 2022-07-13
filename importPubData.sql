
select f.k, f.v AS homepage INTO tempHome from Field f where f.p='url' AND f.v LIKE 'http%';
select f.k, f.v AS auth INTO tempAuthor from Field f where f.p='author';
select f.k, f.v AS title INTO tempTitle from Field f where f.p='title';
select f.k, f.v AS yr INTO tempYear from Field f where f.p='year';
select f.k, f.v AS jrnl INTO tempJournal from Field f where f.p='journal';
select f.k, f.v AS mo INTO tempMonth from Field f where f.p='month';
select f.k, f.v AS vol INTO tempVol from Field f where f.p='volume';
select f.k, f.v AS no INTO tempNum from Field f where f.p='number';
select f.k, f.v AS publisher INTO tempPublisher from Field f where f.p='publisher';
select f.k, f.v AS isbn INTO tempISBN from Field f where f.p='isbn';
select f.k, f.v AS booktitle INTO tempBookTitle from Field f where f.p='booktitle';
select f.k, f.v AS editor INTO tempEditor from Field f where f.p='editor';

-- TempAuthor: From problem 6, add pubkey to author
drop table if exists tempAuthor;
create table tempAuthor (id int, pubkey text, name text, homepage text);
create sequence a;
insert into Author
	(select nextval('a'), p.k, ta.auth, th.homepage FROM Pub p 
		LEFT OUTER JOIN tempAuthor AS ta ON p.k = ta.k
		LEFT OUTER JOIN tempHome AS th ON p.k = th.k);
drop sequence a;
-- TempAuthorYear: From Problem 6, authors, publications, and year
drop table if exists tempAuthorYear;
create table tempAuthorYear(pubkey text, name text, year text);
create sequence a;
insert into tempAuthorYear 
	(select p.k, ta.auth, ty.yr from Pub p
		LEFT OUTER JOIN tempAuthor AS ta ON p.k = ta.k
		LEFT OUTER JOIN tempYear AS ty ON p.k = ty.k);
drop sequence a;

--Author: Left Outer Join, some author(s) may not have homepage(s)
-- Adding pubkey into author to answer question Problem 6
drop table if exists Author;
create table Author (id int, pubkey text, name text, homepage text);
create sequence a;
insert into Author
	(select nextval('a'), p.k, ta.auth, th.homepage FROM Pub p 
		LEFT OUTER JOIN tempAuthor AS ta ON p.k = ta.k
		LEFT OUTER JOIN tempHome AS th ON p.k = th.k);
drop sequence a;

--Publication: Left Outer Join, Assumes Pub contains all publications, includes some publication(s) that may not have Title or Year
-- Drop key constraint and Alter after
create sequence q;
drop table if exists Publication;
create table Publication (pubid int, pubkey text, title text, year text);
insert into Publication
	(select nextval('q'), p.k, ti.title, ty.yr FROM Pub p 
		LEFT OUTER JOIN tempTitle AS ti ON p.k = ti.k
		LEFT OUTER JOIN tempYear AS ty ON p.k = ty.k);
drop sequence q;
ALTER TABLE Publication ADD UNIQUE (pubkey);

--Article: Left Outer Join, Assumes Pub contains all publications, inclue some article(s) that may not have Journal, Month, Vol, or Num
create sequence a;
insert into Article
	(select p.k, ti.title, tj.jrnl, tm.mo, tv.vol, tn.no FROM Pub p
		LEFT OUTER JOIN tempTitle AS ti ON p.k = ti.k
		LEFT OUTER JOIN tempJournal AS tj ON p.k = tj.k
		LEFT OUTER JOIN tempMonth AS tm ON p.k = tm.k
		LEFT OUTER JOIN tempVol AS tv ON p.k = tv.k
		LEFT OUTER JOIN tempNum AS tn ON p.k = tn.k
		WHERE EXISTS 
			(select * from Pub WHERE Pub.k = p.k and Pub.p='article'));
drop sequence a;

--Book: Left Outer Join, Assumes Pub contains all publications, includes some book(s) that may not have Publisher or ISBN
create sequence a;
insert into Book
	(select p.k, tp.publisher, tisbn.isbn FROM Pub p
		LEFT OUTER JOIN tempPublisher AS tp ON p.k = tp.k
		LEFT OUTER JOIN tempISBN AS tisbn ON p.k = tisbn.k
		WHERE EXISTS 
			(select * from Pub WHERE Pub.k = p.k and Pub.p='book'));
drop sequence a;
--Incollection: Left Outer Join, Assumes Pub contains all publications, includes some Incollection(s) that may not have booktitle, Publisher, or ISBN
create sequence a;
insert into Incollection
	(select p.k, tb.booktitle, tp.publisher, tisbn.isbn FROM Pub p
		LEFT OUTER JOIN tempBookTitle AS tb ON p.k = tb.k 
		LEFT OUTER JOIN tempPublisher AS tp ON p.k = tp.k
		LEFT OUTER JOIN tempISBN AS tisbn ON p.k = tisbn.k
		WHERE EXISTS 
			(select * from Pub WHERE Pub.k = p.k and Pub.p='incollection'));
drop sequence a;
--Inproceedings: Left Outer Join, Assumes Pub contains all publications, includes some Inproceeding(s) that may not have booktitle or editor
create sequence a;
insert into Inproceedings 
	(select p.k, tb.booktitle, te.editor FROM Pub AS p
		LEFT OUTER JOIN tempBookTitle AS tb ON p.k = tb.k 
		LEFT OUTER JOIN tempEditor AS te ON p.k = te.k 
		WHERE EXISTS 
			(select * from Pub 
			WHERE Pub.k = p.k and Pub.p='inproceedings'));
drop sequence a;

-- Drop TEMP Tables
drop table tempAuthor,tempHome,tempTitle,tempYear,tempJournal,tempMonth,tempVol,tempNum,tempPublisher,tempISBN,tempBookTitle,tempEditor;

-- INDEX Pub Schema for faster query of data
CREATE INDEX authIdx
ON Author (id, name, homepage);
CREATE INDEX largestPubIdx
ON Publication (pubid, pubkey, title, year);
CREATE INDEX articleIdx
ON Article (title);
















