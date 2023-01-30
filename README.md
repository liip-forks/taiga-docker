# Taiga Docker

This is a fork of https://github.com/kaleidos-ventures/taiga-docker, check their code and announcements first.

## Raison-d'être of this fork

The point of this fork is to allow simple `git clone` and `.env` file customization to be up-and-running. In contrast to upstreams, it doesn't (and really shouldn't) need any `docker-compose.yml` edit.

Additionally; it;
* avoids variables duplication by (among other things) forcing the booleans into their expected formats (Python's capitalized for `taiga-front`, JS's lowercase for `taiga-back`) in the images' entrypoints;
* allows simple integration of the [OpenID plugin images](https://github.com/robrotheram/taiga-contrib-openid-auth);

## Getting Started

On your `docker` / `docker-compose`-enabled host, clone this repository.

Then copy `.env.example` to `.env` and customize the latter to fit your needs.

When done, simply launch:
```sh
docker-compose up -d
```

## Still to be done;

After some instants, when the application is started you can proceed to create the superuser with the following script:

```sh
$ ./taiga-manage.sh createsuperuser
```

The `taiga-manage.sh` script lets launch manage.py commands on the
back instance:

```sh
$ ./taiga-manage.sh [COMMAND]
```

If you're testing it in your own machine, you can access the application in **http://localhost:9000**. If you're deploying in a server, you'll need to configure hosts and nginx as described later.


## Code of Conduct

Help us keep the Taiga Community open and inclusive. Please read and follow our [Code of Conduct](https://github.com/kaleidos-ventures/code-of-conduct/blob/main/CODE_OF_CONDUCT.md).

## License

Every code patch accepted in Taiga codebase is licensed under [MPL 2.0](LICENSE). You must be careful to not include any code that can not be licensed under this license.

Please read carefully [our license](LICENSE) and ask us if you have any questions as well as the [Contribution policy](https://github.com/kaleidos-ventures/taiga-docker/blob/main/CONTRIBUTING.md).
