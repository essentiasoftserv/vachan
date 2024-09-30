## Validations

  ### `id`
  - Ensure it is unique and not null

  ### `name`
- Ensure name is not null and is a non-empty string.
- Ensure name is within the maximum length constraint.
- It cannot be more than 64 characters long.
- Ensure name only contains valid characters (e.g., letters and spaces)
- Must follow the format(e.g. ~r/^[a-zA-Z\s]+$/)