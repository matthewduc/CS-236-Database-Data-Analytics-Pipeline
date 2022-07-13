-- Problem 4
-- Query 1
select DISTINCT P.p AS Publication, COUNT(*) AS count  from Pub P GROUP BY Publication;
 
/*
  publication  |  count  
---------------+---------
 article       | 2857222
 book          |   19396
 incollection  |   68035
 inproceedings | 3032917
 mastersthesis |      13
 phdthesis     |   87051
 proceedings   |   50879
 www           | 3001625
(8 rows)
*/

-- Query 2
-- select DISTINCT FIELD.P from field FIELD; returns all fields
--      p     
-- -----------
--  year
--  editor
--  url
--  booktitle
--  publisher
--  title
--  month
--  isbn
--  journal
--  author
--  volume
--  number
-- (12 rows)
-- Intuition: to return fields with all 8 publication types
select fd.p1 as fields from (select DISTINCT f.p as p1, p.p as p2, 
	COUNT(f.k) from pub p JOIN field f ON p.k = f.k GROUP BY f.p, p.p) 
	fd GROUP BY fd.p1 HAVING COUNT(fd.p1) >= 8;
/*
 fields 
--------
 author
 ee
 note
 title
 year
(5 rows)
*/

-- Problem 6: Find the top 20 authors with the largest number of publications
select Author.name, COUNT(Publication.pubid) AS PubCount from Author, Publication where Author.id=Publication.pubid group by Author.name order by PubCount desc limit 20;
/*
         name         | pubcount 
----------------------+----------
 H. Vincent Poor      |     1042
 Mohamed-Slim Alouini |      756
 Philip S. Yu         |      688
 Wei Wang             |      685
 Lajos Hanzo          |      631
 Yu Zhang             |      617
 Yang Liu             |      610
 Dacheng Tao          |      605
 Victor C. M. Leung   |      585
 Lei Wang             |      581
 Lei Zhang            |      574
 Wei Zhang            |      573
 Zhu Han 0001         |      571
 Wen Gao 0001         |      558
 Witold Pedrycz       |      555
 Wei Li               |      537
 Hai Jin 0001         |      525
 Xin Wang             |      512
 Luca Benini          |      507
 Li Zhang             |      506
(20 rows)
*/

-- Problem 6: Find the top 20 authors with the largest number of publications in STOC
-- USING Subset of Pub & Field returns no value for these questions, no connection between Author Table and Publication Table
-- Adding a 'Title' column to Article returns the following
select Author.name, COUNT(Publication.pubid) AS PubCount from Author, Publication, Article where Publication.pubkey=Article.pubkey and Article.title like '%Symposium on Theory of Computing%' or Article.title like '%STOC %' and Author.id=Publication.pubid group by Author.name order by PubCount desc limit 20;
/*
          name          | pubcount 
------------------------+----------
 Marvin Minsky          |      612
 Moshe Y. Vardi         |      612
 David A. Patterson     |      578
 Vint Cerf              |      578
 Bertrand Meyer 0001    |      578
 Linus Torvalds         |      578
 Ross Anderson 0001     |      578
 Ricardo A. Baeza-Yates |      578
 Martin Vetterli        |      578
 Tim Berners-Lee        |      578
 Ross J. Anderson       |      578
 Vinton G. Cerf         |      578
 Ricardo Baeza-Yates    |      578
 Herbert A. Simon       |      578
 Lotfi A. Zadeh         |      578
 Nicholas John Higham   |      544
 Nigel P. Smart         |      544
 Nicholas J. Higham     |      544
 Niklaus Emil Wirth     |      544
 Dana S. Scott          |      544
(20 rows)*/

-- Problem 6: Compute total number of publications in DBLP by decade
select (FLOOR(cast(Publication.year AS int)/10)*10) AS decade, COUNT(Publication.pubid) FROM Publication GROUP BY FLOOR(cast(Publication.year AS int)/10);
/*
 decade |  count  
--------+---------
   1930 |      56
   1940 |     192
   1950 |    2617
   1960 |   13463
   1970 |   48268
   1980 |  140844
   1990 |  465673
   2000 | 1451299
   2010 | 3025797
   2020 |  967318
        | 3001613
(11 rows)
*/

