# Purpose

This app provides APIs to let users track when they go to bed and when they wake up.
Users can also follow each other and view others records of sleep.

# Model

### User

| field | type |
| ---  | --- |
| id | integer |
| name | string |

### Follow

| field | type | description |
| --- | --- | --- |
| id | integer | |
| follower_id | integer | reference to user's id |
| following_id | integer | reference to user's id |


- index: follower_id, following_id, [ follower_id, following_id ]

### Sleep

| field | type | description |
| --- | --- | --- |
| id | integer | |
| user_id | integer | reference to user's id |
| start_at | datetime | the time sleep starts |
| end_at | datetime | the time sleep ends |
| duration | integer | seconds between start_at and end_at |

- index: user_id, [ user_id, start_at ]

# API

## Overview

All apis are in version 1. (i.e. `/api/v1`)

### Page

Apis that returns collection can be paginated by passing query parameter `page`(ex: `?page=10`).
Each page contains 25 records.
| Query Params | type | description |
| --- | --- | --- |
| page | integer | cluster collection by page |

### Order

The order of the returned collection can be set by passing query parameter `order` (ex: `?order=asc`).

| Query Params | type | description |
| --- | --- | --- |
| order | string | only `desc` and `asc` is permitted, other string will be recognized as `desc` |

## User
### `GET /users/:id`
Get a user by id.

| Path Params | type    | description |
| ----------- | ------  |----------- |
| id          | integer | User's id   |

#### 200 OK
```json
{
    "id": 1,
    "name": "michael",
    "created_at": "2021-03-08T08:09:44.317Z",
    "updated_at": "2021-03-08T08:09:44.317Z"
}
```

## Sleep

Sleep records the time when the user starts and ends sleeping.

- Must provide user_id in every API, otherwise will get `404`.

### `GET /users/:user_id/sleeps`

Get all records of sleep for a user.

- Ordered by the time it starts in desc by default.
- Allow pagination.

| Path Params | type    | description |
| ----------- | ------  |----------- |
| user_id     | integer | User's id   |


#### 200 OK

```
{
    "id": 1,
    "user_id": 1,
    "start_at": "2021-03-06T08:09:44.331Z",
    "end_at": "2021-03-07T08:09:44.332Z",
    "created_at": "2021-03-08T08:09:44.344Z",
    "updated_at": "2021-03-08T08:09:44.344Z",
    "duration": 86400
},
{
    "id": 2,
    "user_id": 1,
    "start_at": "2021-03-04T08:09:44.332Z",
    "end_at": "2021-03-05T08:09:44.332Z",
    "created_at": "2021-03-08T08:09:44.350Z",
    "updated_at": "2021-03-08T08:09:44.350Z",
    "duration": 86400
}

```

### `POST /users/:user_id/sleeps`

Start new sleep for a user.

| Path Params | type | description |
| ----------- | --- |----------- |
| user_id     | integer | User's id   |

#### 201 Created

```
{
    "id": 9,
    "user_id": 1,
    "start_at": "2021-03-09T11:10:42.461Z",
    "end_at": null,
    "created_at": "2021-03-09T11:10:42.462Z",
    "updated_at": "2021-03-09T11:10:42.462Z",
    "duration": null
}

```

#### 422 Unprocessable Entity

```
{
    "error": [
       "some error message"
    ]
}

```

- If a user has ongoing sleep, you cannot start another one until it end.

```
{
    "error": "End the current sleep to start new one"
}

```

### `PATCH /users/:user_id/sleeps/:id`

Update the time when sleep ends.

| Path Params| type | description |
| --- | ---  | --- |
| id | integer | Sleep's id |
| user_id | integer | User's id |

#### 200 OK

```
{
    "end_at": "2021-03-09T11:11:26.024Z",
    "duration": 44,
    "id": 9,
    "user_id": 1,
    "start_at": "2021-03-09T11:10:42.461Z",
    "created_at": "2021-03-09T11:10:42.462Z",
    "updated_at": "2021-03-09T11:11:26.029Z"
}

```

#### 422 Unprocessable Entity

```
{
    "error": [
       "some error message"
    ]
}

```
* Cannot update ended sleep.
```
{
    "error": [
        "Sleep is already ended, do not overwrite it."
    ]
}
```

## Following

Let a user follow or unfollow another user.

### `GET users/:user_id/followings`

Get all followed users of a user

| Path Params | type | description |
| ------------| ---- | ----------- |
| user_id     | integer | User's id   |


#### 200

```
[
    {
        "id": 2,
        "name": "foo"
    },
    {
        "id": 3,
        "name": "boo"
    }
]

```

### `POST /following`

Allows the user to follow another user.

| Body Params       | type | description |
| ----------------- | -----|------ |
| user_id           | integer | User's id   |
| following_user_id | integer | Id of user to follow |


#### 201 Created

```
{
    "message": "Follow Success"
}

```

#### 422 Unprocessable Entity

```
{
    "error": [
       "some error message"
    ]
}

```

### `DELETE /following/:id`

Allows the user to unfollow other users.

| Path Params       | type | description |
| ----------------- | --- | ----------- |
| id                | integer | Id of user to unfollow |

| Body Params       | type | description |
| ----------------- | ----| ------- |
| user_id           | integer | User's id   |

#### 200 OK

```
{
    "message": "Unfollow Success"
}

```

#### 422 Unprocessable Entity

```
{
    "error": [
        "some error message"
    ]
}

```

## FollowingSleep

Sleeping records of followed users.

### `GET /users/:user_id/following_sleeps`

Get records of sleep from a user's followed users.

- Records are ordered by duration (default in desc).
- Only returns records in the past week.
- Allow pagination.

| Path Params  | type| description |
| ------------ | --- | ----------- |
| user_id      | integer | User's id |

#### 200 OK

```
[
 {
        "id": 5,
        "start_at": "2021-03-04T08:09:44.365Z",
        "end_at": "2021-03-05T08:09:44.365Z",
        "duration": 86400,
        "user_id": 3,
        "user_name": "boo"
    },
    {
        "id": 4,
        "start_at": "2021-03-03T18:09:44.353Z",
        "end_at": "2021-03-04T08:09:44.353Z",
        "duration": 50400,
        "user_id": 2,
        "user_name": "foo"
    },
    {
        "id": 3,
        "start_at": "2021-03-05T20:09:44.353Z",
        "end_at": "2021-03-06T08:09:44.353Z",
        "duration": 43200,
        "user_id": 2,
        "user_name": "foo"
    }
]

```
