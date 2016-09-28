# README

This project provides an [ActiveAdmin](http://activeadmin.info/) interface for
CRU staff to enter details for the CRU Conference.

## Populate Development DB

```sh
bin/rake dev:populate
```

## Authentication

Instead of storing passwords locally, this project uses the
[CAS](https://en.wikipedia.org/wiki/Central_Authentication_Service) single
sign-on protocol for authentication, even in development. You can create a free
account at [TheKey.me](https://thekey.me/cas/service/selfservice?target=signup).

For CAS Authentication to work in development, you need to create a
`.env.local` file in the project's root to contain the TheKey.me API key, like:

```sh
export CAS_ACCESS_TOKEN="0123456789abcdef0123456789abcdef01234567"
```

Even with a validated CAS account, a user must be listed in the Users table.
Users can be added by existing admin users on the [admin
page](http://localhost:3000/users). Admin users can also be created with rake:

```sh
bin/rake users:new_admin[user@example.com]
```

The Development and Staging servers are seeded with an account for each User
role, with a real CAS account:

  * **Admin**: `jon.sangster+admin@ballistiq.com`
  * **Finance**: `jon.sangster+finance@ballistiq.com`
  * **General**: `jon.sangster+general@ballistiq.com`

Each account uses the password `CRUstaff2016`

## Testing

In development mode you can use [Guard](https://github.com/guard/guard) for
continuous testing:

```sh
bundle exec guard
```
