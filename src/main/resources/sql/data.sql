-- Users
MERGE INTO users KEY(username)
    VALUES ('teacher1', '$2a$10$.2uReiMlhDQz4LQG.vUe2eFggJSdlw0qXijvRv.iNELtnj9FmPu3G', 'John Teacher', 'john@hkmu.edu.hk', '12345678');
MERGE INTO users KEY(username)
    VALUES ('student1', '$2a$10$n3brIm89ujAapcAjcex0a.GorAjkxr85I/VvIOWMQWi.KgZge9lDa', 'Mary Student', 'mary@hkmu.edu.hk', '87654321');

-- User Roles
INSERT INTO user_roles(username, role)
    SELECT 'teacher1', 'ROLE_TEACHER'
    WHERE NOT EXISTS (SELECT 1 FROM user_roles WHERE username='teacher1' AND role='ROLE_TEACHER');

INSERT INTO user_roles(username, role)
    SELECT 'student1', 'ROLE_STUDENT'
    WHERE NOT EXISTS (SELECT 1 FROM user_roles WHERE username='student1' AND role='ROLE_STUDENT');

-- Lectures
MERGE INTO lecture KEY(id)
    VALUES (1, 'Introduction to Java Programming', 'This lecture covers the basics of Java programming language including variables, data types, control structures, and object-oriented programming concepts.');
MERGE INTO lecture KEY(id)
    VALUES (2, 'Web Development with Spring Boot', 'This lecture introduces Spring Boot framework for building web applications, including Spring MVC, Spring Data JPA, and Spring Security.');
MERGE INTO lecture KEY(id)
    VALUES (3, 'Database Design and SQL', 'This lecture covers relational database design principles, normalization, and SQL queries for data manipulation.');

-- Polls
MERGE INTO poll KEY(id) VALUES (1, 'Which topic should be introduced in the next class?');
MERGE INTO poll KEY(id) VALUES (2, 'What is your preferred learning method?');
MERGE INTO poll KEY(id) VALUES (3, 'Which programming language would you like to learn next?');

-- Poll Options
MERGE INTO poll_option KEY(id) VALUES (1,  'Advanced Java Concurrency',  3,  1);
MERGE INTO poll_option KEY(id) VALUES (2,  'Microservices Architecture',  5,  1);
MERGE INTO poll_option KEY(id) VALUES (3,  'Cloud Computing with AWS',    2,  1);
MERGE INTO poll_option KEY(id) VALUES (4,  'Machine Learning Basics',     4,  1);
MERGE INTO poll_option KEY(id) VALUES (5,  'DevOps and CI/CD',            1,  1);
MERGE INTO poll_option KEY(id) VALUES (6,  'Video Lectures',              8,  2);
MERGE INTO poll_option KEY(id) VALUES (7,  'Hands-on Labs',               12, 2);
MERGE INTO poll_option KEY(id) VALUES (8,  'Reading Materials',           3,  2);
MERGE INTO poll_option KEY(id) VALUES (9,  'Group Discussions',           5,  2);
MERGE INTO poll_option KEY(id) VALUES (10, 'Project-based Learning',      7,  2);
MERGE INTO poll_option KEY(id) VALUES (11, 'Python',                      10, 3);
MERGE INTO poll_option KEY(id) VALUES (12, 'JavaScript',                  6,  3);
MERGE INTO poll_option KEY(id) VALUES (13, 'Go',                          2,  3);
MERGE INTO poll_option KEY(id) VALUES (14, 'Kotlin',                      4,  3);
MERGE INTO poll_option KEY(id) VALUES (15, 'Rust',                        1,  3);

-- Comments
MERGE INTO comment KEY(id) VALUES (1, 'student1', 'Great introduction to Java! Looking forward to more advanced topics.',  '2025-03-20 10:30:00', 1, NULL);
MERGE INTO comment KEY(id) VALUES (2, 'teacher1', 'Thank you! We will cover more advanced topics in the next lecture.',    '2025-03-20 11:00:00', 1, NULL);
MERGE INTO comment KEY(id) VALUES (3, 'student1', 'Spring Boot makes web development so much easier!',                     '2025-03-21 14:20:00', 2, NULL);
MERGE INTO comment KEY(id) VALUES (4, 'student1', 'I prefer hands-on labs for better understanding.',                      '2025-03-22 09:15:00', NULL, 2);

-- Reset identity sequences
ALTER TABLE lecture    ALTER COLUMN id RESTART WITH 1000;
ALTER TABLE poll       ALTER COLUMN id RESTART WITH 1000;
ALTER TABLE poll_option ALTER COLUMN id RESTART WITH 1000;
ALTER TABLE comment    ALTER COLUMN id RESTART WITH 1000;
