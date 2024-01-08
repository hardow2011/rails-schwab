# Rails Schwab

This project is a passwordless Charles Schwab Bank clone designed to showcase different technologies working together to deliver a simple and stable user experience.

## Table of Contents

- [Installation](#installation)
- [Tests](#tests)
  - [Unit Testing](#unit-testing)
  - [System Testing](#system-testing)
  - [Integration Testing](#integration-testing)
- [Deployment](#deployment)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Installation

* [Install Postgres](https://www.postgresql.org/download/)
  * Setup a Postgres user named”‘schwab” with a password “schwab”
* [Install Redis](https://redis.io/docs/install/install-redis/)
* [Install Ruby](https://github.com/rbenv/rbenv)
* [Install the Ruby on Rails gem](https://guides.rubyonrails.org/getting_started.html#installing-ruby)
* [Install yarn](https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable)
* Clone the repository

## Tests

### Unit Testing

### System Testing

### Integration Testing

## Deployment

## Usage

### Signup and Login

1. The user enters an email to signup  
![Signup window](https://github.com/hardow2011/rails-schwab/assets/45014033/d6916a78-1972-4077-b277-17f96b135c54)

2.  The sign up link is sent to the user's email  
![Signup link](https://github.com/hardow2011/rails-schwab/assets/45014033/5143a02d-5c1a-4529-8b7c-31f2fe8dc61a)

3.  After accessing the signup link, the user is redirected to the app  
![Main page](https://github.com/hardow2011/rails-schwab/assets/45014033/9c32010f-b9a0-4026-8c65-923e6f6c43e7)

### Transactions upload

1. The user accesses the account page
2. Selects a transactions files exported from his Schwab bank
3. Clicks on the "Upload Transactions CSV" button
   ![Account page](https://github.com/hardow2011/rails-schwab/assets/45014033/f5c738b6-894c-4e28-b33b-078cdb95fab1)

### Email update

1. The user accessed the account page
2. The user clicks on the "Change Email" button
3. An email is sent to the user user to proceed with the update
   ![Email change link](https://github.com/hardow2011/rails-schwab/assets/45014033/d130347d-4977-4ed2-8aa2-4147a613ae7a)
4. The user is taken to the email change page to enter his new email
   ![Email change page](https://github.com/hardow2011/rails-schwab/assets/45014033/24719a16-1e25-407b-938a-9e281c47db93)
5. Am email is sent to the new email typed
6. After confirming the email change, it is officially updated
   ![Email confirm link](https://github.com/hardow2011/rails-schwab/assets/45014033/79830fe8-0a64-448e-a12a-7427ec8e5466)

### Email deletion

1. The user accesses the account page
2. Clicks on the "Delete User" button
3. Clicks on the link from the email sent to proceed with the deletion
4. Retypes the current email to confirm the deletion

## Configuration

Details on how to configure the project.

## Contributing

Guidelines for contributing to the project.

## License

Information about the project's license.

## Contact

Contact me at: [louvensraphael@outlook.com](mailto:louvensraphael@outlook.com)
