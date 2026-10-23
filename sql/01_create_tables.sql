# Gym Management System
# Step 1: create the database and the 5 tables

DROP DATABASE IF EXISTS GymDB;
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

# If a plan or trainer gets deleted, the member stays but that field becomes NULL
CREATE TABLE Member (
    memberID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    start_date DATE,
    planID INT,
    trainerID INT,
    FOREIGN KEY (planID) REFERENCES MembershipPlan(planID) ON DELETE SET NULL,
    FOREIGN KEY (trainerID) REFERENCES Trainer(trainerID) ON DELETE SET NULL
);

CREATE TABLE Class (
    classID INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50),
    schedule_date DATE,
    trainerID INT,
    capacity INT,
    FOREIGN KEY (trainerID) REFERENCES Trainer(trainerID) ON DELETE SET NULL
);

# If a member or class gets deleted, their enrollments get deleted too
CREATE TABLE Enrollment (
    enrollID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT,
    classID INT,
    FOREIGN KEY (memberID) REFERENCES Member(memberID) ON DELETE CASCADE,
    FOREIGN KEY (classID) REFERENCES Class(classID) ON DELETE CASCADE
);
