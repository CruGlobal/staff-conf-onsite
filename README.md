# README

This project provides an [ActiveAdmin](http://activeadmin.info/) interface for
Cru staff to enter details for the Cru Conference.

## Development

### Set up Your Development Environment

Check-out the repository and rubygem dependencies.

```sh
git co git@github.com:CruGlobal/staff-conf-onsite.git && cd staff-conf-onsite
bundle
```

Before settings up the database, you need to setup the CAS credentials
necessary to seed the development user records. These test accounts have real
records on the [TheKey.me](https://thekey.me/cas/login) server and they are
downloaded when the records are persisted. See the [Authentication
Section](#authentication) section for instructions.

Finally, setup the database and start the development server.

```sh
./bin/rake db:setup
./bin/rails server
```

### Populate DB with Fake Data

This application is mainly concerned with data-entry and report creation. It
can be very tedious to create the data required to do any real manual testing.
You can use `FactoryBot` to generate a number of fake records in the
development DB.

```sh
bin/rake dev:populate
```

### Generate Documentation

If you're unfamiliar with this codebase, the HTML documentation is a very
useful resource. After running the following command, navigate your browser to
`./doc/index.html`.

```sh
bin/rake yard
```

## Linting and Testing

The default `rake` task will lint the codebase with
[RuboCop](https://github.com/bbatsov/rubocop) and
[Reek](https://github.com/troessner/reek), then run the automated tests.

```sh
bin/rake
bin/rake test  # skip the linters
```

When writing code, you can use [Guard](https://github.com/guard/guard) for
continuous testing. With Guard, whenever a file is updated, any tests
associated with that file are automatically run.

```sh
bundle exec guard
```

### Integration Tests

To test that the site actually works correctly in a user's browser, the
integration tests will open an instance of
[Chrome](https://www.google.com/chrome), and have a "robot" automatically
similate a user's actions. For speed and convenience, this is done using
"headless Chrome," a version of Chrome which doesn't actually open a visible
window; however, if your integration tests are failing, it may be useful to see
what the robot is actually doing. You may switch to using a visible Chrome
window, instead of headless Chrome, with this command:

```sh
bin/rake test:integration CAPYBARA_DRIVER=chrome
```

## Application Concepts

### Authentication

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

### Sidekiq Job Queue

In development/local you can run sidekiq:

```sh
bundle exec sidekiq
```

To monitor queue/jobs

[SideKiq Dashboard]http://localhost:3000/sidekiq/

### Docusign

Docusign is a 3rd party service that provides digital signatures.
The app uses the service by sending data Docusign via api which is pre filled 
into an existing template on Docusign. Then this `envelope` is sent to the 
recipient that we determined. 
The recipient then receives an email to view this document (envelope) and can 
electronically sign it knowing that the document can't be tampered.

To test sending real DocuSign documents on dev, you need to:
1. [Create a free developer account](https://go.docusign.com/sandbox/productshot/)
2. Create a template on the DocuSign web ui by going to templates on the main menu.
3. On template setup add a signing role, and some fields to be pre filled.
4. Add your docusign credentials to your env.local file (User password needs to be an App Pass created under your account in docusign)
5. Edit the service .rb for the envelope you want to serve to add your template id,
and other particular customizations.

> **Ensure you set yourself or a test email as the recipient!**


### Docusign: Recording new VCR cassettes (Testing)

To remove any personal data tied to the developers DocuSign account, the vcr cassettes
where slightly modified from their original recording by using vcr's filter sensitive
data option.

To record new VCR cassettes of existing tests:
> This assumes you have a free DocuSign demo account
* Create an `.env.test.local` file, and add your DocuSign credentials overwriting the 
`.env.test` ones.
* Delete (or rename) any existing VCR cassette used on the test.
* Run test as usual.
* A new cassette will be created and your real credentials will be overwritten by the 
placeholder defined on the filter.
* Run tests again to ensure all worked as expected.
