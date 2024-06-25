# Vachan.Crm.List Module Documentation

## Overview

The `Vachan.Crm.List` module is part of the Vachan CRM system. It is designed to manage lists of people for targeting specific campaigns. This module leverages the Ash framework for defining resources and integrates with PostgreSQL for data storage, Phoenix PubSub for notifications, and supports multitenancy.

## Key Functionalities

### Resource Description

- Describes the purpose of the resource as segmenting people for targeted campaigns.

### PostgreSQL Integration

- Specifies the table name as `crm_lists`.
- Utilizes the `Vachan.Repo` repository for database operations.

### Multitenancy Support

Multitenancy allows multiple organizations (tenants) to use the same application while keeping their data isolated. Here's how it is implemented in this module:

- **Strategy**: The module uses an attribute-based strategy for multitenancy.
- **Attribute**: It differentiates tenants by the `organization_id` attribute.

**Detailed Explanation:**

1. **Attribute-Based Strategy**: This means that every record in the `crm_lists` table includes an `organization_id` attribute. This attribute indicates which organization the record belongs to.
2. **Isolating Data**: When performing operations like create, read, update, or delete, the system uses the `organization_id` to ensure that users can only access data that belongs to their organization. For example, when a user from Organization A queries the lists, the system will filter the results to show only the lists where `organization_id` matches Organization A's ID.

This strategy ensures that data remains isolated and secure, allowing multiple organizations to coexist within the same application without interfering with each other.

### PubSub Notifications

- Configures PubSub with the `VachanWeb.Endpoint` module.
- Sets a prefix for PubSub topics as `list`.
- Defines broadcast types and events for create, update, and destroy actions to notify subscribers.

### Code Interface

- Defines methods for common CRUD operations and specific actions:
  - `create`: Create a new list.
  - `update`: Update an existing list.
  - `destroy`: Delete a list.
  - `read_all`: Retrieve all lists.
  - `get_by_id`: Retrieve a list by its ID.
  - `add_person`: Add a person to a list.
  - `remove_person`: Remove a person from a list.

### Actions

- Provides default actions for create, read, update, and destroy operations.
- Specifies that all fields are accepted by default.
- Defines specific actions:
  - `add_person`: Adds a person to the list by managing the relationship.
  - `remove_person`: Removes a person from the list by managing the relationship.
  - `by_id`: Retrieves a list by its ID with a required integer argument.

### Attributes

- Defines attributes for the `crm_lists` table:
  - `id`: Integer primary key.
  - `name`: String attribute for the list name, which cannot be null and is public.
  - `created_at`: Timestamp for when the list is created.
  - `updated_at`: Timestamp for when the list is last updated.

### Relationships

- Establishes relationships with other entities:
  - `people`: Many-to-many relationship with `Vachan.Crm.Person` through the `Vachan.Crm.PersonList` join table.
  - `organization`: Belongs to `Vachan.Organizations.Organization`.

### Unique Identity

- Ensures the list name is unique across the system using the `unique_list_name` identity.

## Conclusion

The `Vachan.Crm.List` module is a comprehensive resource within the Vachan CRM system designed to manage and segment lists of people for targeted marketing campaigns. It integrates seamlessly with PostgreSQL, supports multitenancy, and uses Phoenix PubSub for real-time notifications. The module provides a well-defined code interface and actions for managing lists and their relationships with other entities.