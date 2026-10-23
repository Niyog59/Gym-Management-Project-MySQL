# Gym Management System
# Step 2: sample data (10 rows per table)

USE GymDB;

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

INSERT INTO Trainer (first_name, last_name, specialty, email, salary) VALUES
('John', 'Cruz', 'Strength', 'john@gym.com', 4000),
('Maria', 'Lopez', 'Cardio', 'maria@gym.com', 4200),
('Tom', 'Hardy', 'Strength', 'tom.hardy@gym.com', 4000),
('Sarah', 'Nguyen', 'Yoga', 'sarah@gym.com', 3800),
('David', 'Chen', 'Pilates', 'david@gym.com', 3900),
('Emma', 'Stone', 'CrossFit', 'emma@gym.com', 4500),
('Leo', 'Turner', 'Strength', 'leo@gym.com', 4100),
('Nina', 'Khan', 'Cardio', 'nina@gym.com', 3700),
('Chris', 'Allen', 'HIIT', 'chris@gym.com', 4300),
('Olivia', 'Patel', 'Zumba', 'olivia@gym.com', 3600);

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

SELECT * FROM MembershipPlan;
SELECT * FROM Trainer;
SELECT * FROM Member;
SELECT * FROM Class;
SELECT * FROM Enrollment;
