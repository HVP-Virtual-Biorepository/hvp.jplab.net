
## Purpose

This repository contains the Human Virome Project's Virtual Biorepository website.

This website offers a centralized and standardized process for coordinating
centers to upload sample metadata. It also generates files from this metadata to
be used in submitting sequencing reads to SRA.


## Implementation

The website is hosted on Amazon Web Services (AWS). Simple Storage Service (S3) is 
used for hosting static assets such as html and javascript files. Aurora RDS MySQL 
stores user-submitted data. Communication between web browsers and the MySQL database
is handled by R scripts run in a Docker container on AWS Lambda.
