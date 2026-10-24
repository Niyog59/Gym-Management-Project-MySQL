# Gym Management System
# Step 1: create the database and the 5 tables
# Requires MySQL 8.0.16 or later (earlier versions parse CHECK constraints but do not enforce them).
# Stops with an error if GymDB already exists. To start over, run sql/reset_database.sql first.

CREATE DATABASE GymDB;
USE GymDB;

CREATE TABLE MembershipPlan (
    planID INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    duration_months INT NOT NULL,
    CONSTRAINT chk_plan_price_nonnegative CHECK (price >= 0),
    CONSTRAINT chk_plan_duration_positive CHECK (duration_months > 0)
);

CREATE TABLE Trainer (
    trainerID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(50),
    email VARCHAR(100),
    salary DECIMAL(10,2),
    CONSTRAINT chk_trainer_salary_nonnegative CHECK (salary >= 0)
);

# If a plan or trainer gets deleted, the member stays but that field becomes NULL,
# so planID and trainerID stay nullable
CREATE TABLE Member (
    memberID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    start_date DATE NOT NULL,
    planID INT,
    trainerID INT,
    CONSTRAINT fk_member_plan FOREIGN KEY (planID) REFERENCES MembershipPlan(planID) ON DELETE SET NULL,
    CONSTRAINT fk_member_trainer FOREIGN KEY (trainerID) REFERENCES Trainer(trainerID) ON DELETE SET NULL
);

# If a trainer gets deleted, the class stays but trainerID becomes NULL.
# capacity > 0 checks each class on its own; it does not stop a class being overbooked.
CREATE TABLE Class (
    classID INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    schedule_date DATE NOT NULL,
    trainerID INT,
    capacity INT NOT NULL,
    CONSTRAINT chk_class_capacity_positive CHECK (capacity > 0),
    CONSTRAINT fk_class_trainer FOREIGN KEY (trainerID) REFERENCES Trainer(trainerID) ON DELETE SET NULL
);

# If a member or class gets deleted, their enrollments get deleted too.
# A member can only be enrolled in the same class once.
CREATE TABLE Enrollment (
    enrollID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT NOT NULL,
    classID INT NOT NULL,
    CONSTRAINT uq_enrollment_member_class UNIQUE (memberID, classID),
    CONSTRAINT fk_enrollment_member FOREIGN KEY (memberID) REFERENCES Member(memberID) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_class FOREIGN KEY (classID) REFERENCES Class(classID) ON DELETE CASCADE
);
