# About

Docker image base on eugeneware/php-5.3.

It adds support for:
- Ioncube loader
- Sending emails via Exim (based on https://github.com/namshi/docker-smtp)
- Optionally running Cron

# Commands

Default command runs supervisord which then starts nginx, php-fpm and exim.

```
["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord-web.conf"]
```

Alternative command if you wish to run a worker. This command starts cron and exim:

```
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord-worker.conf"]
```
