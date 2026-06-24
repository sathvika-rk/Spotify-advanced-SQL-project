# Spotify-advanced-SQL-project
An end-to-end SQL project analyzing Spotify tracks data, culminating in automated window functions and B-Tree query index optimizations.
# Spotify Advanced SQL Optimization Project

## Project Overview
This project involves a comprehensive analysis of a Spotify dataset containing over 20,000 tracks. It covers database migration, data cleaning, advanced SQL querying (CTEs, Window Functions, Subqueries), and query performance optimization using B-Tree indexing.

## Tech Stack
* **Database:** PostgreSQL 18
* **Interface:** pgAdmin 4 / PSQL Terminal
* **Concepts:** DDL, DML, Window Functions, Common Table Expressions, Performance Tuning

## Key Accomplishments

### 1. Data Cleaning & Integrity
* Identified and deleted structural anomalies where track durations were recorded as `0` minutes, ensuring downstream analytical calculation accuracy.

### 2. Advanced Analytics Solved
* Implemented complex business logic including tracking rolling cumulative stream volume per artist using dynamic window partitions.
* Utilized multi-layered CTE architectures to measure metrics variance (e.g., energy spreads across studio albums).

### 3. Query Optimization (Performance Engineering)
A major component of this project was analyzing and improving execution workflows for enterprise-scale queries.

* **Before Optimization:** A direct filter on the `artist` column forced a **Sequential Scan**, reading all 20,000+ records row-by-row.
  * *Execution Time:* **6.014 ms**
* **Optimization Strategy:** Implemented a targeted B-Tree index map on the filtered lookup layer:
  ```sql
  CREATE INDEX idx_spotify_artist ON spotify(artist);
After Optimization: PostgreSQL automatically adjusted execution plans to a highly parallelized Bitmap Heap Scan.

Execution Time: 0.540 ms

Result: Achieved a 91% reduction in latency (11x speed performance upgrade).
