CREATE DATABASE GymDB;
USE GymDB;
CREATE TABLE MembershipPlan (
    planID INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50),
    price DECIMAL(10,2),
    duration_months INT
);

CREATE TABLE Trainer (
    trainerID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(50),
    email VARCHAR(100),
    salary DECIMAL(10,2)
);

CREATE TABLE Member (
    memberID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    start_date DATE,
    planID INT,
    trainerID INT,
    FOREIGN KEY (planID) REFERENCES MembershipPlan(planID),
    FOREIGN KEY (trainerID) REFERENCES Trainer(trainerID)
);

CREATE TABLE Class (
    classID INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50),
    schedule_date DATE,
    trainerID INT,
    capacity INT,
    FOREIGN KEY (trainerID) REFERENCES Trainer(trainerID)
);

CREATE TABLE Enrollment (
    enrollID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT,
    classID INT,
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (classID) REFERENCES Class(classID)
);

INSERT INTO MembershipPlan (plan_name, price, duration_months)
VALUES
('Basic', 30.00, 1),
('Standard', 50.00, 1),
('Premium', 80.00, 1);

INSERT INTO Trainer (first_name, last_name, specialty, email, salary)
VALUES
('John', 'Cruz', 'Strength', 'john@gym.com', 4000),
('Maria', 'Lopez', 'Cardio', 'maria@gym.com', 4200);

INSERT INTO Member (first_name, last_name, phone, email, start_date, planID, trainerID)
VALUES
('Alex', 'Kim', '111-222', 'alex@gmail.com', '2025-01-02', 1, 1),
('Jordan', 'Lee', '333-444', 'jordan@gmail.com', '2025-02-10', 2, 2);

INSERT INTO Class (class_name, schedule_date, trainerID, capacity)
VALUES
('Yoga', '2025-03-01', 2, 20),
('Strength Training', '2025-03-02', 1, 15);

INSERT INTO Enrollment (memberID, classID)
VALUES
(1, 1),
(2, 2);

SELECT * FROM MembershipPlan;
SELECT * FROM Trainer;
SELECT * FROM Member;
SELECT * FROM Class;
SELECT * FROM Enrollment;

#Inserting
# Insert a new member
INSERT INTO Member (first_name, last_name, phone, email, start_date, planID, trainerID)
VALUES ('Fool', 'Hardy', '111-222', 'fool.hardy@gmail.com', '2025-10-11', 1, 1);
SELECT * FROM Member;

# Insert a new trainer
INSERT INTO Trainer (first_name, last_name, specialty, email, salary)
VALUES ('Tom', 'Hardy', 'Strength', 'tom.hardy@gym.com', 4000);

# Insert a new class
INSERT INTO Class (class_name, schedule_date, trainerID, capacity)
VALUES ('Pilates', '2025-06-07', 1, 18);

# Insert a new membership plan
INSERT INTO MembershipPlan (plan_name, price, duration_months)
VALUES ('Elite', 120.00, 1);

# Enroll into a class
INSERT INTO Enrollment (memberID, classID)
VALUES (1, 1);

#Updating
# Update a member's plan
UPDATE Member
SET planID = 2
WHERE memberID = 1;

# Update trainer salary
UPDATE Trainer
SET salary = 5000
WHERE trainerID = 1;
SELECT * FROM Trainer;

# Update membership plan price
UPDATE MembershipPlan
SET price = 90.00
WHERE planID = 3;

# Update class capacity
UPDATE Class
SET capacity = 30
WHERE classID = 1;

# Update enrollment (change class for a member)
UPDATE Enrollment
SET classID = 2
WHERE enrollID = 1;
 
#Deleting

# Delete a member
DELETE FROM Member
WHERE memberID = 2;

# Delete a trainer
DELETE FROM Trainer
WHERE trainerID = 2;

# Delete a membership plan
DELETE FROM MembershipPlan
WHERE planID = 3;

# Delete a class
DELETE FROM Class
WHERE classID = 2;
SELECT * FROM class;

# Delete an enrollment
DELETE FROM Enrollment
WHERE enrollID = 2;
SELECT * FROM Enrollment;

#Aggregate

# Count total members
SELECT COUNT(*) AS total_members
FROM Member;
SELECT * FROM total_members;

# Average membership plan price
SELECT AVG(price) AS avg_plan_price
FROM MembershipPlan;

# Average trainer salary
SELECT AVG(salary) AS avg_salary
FROM Trainer;

# Total class capacity
SELECT SUM(capacity) AS total_capacity
FROM Class;

# Count all enrollments
SELECT COUNT(*) AS total_enrollments
FROM Enrollment;

