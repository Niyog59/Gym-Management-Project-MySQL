# Gym Management System
# Step 4: check that the constraints reject bad data and that deletes behave as intended.
# Run after 01_create_tables.sql. Use a disposable local database.
#
# The checks run inside a transaction that is rolled back at the end, so the test
# rows are not kept (AUTO_INCREMENT counters still move forward).
# Each expected failure is caught by its specific MySQL error code. Any other
# error stops the script, and the script ends with an error if any check fails.

USE GymDB;

DROP PROCEDURE IF EXISTS verify_constraints;

# MEMORY tables ignore ROLLBACK, so the results survive it
DROP TEMPORARY TABLE IF EXISTS verify_results;
CREATE TEMPORARY TABLE verify_results (
    check_no INT AUTO_INCREMENT PRIMARY KEY,
    check_name VARCHAR(100) NOT NULL,
    result VARCHAR(4) NOT NULL
) ENGINE = MEMORY;

DELIMITER //

CREATE PROCEDURE verify_constraints()
BEGIN
    DECLARE v_plan INT;
    DECLARE v_trainer INT;
    DECLARE v_member INT;
    DECLARE v_class INT;
    DECLARE v_count INT;

    # ---------- valid operations ----------

    INSERT INTO MembershipPlan (plan_name, price, duration_months) VALUES ('Verify Plan', 25.00, 3);
    SET v_plan = LAST_INSERT_ID();
    INSERT INTO Trainer (first_name, last_name, specialty, email, salary) VALUES ('Verify', 'Trainer', 'Testing', 'verify.trainer@gym.test', 3500);
    SET v_trainer = LAST_INSERT_ID();
    INSERT INTO Member (first_name, last_name, phone, email, start_date, planID, trainerID)
        VALUES ('Verify', 'Member', '000-000', 'verify.member@gym.test', '2025-01-01', v_plan, v_trainer);
    SET v_member = LAST_INSERT_ID();
    INSERT INTO Class (class_name, schedule_date, trainerID, capacity) VALUES ('Verify Class', '2025-01-15', v_trainer, 10);
    SET v_class = LAST_INSERT_ID();
    INSERT INTO Enrollment (memberID, classID) VALUES (v_member, v_class);
    INSERT INTO verify_results (check_name, result) VALUES ('Valid plan, trainer, member, class and enrollment are accepted', 'PASS');

    BEGIN
        DECLARE CONTINUE HANDLER FOR 3819 SET v_count = -1;
        SET v_count = 0;
        INSERT INTO MembershipPlan (plan_name, price, duration_months) VALUES ('Verify Free Plan', 0.00, 1);
        INSERT INTO verify_results (check_name, result) VALUES ('Plan with price 0 is accepted', IF(v_count = 0, 'PASS', 'FAIL'));
    END;

    # ---------- duplicate enrollment ----------

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 1062 SET rejected = TRUE;
        INSERT INTO Enrollment (memberID, classID) VALUES (v_member, v_class);
        INSERT INTO verify_results (check_name, result) VALUES ('Duplicate enrollment is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    # ---------- invalid values ----------

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        INSERT INTO MembershipPlan (plan_name, price, duration_months) VALUES ('Bad Price', -1.00, 1);
        INSERT INTO verify_results (check_name, result) VALUES ('Negative plan price is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        INSERT INTO MembershipPlan (plan_name, price, duration_months) VALUES ('Bad Duration', 10.00, 0);
        INSERT INTO verify_results (check_name, result) VALUES ('Plan duration of 0 months is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        INSERT INTO Trainer (first_name, last_name, salary) VALUES ('Bad', 'Salary', -100);
        INSERT INTO verify_results (check_name, result) VALUES ('Negative trainer salary is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        INSERT INTO Class (class_name, schedule_date, trainerID, capacity) VALUES ('Bad Capacity', '2025-01-20', v_trainer, 0);
        INSERT INTO verify_results (check_name, result) VALUES ('Class capacity of 0 is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 3819 SET rejected = TRUE;
        UPDATE Class SET capacity = -5 WHERE classID = v_class;
        INSERT INTO verify_results (check_name, result) VALUES ('Updating a class to a negative capacity is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 1048 SET rejected = TRUE;
        INSERT INTO Enrollment (memberID, classID) VALUES (v_member, NULL);
        INSERT INTO verify_results (check_name, result) VALUES ('Enrollment without a class is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    # ---------- invalid foreign keys ----------

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 1452 SET rejected = TRUE;
        INSERT INTO Enrollment (memberID, classID) VALUES (999999, v_class);
        INSERT INTO verify_results (check_name, result) VALUES ('Enrollment for a member that does not exist is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 1452 SET rejected = TRUE;
        INSERT INTO Member (first_name, last_name, start_date, planID) VALUES ('Bad', 'Plan', '2025-01-01', 999999);
        INSERT INTO verify_results (check_name, result) VALUES ('Member with a plan that does not exist is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    BEGIN
        DECLARE rejected BOOL DEFAULT FALSE;
        DECLARE CONTINUE HANDLER FOR 1452 SET rejected = TRUE;
        INSERT INTO Class (class_name, schedule_date, trainerID, capacity) VALUES ('Bad Trainer', '2025-01-20', 999999, 10);
        INSERT INTO verify_results (check_name, result) VALUES ('Class with a trainer that does not exist is rejected', IF(rejected, 'PASS', 'FAIL'));
    END;

    # ---------- deletion behavior ----------

    # Deleting a trainer keeps the member and class but clears the assignment
    DELETE FROM Trainer WHERE trainerID = v_trainer;
    SELECT COUNT(*) INTO v_count FROM Member WHERE memberID = v_member AND trainerID IS NULL;
    INSERT INTO verify_results (check_name, result) VALUES ('Deleting a trainer keeps the member and clears Member.trainerID', IF(v_count = 1, 'PASS', 'FAIL'));
    SELECT COUNT(*) INTO v_count FROM Class WHERE classID = v_class AND trainerID IS NULL;
    INSERT INTO verify_results (check_name, result) VALUES ('Deleting a trainer keeps the class and clears Class.trainerID', IF(v_count = 1, 'PASS', 'FAIL'));

    # Deleting a plan keeps the member but clears the assignment
    DELETE FROM MembershipPlan WHERE planID = v_plan;
    SELECT COUNT(*) INTO v_count FROM Member WHERE memberID = v_member AND planID IS NULL;
    INSERT INTO verify_results (check_name, result) VALUES ('Deleting a plan keeps the member and clears Member.planID', IF(v_count = 1, 'PASS', 'FAIL'));

    # Deleting a class removes its enrollments
    DELETE FROM Class WHERE classID = v_class;
    SELECT COUNT(*) INTO v_count FROM Enrollment WHERE classID = v_class;
    INSERT INTO verify_results (check_name, result) VALUES ('Deleting a class removes its enrollments', IF(v_count = 0, 'PASS', 'FAIL'));

    # Deleting a member removes their enrollments
    INSERT INTO Class (class_name, schedule_date, capacity) VALUES ('Verify Class 2', '2025-02-01', 5);
    SET v_class = LAST_INSERT_ID();
    INSERT INTO Enrollment (memberID, classID) VALUES (v_member, v_class);
    DELETE FROM Member WHERE memberID = v_member;
    SELECT COUNT(*) INTO v_count FROM Enrollment WHERE memberID = v_member;
    INSERT INTO verify_results (check_name, result) VALUES ('Deleting a member removes their enrollments', IF(v_count = 0, 'PASS', 'FAIL'));
END //

DELIMITER ;

START TRANSACTION;
CALL verify_constraints();
ROLLBACK;

DROP PROCEDURE verify_constraints;

SELECT check_no, check_name, result FROM verify_results ORDER BY check_no;

SELECT COUNT(*) AS checks_run, SUM(result = 'PASS') AS passed, SUM(result = 'FAIL') AS failed FROM verify_results;

# End with an error (non-zero exit from the mysql client) if any check failed
DELIMITER //
DROP PROCEDURE IF EXISTS verify_fail_if_needed //
CREATE PROCEDURE verify_fail_if_needed()
BEGIN
    IF (SELECT COUNT(*) FROM verify_results WHERE result = 'FAIL') > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more constraint checks failed';
    END IF;
END //
DELIMITER ;

CALL verify_fail_if_needed();
DROP PROCEDURE verify_fail_if_needed;
DROP TEMPORARY TABLE verify_results;
