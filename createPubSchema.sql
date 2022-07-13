drop table if exists Author;
drop table if exists Publication;
drop table if exists Article;
drop table if exists Book;
drop table if exists Incollection;
drop table if exists Inproceedings;

create table Author (id int, name text, homepage text);
create table Publication (pubid int, pubkey text, title text, year text);
create table Article (pubkey text, title text, journal text, month text, volume text, num text);
create table Book (pubkey text, publisher text, isbn text);
create table Incollection (pubkey text, booktitle text, publisher text, isbn text);
create table Inproceedings (pubkey text, booktitle text, editor text);

-- Key attributes
ALTER TABLE Author ADD UNIQUE (id);
ALTER TABLE Publication ADD UNIQUE (pubkey);