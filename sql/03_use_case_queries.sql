# Gym Management System
# Step 3: the use case queries from the report
# Run this after 01_create_tables.sql and 02_insert_data.sql

USE GymDB;

#Inserting

# Insert a new member
INSERT INTO Member (first_name, last_name, phone, email, start_date, planID, trainerID)
VALUES ('Fool', 'Hardy', '111-222', 'fool.hardy@gmail.com', '2025-10-11', 1, 1);

# Insert a new trainer
INSERT INTO Trainer (first_name, last_name, specialty, email, salary)
VALUES ('Tom', 'Hardy', 'Strength', 'tom.hardy@gym.com', 4000);

# Insert a new class
INSERT INTO Class (class_name, schedule_date, trainerID, capacity)
VALUES ('Pilates', '2025-06-07', 1, 18);

# Insert a new membership plan
INSERT INTO MembershipPlan (plan_name, price, duration_months)
VALUES ('Elite', 120.00, 1);

# Enroll a member into a class
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

# Delete an enrollment
DELETE FROM Enrollment
WHERE enrollID = 2;

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

#Aggregate

# Count total members
SELECT COUNT(*) AS total_members
FROM Member;

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

# Show members and the plans they belong to
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

# Search members by plan
SELECT * FROM Member
WHERE planID = 1;