#Join Queries

# Show members and their plan
SELECT Member.first_name, Member.last_name, MembershipPlan.plan_name
FROM Member
JOIN MembershipPlan ON Member.planID = MembershipPlan.planID;

# Show members and their assigned trainers
SELECT Member.first_name, Member.last_name, Trainer.first_name AS trainer_first
FROM Member
JOIN Trainer ON Member.trainerID = Trainer.trainerID;

# Show classes with the trainer who teaches them
SELECT Class.class_name, Trainer.first_name, Trainer.last_name
FROM Class
JOIN Trainer ON Class.trainerID = Trainer.trainerID;

# Show member enrollments with class names
SELECT Member.first_name, Member.last_name, Class.class_name
FROM Enrollment
JOIN Member ON Enrollment.memberID = Member.memberID
JOIN Class ON Enrollment.classID = Class.classID;

#Search Query
SELECT * FROM Member
WHERE planID = 1;

/* -----------------------------
   MEMBERSHIP PLAN (10 ROWS)
------------------------------ */
INSERT INTO MembershipPlan (plan_name, price, duration_months) VALUES
('Basic', 30.00, 1),
('Standard', 50.00, 1),
('Premium', 80.00, 1),
('Elite', 120.00, 1),
('Monthly Flex', 40.00, 1),
('Muscle Max', 70.00, 1),
('Cardio Plus', 55.00, 1),
('Strength Pro', 90.00, 1),
('Wellness Pack', 65.00, 1),
('Full Access', 100.00, 1);

/* -----------------------------
   TRAINER (10 ROWS)
------------------------------ */
INSERT INTO Trainer (first_name, last_name, specialty, email) VALUES
('John', 'Cruz', 'Strength', 'john@gym.com'),
('Maria', 'Lopez', 'Cardio', 'maria@gym.com'),
('Tom', 'Hardy', 'Strength', 'tom.hardy@gym.com'),
('Sarah', 'Nguyen', 'Yoga', 'sarah@gym.com'),
('David', 'Chen', 'Pilates', 'david@gym.com'),
('Emma', 'Stone', 'CrossFit', 'emma@gym.com'),
('Leo', 'Turner', 'Strength', 'leo@gym.com'),
('Nina', 'Khan', 'Cardio', 'nina@gym.com'),
('Chris', 'Allen', 'HIIT', 'chris@gym.com'),
('Olivia', 'Patel', 'Zumba', 'olivia@gym.com');

/* -----------------------------
   MEMBER (10 ROWS)
------------------------------ */
INSERT INTO Member (first_name, last_name, phone, email, start_date, planID, trainerID) VALUES
('Alex', 'Kim', '111-222', 'alex@gmail.com', '2025-01-02', 1, 1),
('Jordan', 'Lee', '333-444', 'jordan@gmail.com', '2025-02-10', 2, 2),
('Fool', 'Hardy', '123-321', 'fool@gmail.com', '2025-03-15', 3, 3),
('Mia', 'Lopez', '555-100', 'mia@gmail.com', '2025-03-20', 4, 4),
('Kevin', 'Tran', '666-200', 'kevin@gmail.com', '2025-04-01', 5, 5),
('Sophia', 'Patel', '777-300', 'sophia@gmail.com', '2025-04-10', 6, 6),
('James', 'Wong', '888-400', 'james@gmail.com', '2025-05-01', 7, 7),
('Ava', 'Brown', '999-500', 'ava@gmail.com', '2025-05-15', 8, 8),
('Noah', 'Garcia', '123-555', 'noah@gmail.com', '2025-06-01', 9, 9),
('Lily', 'Smith', '321-999', 'lily@gmail.com', '2025-06-10', 10, 10);

/* -----------------------------
   CLASS (10 ROWS)
------------------------------ */
INSERT INTO Class (class_name, schedule_date, trainerID, capacity) VALUES
('Yoga', '2025-03-01', 1, 20),
('Strength Training', '2025-03-02', 2, 15),
('Pilates', '2025-03-05', 3, 18),
('Zumba', '2025-03-07', 4, 25),
('HIIT Blast', '2025-03-10', 5, 30),
('Cardio Burn', '2025-03-12', 6, 22),
('Flex Mobility', '2025-03-15', 7, 17),
('Muscle Camp', '2025-03-18', 8, 19),
('Core Strength', '2025-03-20', 9, 24),
('Power Yoga', '2025-03-25', 10, 21);

/* -----------------------------
   ENROLLMENT (10 ROWS)
------------------------------ */
INSERT INTO Enrollment (memberID, classID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
