PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (

    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_reply_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('sunny', 'lives'),
    ('danny', 'money'),
    ('david', 'hasselhoff');
    -----------------------------------------
INSERT INTO
   questions(title, body, user_id)
VALUES
    ('Sandwhich', 'How to make a sandwhich?', 
    (SELECT id FROM users WHERE fname = 'sunny')),
    ('Money', 'Where da money at?', 
    (SELECT id FROM users WHERE fname = 'danny')),
    ('Macaroni', 'Do you love Mac and Cheese?',
    (SELECT id FROM users WHERE fname = 'david'));
--------------------------------------------
INSERT INTO
    question_follows(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'sunny'),
    (SELECT id FROM questions WHERE title = 'Sandwhich')),
    ((SELECT id FROM users WHERE fname = 'danny'),
    (SELECT id FROM questions WHERE title = 'Money')),
    ((SELECT id FROM users WHERE fname = 'david'),
    (SELECT id FROM questions WHERE title = 'Macaroni'));
--------------------------------------------------------------
INSERT INTO
    replies(body, question_id, user_id)
VALUES
    ('put two pieces of bread together', 
    (SELECT id FROM questions WHERE title = 'Sandwhich'),
    (SELECT id FROM users WHERE fname = 'danny')),
    ('go get a job',
    (SELECT id FROM questions WHERE title = 'Money'),
    (SELECT id FROM users WHERE fname = 'sunny')),
    ('Yes i do',
    (SELECT id FROM questions WHERE title = 'Macaroni'),
    (SELECT id FROM users WHERE fname = 'danny'));
-------------------------------------------------------------
INSERT INTO 
    replies(body, question_id, user_id, parent_reply_id)
VALUES
    ('don''t forget the cheese',
    (SELECT id FROM questions WHERE title = 'Sandwhich'),
    (SELECT id FROM users WHERE fname = 'david'),
    (SELECT id FROM replies WHERE body = 'put two pieces of bread together'));


----------------------------------------------------------
INSERT INTO
    question_likes
    (user_id, question_id)
VALUES
    ((SELECT id
        FROM users
        WHERE fname = 'sunny'),
        (SELECT id
        FROM questions
        WHERE title = 'Sandwhich')),
    ((SELECT id
        FROM users
        WHERE fname = 'danny'),
        (SELECT id
        FROM questions
        WHERE title = 'Money')),
    ((SELECT id
        FROM users
        WHERE fname = 'david'),
        (SELECT id
        FROM questions
        WHERE title = 'Macaroni'));