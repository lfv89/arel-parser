# Arel Parser

Arel Parser is a web application written in Rails that takes a JSON and converts it to Arel. The idea is to query a relational database with a JSON DSL. For this application, `users` can be filtered after applying a `segment`. A `segment` is created with a name and with its JSON data that will later be used to actually filter the `users`. 

This tool was original built to solve a code challenge for an interview.

## Installation

```
git clone git@github.com:lfv89/json-to-arel-parser.git
bundle install
bin/rails s
```

## Usage

### How to create an user?

```
curl -H "Content-Type: application/json" -X POST -d '{ "user": { "is_active":true, "sex": "female", "first_name":"A girl first name", "last_name":"A girl last name", "email":"girl@girl.com", "birth_date":"1992-06-26", "admission_date":"2010-08-01", "last_sign_in_at":"2016-11-29 16:29:03 -0200", "tags_attributes": [{"name": "tag1"}, {"name": "tag2"}]}}' http://localhost:3000/api/v1/users --verbose
```

### How to create a segment?

1) Creating a segment to filter users that have a `tag1` tag:

```
curl -H "Content-Type: application/json" -X POST -d '{ "segment": { "name": "tag_segment", "data": [{ "tags": ["tag1"] }] } }' http://localhost:3000/api/v1/segments --verbose
```

2) Creating a segment to filter users that were born between `1980 AND 1990`:

```
curl -H "Content-Type: application/json" -X POST -d '{ "segment": { "name": "age_segment", "data": [{ "birth_date": ["1980-01-01", "1990-01-01"] }] } }' http://localhost:3000/api/v1/segments --verbose
```

3) Creating a segment to filter users that are `(males AND active) OR (females)`:

```
curl -H "Content-Type: application/json" -X POST -d '{ "segment": { "name": "main_segment", "data": [ { "sex": "male", "is_active": true }, { "sex": "female" } ] } }' http://localhost:3000/api/v1/segments --verbose
```

### How to apply a segment to filter users?

```
curl http://localhost:3000/api/v1/segmentations/segment-name --verbose
```