-- Problem 6: Find the top 20 most collaborative authors
-- Requires Addition of Authored table in importPubData.sql
select Author.name AS SelectedAuthor, COUNT(Author.name) AS CoAuthor from Author, Publication where Author.pubkey=Publication.pubkey group by Author.name order by CoAuthor desc limit 20;
/*
  selectedauthor    | coauthor 
----------------------+----------
 H. Vincent Poor      |     2474
 Mohamed-Slim Alouini |     1837
 Philip S. Yu         |     1735
 Yang Liu             |     1645
 Wei Wang             |     1626
 Lajos Hanzo          |     1570
 Wei Zhang            |     1480
 Yu Zhang             |     1477
 Zhu Han 0001         |     1433
 Lei Zhang            |     1408
 Dacheng Tao          |     1391
 Lei Wang             |     1378
 Victor C. M. Leung   |     1372
 Wen Gao 0001         |     1351
 Witold Pedrycz       |     1351
 Hai Jin 0001         |     1333
 Xin Wang             |     1310
 Wei Li               |     1309
 Luca Benini          |     1267
 Li Zhang             |     1247
(20 rows)
*/

-- Problem 6: Find the most prolific author in that decade
-- Requires tempAuthoredDecade table in importPubData.sql
select DISTINCT subQuery1.decade, MAX(subQuery1.PubCount), MAX(subQuery1.SelectedAuthor) from (
select COUNT(tempAuthorYear.pubkey) AS PubCount, tempAuthorYear.name AS SelectedAuthor, (FLOOR(cast(tempAuthorYear.year AS int)/10)*10) AS decade from tempAuthorYear where tempAuthorYear.name = tempAuthorYear.name GROUP BY decade, tempAuthorYear.name)
AS subQuery1 GROUP BY subQuery1.decade;
/*
 decade | max  |         max          
--------+------+----------------------
   1930 |    7 | Wladyslaw Hetper
   1940 |   10 | Zoltan Paul Dienes
   1950 |   14 | anonymous
   1960 |   41 | anonymous
   1970 |   82 | Ümit Özgüner
   1980 |  172 | Ümit Özgüner
   1990 |  266 | Ünver Çinar
   2000 |  565 | Þórir Harðarson
   2010 | 1215 | þorgerður Pálsdóttir
   2020 |  705 | ömer Demirci
        |    1 | þorgerður Pálsdóttir
(11 rows)
*/

