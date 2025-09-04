# Orchestrated Multi-Target Migration Deployment

## Feature Request: Orchestration Workflow for Database Migrations

### Description
Introduce an orchestration workflow that enables users to define and execute database migrations across multiple targets in a specific order. The workflow is managed via an `migrations/orchestration.plan` file, which lists migrations as `<target>:<migration>` pairs. A dedicated script (`scripts/orchestrate_plan.sh`) reads this plan and applies each migration to its respective target using Sqitch.

### Key Capabilities
- **Centralized Migration Plan:**
  - Users maintain a single `migrations/orchestration.plan` file to specify the order and target of each migration.
- **Automated Execution:**
  - The orchestration script (`scripts/orchestrate_plan.sh`) parses the plan and applies migrations sequentially, ensuring dependencies and order are respected.
- **Multi-Target Support:**
  - Supports deploying migrations to multiple database targets (e.g., `local@my_app`, `local@my_app_replica`), as defined in `sqitch.conf`.
- **Error Handling:**
  - Stops execution and reports errors if any migration fails, ensuring consistency.
- **Integration with Existing Workflow:**
  - Can be triggered automatically after database startup (`scripts/db.sh`), or manually as needed.

### User Story
_As a developer, I want to define and orchestrate migrations across multiple database targets in a single plan file, so that I can ensure migrations are applied in the correct order and to the correct databases without manual intervention._

### Example Workflow
1. Add migration entries to `migrations/orchestration.plan`:
    ```
    local@my_app:01_publisher
    local@my_app_replica:02_subscriber
    local@my_app:03_some_table
    local@my_app:04_test
    ```
2. Run orchestration script:
    ```sh
    scripts/orchestrate_plan.sh
    ```
3. Each migration is applied to its target in order, with status output and error handling.

### References
- `scripts/orchestrate_plan.sh`
- `migrations/orchestration.plan`
- `sqitch.conf`
- `scripts/db.sh`

---
This feature streamlines multi-database migration management and reduces manual deployment errors.
