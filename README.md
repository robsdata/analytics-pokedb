# 🚧 The Pokémon Combat Stats Lab: An Analytics Engineering Project 🚧

This repository contains a complete Analytics Engineering project designed to demonstrate key competencies in the modern data stack. The goal is to transform a raw Pokémon dataset into a reliable, tested, and analysis-ready data product, following software engineering best practices applied to data.

## 📈 Project Vision

The objective is not merely to analyze Pokémon data, but to build a robust **ELT (Extract, Load, Transform)** pipeline from scratch. This project serves as a tangible proof of my ability to:

- Ingest and clean data using Python.
- Model data for analysis in a data warehouse (PostgreSQL).
- Apply engineering rigor (version control, testing, documentation) using dbt.
- Tell a compelling story with the resulting data.

---

## 🛠️ Tech Stack

| Component | Tool | Purpose |
| :--- | :--- | :--- |
| **Transformation** | dbt Core | Data modeling, testing, documentation. |
| **Data Warehouse** | PostgreSQL (via Docker) | Structured data storage. |
| **Ingestion/Loading** | Python (Pandas) | Initial dataset extraction and cleaning. |
| **Version Control**| Git & GitHub | Code lifecycle management. |
| **Environment** | VS Code | Integrated development environment. |
| **Visualization** | Power BI | Dashboarding and insight validation. |

---

## 🎯 Minimum Viable Product (MVP) - Key Questions

This project focuses on answering three key questions that demonstrate the ability to turn raw data into business insights. Each question corresponds to a specific data mart built with dbt.

1. **Archetype Analysis: What are the most common combat archetypes?**
    - **Objective:** Classify each Pokémon into an archetype (e.g., "Tank", "Glass Cannon", "Sweeper") based on the distribution of their combat stats.
    - **Business Simulation:** Segmenting products into categories to understand the market landscape.

2. **Efficiency Analysis: Which Pokémon are the most statistically efficient for their cost?**
    - **Objective:** Create an `efficiency_score` (e.g., `base_total / base_egg_steps`) and rank Pokémon to identify those offering the most power for less "investment".
    - **Business Simulation:** Calculating the "return on investment" of different products or assets.

3. **Niche Analysis: Who are the "defensive specialists"?**
    - **Objective:** Identify the Pokémon that are resistant to the most types of attacks, finding those that dominate a defensive niche.
    - **Business Simulation:** Identifying products that hold a competitive advantage in a specific market segment.

---

## 📂 Repository Structure

- **`/data`**: Contains the raw `Pokemon.csv` dataset.
- **`/scripts`**: Will contain the Python script (`load_data.py`) for the initial cleaning and loading.
- **`/analytics_pokedb`**: The heart of the project. Contains all dbt models, tests, and configurations.
  - **`/models`**:
    - **`/staging`**: Models for cleaning and standardizing raw data.
    - **`/marts`**: Business-ready dimensional data models.
  - **`dbt_project.yml`**: Main dbt project configuration file.
- **`README.md`**: This documentation file.

---

## 🚀 Execution Roadmap

- **Phase 0: Foundation** - Setting up the development stack (Docker, dbt, etc.).
- **Phase 1: Ingestion & Loading** - Loading the dataset into PostgreSQL using Python.
- **Phase 2: Transformation** - Building dbt models and applying tests.
- **Phase 3: Analysis** - Connecting Power BI and answering the MVP questions.
- **Phase 4: Documentation** - Finalizing the README and generating dbt docs.