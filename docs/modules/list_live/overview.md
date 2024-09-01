### Documentation for `Vachan.Crm.List` Module

#### Overview

The `Vachan.Crm.List` module is an Ash resource that represents a CRM (Customer Relationship Management) list within the Vachan application. This module allows for the segmentation of people into targeted lists for specific campaigns. It leverages Ash's resource capabilities, including actions, relationships, pub/sub notifications, and aggregates, to manage CRM lists and their associations with people.

#### What Does the Feature Do?

The `Vachan.Crm.List` module provides the following key functionalities:

1. **CRUD Operations**: Supports standard create, read, update, and destroy actions for CRM lists.
2. **Multi-Tenancy**: Uses attribute-based multitenancy, where each CRM list is associated with an `organization_id`.
3. **Pub/Sub Notifications**: Integrates with Phoenix's PubSub system to publish events (`created`, `updated`, `destroyed`) for real-time notifications.
4. **Relationship Management**: Manages many-to-many relationships between CRM lists and people, allowing dynamic addition and removal of people from lists.
5. **Custom Actions**:
   - `add_person`: Adds a person to a list.
   - `remove_person`: Removes a person from a list.
   - `by_id`: Reads a CRM list by its ID.
6. **Aggregates**: Provides a count of people associated with each list.
7. **Code Interface**: Exposes actions through a defined code interface for easy access and invocation.

#### What Dependencies Does It Have?

- **Ash Framework**: Provides the base resource capabilities and actions.
- **AshPostgres**: The data layer that integrates with a PostgreSQL database.
- **Phoenix PubSub**: For broadcasting notifications about changes to CRM lists.
- **Vachan.Repo**: The Ecto repository used for database interactions.
- **Vachan.Crm.Person**: Represents the people that are managed in conjunction with CRM lists.
- **Vachan.Crm.PersonList**: Join table for the many-to-many relationship between lists and people.
- **Vachan.Organizations.Organization**: Represents the organization to which each list belongs.

#### Where Can the User Access It From?

Users can interact with the `Vachan.Crm.List` module via the following interfaces:

- **Code Interface**: The `code_interface` block defines a set of functions (`create`, `update`, `destroy`, `read_all`, `get_by_id`, `add_person`, `remove_person`) that can be called directly in the codebase.
- **Pub/Sub Subscriptions**: Users can subscribe to Phoenix PubSub topics (`list:created`, `list:updated`, `list:destroyed`) to receive real-time updates about changes to CRM lists.
- **API Layer (if exposed)**: If the module is exposed through an API (not shown in this code), users can access it via HTTP requests.
- **Admin or CRM UI**: Any front-end interface (like a CRM UI) integrated with these Ash resources will provide access to these functionalities.

#### Submodules and Details

1. **Actions**:
   - **Default Actions**: `create`, `read`, `update`, `destroy` are provided by default to handle basic CRUD operations.
   - **Custom Actions**:
     - `add_person`: Adds a person to the CRM list using the `person_id`.
     - `remove_person`: Removes a person from the CRM list using the `person_id`.
     - `by_id`: Custom read action to fetch a CRM list by its ID.

2. **Attributes**:
   - **Primary Key**: `id` (integer)
   - **Name**: A non-nullable string attribute representing the list's name.
   - **Timestamps**: Automatically maintained `created_at` and `updated_at` timestamps.

3. **Relationships**:
   - **many_to_many**: `people` relationship connecting `Vachan.Crm.Person` through `Vachan.Crm.PersonList`.
   - **belongs_to**: `organization` relationship connecting to `Vachan.Organizations.Organization`.

4. **Aggregates**:
   - **people_count**: Counts the number of people associated with each list.

5. **Pub/Sub Configuration**:
   - **Module**: `VachanWeb.Endpoint` is used for broadcasting.
   - **Topics**: Prefix `list` is used to create topics like `list:created`, `list:updated`, `list:destroyed`.
   - **Broadcast Type**: Uses `:phoenix_broadcast` for pub/sub notifications.

6. **Multitenancy Configuration**:
   - **Strategy**: Attribute-based multitenancy.
   - **Attribute**: `organization_id` is used to separate data per tenant (organization).

7. **Identities**:
   - **unique_list_name**: Ensures that the `name` of each list is unique within the system.

This module integrates seamlessly with Ash's data management and policy enforcement layers, providing a robust foundation for CRM functionalities within the Vachan application.