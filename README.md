# MySQL + Flask Boilerplate Project

This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`.


## Project Overview
Our App is intented for college students to be able to connect to mentors to get advice/resources.
Students may find valuable opportunities after college through these mentors.

Video Demo: 
https://northeastern.zoom.us/rec/share/E7KK3OvptybZLGoKuSaDyoNDW9et_CVa2c3LUbpaFoEzBZzo0A0S30ue2BWXvfOQ.arLxzsoR7ITC0PL7?startTime=1701717959000




