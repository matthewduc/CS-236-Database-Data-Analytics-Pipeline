#!/usr/bin/python
import psycopg2
import matplotlib.pyplot as plt
import numpy as np

def addlabels(x,y):
    for i in range(10):
        plt.text(i,y[i],y[i])

def main():
    conn = psycopg2.connect("dbname='dblp' user='nguyen' host='localhost' password=''")
    cur = conn.cursor()
    cur.execute("select subQuery1.coauthor, COUNT(subQuery1.SelectedAuthor) from (select Author.name AS SelectedAuthor, COUNT(Author.name) AS CoAuthor from Author, Publication where Author.pubkey=Publication.pubkey group by Author.name order by CoAuthor asc) AS subQuery1 GROUP BY subQuery1.coauthor limit 50;")
    rows = cur.fetchall()
    
    ## the data
    coauthors = []
    publications = []

    for row in rows:
        coauthors.append(row[0])
        publications.append(row[1])


    plt.bar(coauthors,publications)
    plt.ylim([0,500000])
    addlabels(coauthors, publications)
    plt.title("Bar Graph of Coauthors vs Publications")
    plt.xlabel("Coauthors")
    plt.ylabel("Publications")
    plt.show()

if __name__ == "__main__":
    main()
