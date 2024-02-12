[![build](https://github.com/endaft/endaft-core/actions/workflows/cd.yaml/badge.svg)](https://github.com/endaft/endaft-core/actions/workflows/cd.yaml) [![codecov](https://codecov.io/gh/endaft/endaft-core/branch/main/graph/badge.svg?token=66JAV7JV1K)](https://codecov.io/gh/endaft/endaft-core)

# endaft-core

The `endaft-core` repo holds the core library source for `endaft` backend solution templates.

## Features

A few of the things you'll get from using an `endaft` backend solution template are:

1. Guaranteed wire compatibility between frontend and backend.
2. A thoroughly tested core library with 100% coverage
3. Dependency injection for easier testing and control of underlying components
4. Helpful design utilities like fake object generators and lispum text generators to facilitate the design phase
5. A base contract with contextual state capabilities
6. A Terraform deployment module for
   1. AWS API Gateway with Lambdas
   2. Cognito User Pool with OIDC, SAML, and Social login capabilities
   3. S3 website hosting behind an authorizer
   4. CloudWatch Logging
   5. Explicit, and wildcard, SSL management via ACM
   6. Route53 Record Management in the associated hosted zone
7. An automated build pipeline that does everything you need to deploy
8. A managed docker image to build AWS Lambdas directly in Amazon Linux 2
9. Schema validated JSON configuration files with
   1.  Lambda route validation and cross-checking for duplicates
   2.  Customizable request transformations for your lambdas
   3.  Cognito UI Customization (CSS and Images)
   4.  Identity, Access, and Refresh token validity control
   5.  Password complexity controls
   6.  Log retention controls

## Getting started

Getting started is pretty straightforward. You'll need a handful of common tools. The first one is the [endaft](https://github.com/endaft/endaft-cli) CLI. You can use `endaft check` to check for all required tools and files, and `endaft check --fix` to automatically address some of the requirements.

## Usage

A typical usage example to install a backend and build it for deployment, assuming you don't have `endaft` yet, might look like

```shell
dart pub global activate endaft
endaft install --template lambda-api
endaft build
```

That's it! This will provide you with a deployable backend Todo application, then dive in and customize the models and messages.

## Additional information

If you ever get into trouble deleting files and such, you migrate systems and don't have all the same tools yet. Just remember to run `endaft check --fix` and it'll sort you out the best it can and tell what you need to do manually.
