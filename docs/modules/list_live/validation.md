### Validation Documentation for `Vachan.Crm.List` Module

The `Vachan.Crm.List` module incorporates several validations to ensure data integrity and consistency within the Vachan application. These validations are applied at different stages of the resource lifecycle, such as during creation, updating, and data management processes.

#### Overview of Validations

Validations are critical for enforcing business rules and maintaining data quality. In the `Vachan.Crm.List` module, validations are primarily defined through attributes and actions. Each validation serves a specific purpose, such as ensuring required fields are provided, unique constraints are respected, and relationships are managed correctly.

#### Attribute Validations

1. **Primary Key: `id`**
   - **Type**: `integer`
   - **Validation**: Automatically handled by the database as the primary key. It is unique and non-nullable.

2. **Name: `name`**
   - **Type**: `string`
   - **Validation**: 
     - **`allow_nil?: false`**: Ensures that the `name` attribute cannot be `null`. A name must always be provided when creating or updating a CRM list.
     - **Uniqueness**: Managed through the `identities` block as `unique_list_name`, which enforces the unique constraint on the `name` field across the system.

3. **Timestamps: `created_at`, `updated_at`**
   - **Type**: `timestamp`
   - **Validation**: 
     - Automatically managed by Ash framework through `create_timestamp` and `update_timestamp`. These fields are populated automatically on creation and update, ensuring accurate time tracking of resource changes.

#### Action-Specific Validations

1. **`add_person` Action**
   - **Argument: `person_id`**
     - **Type**: `uuid`
     - **Validation**: 
       - **`allow_nil?: false`**: The `person_id` must be provided and cannot be `null`. This ensures that a valid `person_id` is always passed to the action, preventing attempts to add a `nil` person to a list.
     - **Relationship Management**: 
       - Uses `manage_relationship` to ensure the provided `person_id` is appended to the `people` relationship of the CRM list. This is enforced by Ash to maintain correct associations in the many-to-many relationship.

2. **`remove_person` Action**
   - **Argument: `person_id`**
     - **Type**: `uuid`
     - **Validation**: 
       - **`allow_nil?: false`**: The `person_id` must be provided and cannot be `null`. This prevents attempts to remove a `nil` person from a list.
     - **Relationship Management**: 
       - Uses `manage_relationship` to ensure the provided `person_id` is removed from the `people` relationship of the CRM list. This action is non-atomic, meaning it does not require a database transaction, allowing partial updates without rollback.

3. **`by_id` Action**
   - **Argument: `id`**
     - **Type**: `integer`
     - **Validation**: 
       - **`allow_nil?: false`**: Ensures that an `id` must be provided when fetching a CRM list by its ID. This prevents attempts to retrieve a list with a `nil` ID.
     - **Filter**: Uses `filter expr(id == ^arg(:id))` to ensure the query is correctly filtered based on the provided `id`. This ensures only the specific CRM list with the matching ID is retrieved.

#### Relationship Validations

1. **`people` Relationship**
   - **Type**: `many_to_many`
   - **Validation**:
     - Enforces the relationship between `Vachan.Crm.List` and `Vachan.Crm.Person` through a join resource (`Vachan.Crm.PersonList`).
     - **Attributes on Join Resource**:
       - **`source_attribute_on_join_resource: :list_id`**: Ensures that the join table correctly references the `list_id` from the CRM list.
       - **`destination_attribute_on_join_resource: :person_id`**: Ensures that the join table correctly references the `person_id` from the associated person.

2. **`organization` Relationship**
   - **Type**: `belongs_to`
   - **Validation**:
     - Ensures that each CRM list is associated with an `organization` through a foreign key (`organization_id`).
     - Uses the `domain` block to validate that the `organization` relationship points to a valid `Vachan.Organizations.Organization`.

#### Multitenancy Validations

- **Strategy**: `attribute`
- **Attribute**: `organization_id`
- **Validation**:
  - Ensures data segregation by associating each CRM list with a specific `organization_id`. This prevents cross-tenant data leakage and enforces tenant-specific access controls.

#### Aggregate Validations

1. **`people_count` Aggregate**
   - **Type**: `count`
   - **Validation**:
     - Counts the number of people associated with each CRM list. This is validated by Ash to ensure correct counting and integrity of data.

#### Identity Validations

1. **`unique_list_name` Identity**
   - **Validation**:
     - Enforces that each `name` attribute within `Vachan.Crm.List` must be unique across the entire system. This prevents duplicate list names and ensures each CRM list can be uniquely identified by its `name`.

#### Conclusion

The `Vachan.Crm.List` module leverages Ash's robust validation mechanisms to ensure data integrity, enforce business rules, and maintain consistency across the application's data layer. By defining clear validations at both the attribute and action levels, the module provides a reliable foundation for CRM functionalities while preventing invalid or inconsistent data from entering the system.