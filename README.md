# Gym Management System

A relational database project for managing gym members, trainers, membership plans, classes, and enrollments.

The project includes a five-table schema, an ER diagram, sample data, operational queries, and checks for invalid records.

## Database design

| Table | Purpose |
|---|---|
| MembershipPlan | Plan names, prices, and durations |
| Trainer | Trainer details and salaries |
| Member | Member details and assigned plans and trainers |
| Class | Scheduled classes, assigned trainers, and capacity |
| Enrollment | Links between members and classes |

Enrollment represents the many-to-many relationship between members and classes.

## Data integrity

The schema uses primary keys and foreign keys to maintain relationships. It also prevents duplicate enrollment in the same class and rejects invalid values for prices, durations, and capacities.

Deleting a member or class removes its associated enrollments. Deleting a referenced trainer or membership plan leaves the related record in place and clears the assignment.

A positive class capacity is enforced. Automatic prevention of overbooking is outside this version’s scope.

## Run locally

Use a disposable local MySQL database for this project.

MySQL 8.0.16 or later is required. Earlier versions do not enforce CHECK constraints.

```bash
git clone https://github.com/Niyog59/Gym-Management-Project-MySQL.git
cd Gym-Management-Project-MySQL
mysql -u root -p < sql/01_create_tables.sql
mysql -u root -p < sql/02_insert_data.sql
mysql -u root -p GymDB < sql/03_use_case_queries.sql
```

The use-case script changes sample records as well as running SELECT queries. Run it against the project’s sample database.

Ordinary setup does not silently delete an existing database. Resetting the project is a separate destructive operation.

```bash
mysql -u root -p < sql/reset_database.sql
```

This command deletes GymDB and its contents. Use it only when you intend to discard the local project data.

## Verify the constraints

The verification script checks expected failures as well as valid operations. Run it only against a disposable local database.

```bash
mysql -u root -p GymDB < sql/04_verify_constraints.sql
```

## ER diagram

![ER diagram](images/er_diagram.png)

## Original submission

The report files and original SQL script preserve the original submission. The current schema includes later improvements, so the original report may not describe every constraint in the current version.

- [Original report](report/Gym_Management_Report.pdf)
- [Original SQL](sql/original/gym_management_original.sql)
