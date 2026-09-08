-- Lab 5, step 2 — paste at the psql prompt (bookshelf=>)
CREATE TABLE books (id serial PRIMARY KEY, title text NOT NULL, author text, year int);
INSERT INTO books (title, author, year) VALUES
  ('The Pragmatic Programmer','Hunt & Thomas',1999),
  ('Designing Data-Intensive Applications','Kleppmann',2017),
  ('Site Reliability Engineering','Beyer et al.',2016),
  ('Release It!','Nygard',2018);
SELECT title, year FROM books WHERE year >= 2017 ORDER BY year;
