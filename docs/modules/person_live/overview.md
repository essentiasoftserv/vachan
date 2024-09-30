# User Module Documentation

 ## Overview

 The `Vachan.Profiles.Profile` module defines how profile data is managed within the application. It includes the ability to create, read, update, and interact with profile records in the database.


 ### Resource Description

 The Vachan.Profiles module, along with its Profile resource, forms part of a broader system for managing user-related data in an organized, secure, and modular way using the Ash framework. The use of domains and resources in Ash allows for clean separation of concerns and clear authorization policies, ensuring that user data is handled securely and appropriately.

 Access to this resource is controlled, requiring an actor (such as an authenticated user) to interact with it. By default, authorization checks are enforced, meaning that specific permissions will be needed for different actions (like reading, updating, or deleting profiles).


  ### PostgreSQL Integration
- Table: The resource is linked to the `profiles` table in PostgreSQL.
- Repo: Uses `Vachan.Repo` as the repository for database operations.
- Data Layer: Uses `AshPostgres.DataLayer` to interface with PostgreSQL.

 ### Multitenancy Support
- No explicit multitenancy support is defined. The resource operates in a single-tenant model.
 
 # What dependencies does it have?

 **Ash Framework**: The module depends on the Ash framework, particularly `Ash.Resource` and `Ash.Policy.Authorizer` for defining resources and authorization policies.
 **AshPostgres**: It uses `AshPostgres.DataLayer` to interface with a PostgreSQL database, suggesting that the application needs to have PostgreSQL set up and configured.
 **Vachan.Accounts.User**: The Profile resource is related to a User resource, indicating that there is a user management system defined under Vachan.Accounts.
 **Vachan.Repo**: This is the Ecto repository module where the database interactions are handled. It suggests that the application uses Ecto for database access and management.


 ### Code Interface

 - Defines methods for common CRUD operations and specific actions:
 - `create`: Create a new profile.
 - `update`: Updates an existing profile.
 - `read`: Retrieve profile(s).
 - `read_all`: Retrieve all profiles.
 - `get_by_id`: Retrieve a profile by its ID.

 ### Actions

 - Provides default actions for create, read, and update operations.
 - Specifies that all fields are accepted by default.

 - Defines specific actions:
 - `create`: Creates a new profile, requires that the actor's confirmed_at attribute is not nil.
 - `update`: Updates an existing profile, requires that the profile is related to the actor via the owner relationship.
 - `read`: Retrieves profile(s), requires that the actor's confirmed_at attribute is not nil.

 ### Relationship

 Defines the following relationship:
 
- `belongs_to` :owner: Specifies that a profile belongs to a user (owner). 
- The relationship is managed via the `id` attribute in both the - Profile and User schemas, and it belongs to the `Vachan.Accounts` domain.


### Attributes

- Defines attributes for the `profiles` table:
  - `id`: A UUID that serves as the primary key, must not be nil, and is publicly accessible.
  - `name`: A string that cannot be nil, has a maximum length of 64 characters, and is publicly accessible.


### Unique Identity

- The unique identity of the profile is primarily based on the id attribute, which is a UUID and also serves as the primary key.


 ### Conclusion

 - The Vachan.Profiles.Profile module is a well-defined Ash resource that integrates with PostgreSQL using the AshPostgres.DataLayer.
 - It includes basic CRUD actions, enforces some policies for authorization, and manages relationships with user accounts.
 - The resource is focused on a single-tenant model and does not currently have pubsub notifications or multitenancy implemented. 


