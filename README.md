# Qulture Challenge

## Installation

```
git clone git@github.com:lfv89/qulture-challenge.git
bundle install
bin/rspec
```

## Usage

The application is currently on Heroku. Every request below are pointing to the application's endpoints on Heroku.

### How to create an user?

```
curl -H "Content-Type: application/json" -X POST -d '{ "user": { "is_active":true, "sex": "female", "first_name":"A girl first name", "last_name":"A girl last name", "email":"girl@girl.com", "birth_date":"1992-06-26", "admission_date":"2010-08-01", "last_sign_in_at":"2016-11-29 16:29:03 -0200", "tags_attributes": [{"name": "tag1"}, {"name": "tag2"}]}}' http://qulture-challenge.herokuapp.com/api/v1/users --verbose
```

### How to create a segment?

1) Creating a segment to filter users that have a `tag1` tag:

```
curl -H "Content-Type: application/json" -X POST -d '{ "segment": { "name": "tag_segment", "data": [{ "tags": ["tag1"] }] } }' http://qulture-challenge.herokuapp.com/api/v1/segments --verbose
```

2) Creating a segment to filter users that are `(males AND active) OR (females)`:

```
curl -H "Content-Type: application/json" -X POST -d '{ "segment": { "name": "main_segment", "data": [ { "sex": "male", "is_active": true }, { "sex": "female" } ] } }' http://qulture-challenge.herokuapp.com/api/v1/segments --verbose
```

### How to apply a segment to filter users?

```
curl http://qulture-challenge.herokuapp.com/api/v1/users?segment=segment-name --verbose
```
