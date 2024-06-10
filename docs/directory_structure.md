# Directory structure

~~~bash 
Vachan/ 
│ ├── assets/  
│ 	├── css/  
│ 	├── js/  
│ 	├── vendor/  
│ 	├── package-lock.json  
│ 	├── package.json  
│ 	└── tailwind.config.js 
│ ├── config/  
│ 	├── config.exs  
│ 	├── dev.exs  
│ 	├── prod.exs  
│ 	├── runtime.exs  
│ 	└── test.exs  
│ ├── docs/  
│ 	├── API.md  
│ 	├── deployment.md  
│ 	├── introduction.md  
│ 	└── directory_structure.md  
│ ├── lib/  
│ 	├── vachan/
│ 	├── vachan_web/ 
│ 	├── vachan_web.ex  
│ 	└── vachan.ex    
│ ├── priv/  
│ 	├── ...  
│ ├── rel/  
│ 	├── ...  
│ └── test/  
├── ...
~~~


## Assets

The `assets` directory contains front-end assets such as CSS, JavaScript, and vendor packages.

## Config

The `config` directory contains configuration files for different environments.

- `config.exs`: Main configuration file.
- `dev.exs`: Development environment configuration.
- `prod.exs`: Production environment configuration.
- `runtime.exs`: Runtime configuration.
- `test.exs`: Test environment configuration.

## Docs

The `docs` directory contains documentation files for the project.

- `API/`: API documentation.
- `deployment/`: Deployment instructions.
- `introduction/`: Introduction to the project.
- `directory_structure.md`: Documentation for the directory structure (this file).

## Lib

The `lib` directory contains Elixir source code files.

~~~bash
│ ├── lib/  
│ 	├── vachan/
│ 	├── vachan_web/ 
│ 	├── vachan_web.ex  
│ 	└── vachan.ex   
~~~
The `lib/` directory is the core of the Elixir application, where most of the business logic resides. It follows Elixir's convention of keeping source files organized in a hierarchical structure. 

### `vachan/`

The `vachan/` directory contains modules related to various features of the application.

- `accounts/`: Manages user accounts.
- `crm/`: Manages CRM functionalities.
- `massmail/`: Handles sending mass emails.
- `prelaunch/`: Manages pre-launch activities.
- `organisation/`: Manages organizations.
- `profiles/`: Manages user profiles.
- `sender_profiles/`: Manages sender profiles.

### `vachan_web/`

The `vachan_web/` directory contains web-related components, such as controllers and live views.

- `components/`: Contains various components of the web application.
- `controllers/`: Contains controllers for handling HTTP requests.
- `live/`: Contains live views for real-time interactions.


## Priv

The `priv` directory contains private files.

## Rel

The `rel` directory contains release-related files.

## Test

The `test` directory contains test files for unit and integration testing.

~~~bash 

│ ├── test/  
│ 	├── support/
│ 	├── vachan/ 
│ 	├── vachan_web/ 
│ 	└── test_helper.ex   
~~~