-- Find insitutions that have published the most papers in STOC
-- Finding STOC Papers
select * from Publication where Publication.title like '%Symposium on Theory of Computing%' or Publication.title like '%STOC %' limit 20;
/*
 pubid  |              pubkey               |                                                           title                                                           | year 
---------+-----------------------------------+---------------------------------------------------------------------------------------------------------------------------+------
 3646057 | journals/siamcomp/Babai06         | Special Issue Dedicated To The Thirty-Sixth Annual ACM Symposium On Theory Of Computing (STOC 2004).                      | 2006
 3739118 | conf/stoc/2001                    | Proceedings on 33rd Annual ACM Symposium on Theory of Computing, July 6-8, 2001, Heraklion, Crete, Greece                 | 2001
 3956416 | journals/rc/LongpreB97            | Interval and Complexity Workshops Back-to-Back with 1997 ACM Symposium on Theory of Computing (STOC'97).                  | 1997
 3967150 | journals/siamcomp/DaskalakisKI18  | Special Section on the Forty-Seventh Annual ACM Symposium on Theory of Computing (STOC 2015).                             | 2018
 4202135 | conf/stoc/STOC18                  | Proceedings of the 18th Annual ACM Symposium on Theory of Computing, May 28-30, 1986, Berkeley, California, USA           | 1986
 4092385 | conf/iccal/Gillard90              | A Tiny Tool for Matrix Inversion in a COSTOC Environment.                                                                 | 1990
 4060244 | conf/stoc/2005                    | Proceedings of the 37th Annual ACM Symposium on Theory of Computing, Baltimore, MD, USA, May 22-24, 2005                  | 2005
 7226420 | conf/stoc/STOC9                   | Proceedings of the 9th Annual ACM Symposium on Theory of Computing, May 4-6, 1977, Boulder, Colorado, USA                 | 1977
 4308944 | conf/stoc/STOC26                  | Proceedings of the Twenty-Sixth Annual ACM Symposium on Theory of Computing, 23-25 May 1994, Montréal, Québec, Canada     | 1994
 4522194 | conf/stoc/STOC25                  | Proceedings of the Twenty-Fifth Annual ACM Symposium on Theory of Computing, May 16-18, 1993, San Diego, CA, USA          | 1993
 5198036 | conf/stoc/2000                    | Proceedings of the Thirty-Second Annual ACM Symposium on Theory of Computing, May 21-23, 2000, Portland, OR, USA          | 2000
 5212094 | journals/siamcomp/SmithK18        | Special Section on the Forty-Sixth Annual ACM Symposium on Theory of Computing (STOC 2014).                               | 2018
 5340587 | conf/stoc/2009                    | Proceedings of the 41st Annual ACM Symposium on Theory of Computing, STOC 2009, Bethesda, MD, USA, May 31 - June 2, 2009  | 2009
 5390032 | journals/siamcomp/AaronsonGKMMS09 | Special Issue On The Thirty-Eighth Annual ACM Symposium On Theory Of Computing (STOC 2006).                               | 2009
 5661068 | conf/stoc/2002                    | Proceedings on 34th Annual ACM Symposium on Theory of Computing, May 19-21, 2002, Montréal, Québec, Canada                | 2002
 5732504 | conf/stoc/STOC15                  | Proceedings of the 15th Annual ACM Symposium on Theory of Computing, 25-27 April, 1983, Boston, Massachusetts, USA        | 1983
 5732511 | conf/stoc/1999                    | Proceedings of the Thirty-First Annual ACM Symposium on Theory of Computing, May 1-4, 1999, Atlanta, Georgia, USA         | 1999
 5768216 | conf/stoc/STOC11                  | Proceedings of the 11h Annual ACM Symposium on Theory of Computing, April 30 - May 2, 1979, Atlanta, Georgia, USA         | 1979
 6229886 | conf/stoc/STOC27                  | Proceedings of the Twenty-Seventh Annual ACM Symposium on Theory of Computing, 29 May-1 June 1995, Las Vegas, Nevada, USA | 1995
 6706244 | journals/siamcomp/AllenderKS09    | Special Section On The Thirty-Ninth Annual ACM Symposium On Theory Of Computing (STOC 2007).                              | 2009
(20 rows)
*/
-- Finding Insitutional Authors
select DISTINCT Author.homepage from Author where Author.homepage like '%.edu%' limit 20;
/*
                                   homepage                                         
-----------------------------------------------------------------------------------------
 http://5g.ucsd.edu/speaker/james-buckwalter
 http://aaabdelsalam_eng.staff.scuegypt.edu.eg/
 http://abenson.people.ua.edu
 http://abstract.cs.washington.edu/~shwetak/
 http://abut.sdsu.edu/
 http://academic.cankaya.edu.tr/~schmidt/
 http://academic.csuohio.edu/zhao_w/
 http://academic.depauw.edu/dberque_web/
 http://academic.evergreen.edu/j/judyc/home.htm
 http://academic.udayton.edu/PhuPhung/
 http://academic.xjtlu.edu.cn/arch/Staff/thomas-fischer
 http://academicdepartments.musc.edu/facultydirectory/FacultyDetails.aspx?facultyId=6995
 http://academics.smcvt.edu/jellis-monaghan/
 http://acdl.mit.edu/PERAIRE.bio.html
 http://ace.cs.ohio.edu/~gstewart/
 http://ace.cs.ohio.edu/~razvan
 http://aci2.ncat.edu/gvdozier/
 http://acid.sdsc.edu/users/chaitan-baru
 http://acl.mit.edu/members/levine.htm
 http://aclab.dcs.upd.edu.ph/members/henry
(20 rows)
*/

-- Matching Publications
select Author.homepage from Author,
(select * from Publication where Publication.title like '%Symposium on Theory of Computing%' or Publication.title like '%CHI %')
AS subQuery1 where Author.pubkey = subQuery1.pubkey and Author.homepage IS NOT NULL limit 20;
/*
 homepage 
----------
(0 rows)
*/

-- Data Visualization
select subQuery1.coauthor, COUNT(subQuery1.SelectedAuthor) from (
select Author.name AS SelectedAuthor, COUNT(Author.name) AS CoAuthor from Author, Publication where Author.pubkey=Publication.pubkey group by Author.name order by CoAuthor asc
) AS subQuery1 GROUP BY subQuery1.coauthor limit 50;

