# Vachan.Massmail.Campaign Documentation  

## Overview

The Vachan.Massmail.Campaign module is part of the Vachan Massmail system, designed to manage and execute email campaigns. This module leverages the Ash framework for defining resources, integrates with PostgreSQL for data storage, supports multitenancy, and manages the state transitions of a campaign using a state machine.

## Key Functionalities

### Resource Description
Describes the purpose of the resource as managing email campaigns, including adding content, recipients, and associating sender profiles.

### PostgreSQL Integration
- Specifies the table name as campaigns.
- Utilizes the Vachan.Repo repository for database operations.

### Multitenancy Support
Multitenancy allows multiple organizations (tenants) to use the same application while keeping their data isolated. Here's how it is implemented in this module:

- Strategy: The module uses an attribute-based strategy for multitenancy.
- Attribute: It differentiates tenants by the organization_id attribute.

## Detailed Explanation:

- Attribute-Based Strategy: Every record in the campaigns table includes an organization_id attribute, indicating which organization the record belongs to.

- Isolating Data: When performing operations like create, read, update, or delete, the system uses the organization_id to ensure that users can only access data that belongs to their organization. 

This ensures that data remains isolated and secure, allowing multiple organizations to coexist within the same application.

## State Machine
Manages the various states of a campaign, providing a structured flow from creation to completion:

- Initial State: The default initial state is :new.
- Transitions: The module defines transitions for moving between different states in the campaign lifecycle:
- transition(:add_content, from: :new, to: :content_added): Defines a transition from the :new state to the :content_added state when the add_content action is triggered.

Similar transitions are defined for moving the campaign through different stages, such as adding recipients, associating a sender profile, sending a test email, starting the sending process, handling errors, and marking the campaign as complete.

## Code Interface
Defines methods for common CRUD operations and specific actions:

- create: Create a new campaign.
- update: Update an existing campaign.
- destroy: Delete a campaign.
- read_all: Retrieve all campaigns.
- get_by_id: Retrieve a campaign by its ID.
- associate_sender_profile: Associate a sender profile with the campaign.
- associate_contact_list: Associate a contact list with the campaign.

## Actions
Provides default actions for create, read, update, and destroy operations.
Specifies that all fields are accepted by default.
Defines specific actions:
- create: The primary action for creating a campaign, which accepts name and optionally list_id.
- update: The primary action for updating campaign details, including managing relationships with a contact list.
- associate_contact_list: Associates a contact list with the campaign by managing the relationship.
- add_content: Adds content to the campaign and changes its state to :content_added.
- add_recepients: Adds recipients to the campaign and changes the state to :recepients_added.

## Attributes
Defines attributes for the campaigns table:
- id: Integer primary key.
- name: String attribute for the campaign name, which cannot be null.
- active?: Boolean indicating if the campaign is active, defaults to true.
- deleted?: Boolean indicating if the campaign is deleted, defaults to false.
- created_at: Timestamp for when the campaign is created.
- updated_at: Timestamp for when the campaign is last updated.

## Relationships
Establishes relationships with other entities:
- recepients: One-to-one relationship with Vachan.Massmail.Recepients.
- content: One-to-one relationship with Vachan.Massmail.Content.
- messages: One-to-many relationship with Vachan.Massmail.Message.
- contact_list: Belongs to a contact list (Vachan.Crm.List).
- organization: Belongs to an organization (Vachan.Organizations.Organization).
- sender_profile: Belongs to a sender profile (Vachan.SenderProfiles.SenderProfile).

## Conclusion
The Vachan.Massmail.Campaign module is a comprehensive resource within the Vachan Massmail system, designed to manage and execute email campaigns. It integrates seamlessly with PostgreSQL, supports multitenancy, and uses a state machine for managing the campaign lifecycle. The module provides a well-defined code interface and actions for managing campaigns and their relationships with other entities.