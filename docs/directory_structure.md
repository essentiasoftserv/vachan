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

- `css/`: Importing the base styles, components and classes from tailwind CSS and intergrating GrapesJS Styles for the main application.
- `js/`: Contains JavaScript files.
- `vendor/`: Contains third-party vendor packages.
- `package-lock.json`: Lockfile for npm dependencies.
- `package.json`: npm package configuration.
- `tailwind.config.js`: Configuration file for Tailwind CSS.

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