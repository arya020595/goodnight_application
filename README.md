# Project Name

## Overview

This project is a Rails API for managing **users**, **follows**, and **sleep records**. It allows users to **follow** and **unfollow** others, view their sleep records, and perform related actions.

The API provides various endpoints to interact with the **User** model, and supports functionality such as:
- Following/unfollowing users
- Viewing and managing sleep records

## Installation

### Prerequisites

Make sure you have the following installed:

- **Ruby** (version 3.x or higher)
- **Rails** (version 6.x or higher)
- **PostgreSQL** (or another supported database)
- **Node.js** (for managing assets)

### Steps to Run the Application

1. **Clone the Repository**

   Clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/projectname.git
   cd projectname

2. **Install Dependencies**
   bundle install

3. **Setup the Database**
   ```
   rails db:create  # Create the database
   rails db:migrate # Run database migrations
   rails db:seed    # Seed the database with initial data (if any)
   ```
4. **Start the Rails Server**
   ```
    rails s
   ```

### Steps to Run the Application

## Environment Variables ##
Ensure you have the necessary environment variables set up for your local development environment. For example, you may need to set up a .env file for sensitive information like API keys or tokens.
```
DATABASE_URL=postgres://username:password@localhost:5432/database_name
SECRET_KEY_BASE=your_secret_key_base
```

## Postman Collection ##
Download Postman Collection
```
https://api.postman.com/collections/18641045-853c78d1-ed0b-47d9-a437-fb8ee08b9de7?access_key=PMAT-01JDBV553N63C49EX0MTRSRFMY
```
