# Dev Tools Sandbox

Dev tools sandbox mimics tools in production as close as possible enabling developers to experiment and 
learn the same toolset for logging, container management and server monitoring 

The choice of the tools are aimed towards simplicity and of apps of small to medium size.

|      Purpose          |      Tool      |
|:----------------------|:---------------|
|Container  Management  | [portainer]    |
|Centralized Logging    | [rsyslog]      |
|Log Aggregation System | [loki]         |
|Observability Platform | [grafana]      |
|Monitoring Platform    | [prometheus]   |

## Getting Started 

### In Terminal 

### AWS & OIDC Configuration

```SHELL
$ cp dev-tools/config/secrets/aws.env.template    dev-tools/config/secrets/aws.env
$ cp dev-tools/config/secrets/oidc.env.template   dev-tools/config/secrets/oidc.env
```

> Populate the values in both dev-tools/config/secrets/aws.env and dev-tools/config/secrets/oidc.env

### To bring up the sandbox

```SHELL
$ dev-tools/sandbox.bash up
```

#### To view the logs
```
	- [View all running services](http://localhost:9000)
	- Click on the 'external link' icon under 'Published Ports' against 'grafana'
	- This should launch an [url](http://localhost:3000)
	- Login with admin/admin
	- Click on 'Explore' label on left menu
	- Select the log label (which is against the search box)
	- You shall see the logs from all services
```

#### To stream the logs
```
	- With all the steps under 'To view the logs'
	- Click on 'Live'
	- If logs stop, click on 'Resume' from bottom of the page
	- You shall see the stream of logs from all services
```

#### To search the logs
```
	- With all the steps under 'To view the logs'
	- Follow the filter expressions in the [document](https://github.com/grafana/loki/blob/master/docs/logql.md#filter-expression)
```

### To destroy the sandbox

```SHELL
$ dev-tools/sandbox.bash down
```

### For Help

```SHELL
$ dev-tools/sandbox.bash 
```

[rsyslog]: http://manpages.ubuntu.com/manpages/bionic/man8/rsyslogd.8.html
[portainer]: https://portainer.readthedocs.io/en/stable/deployment.html
[loki]: https://grafana.com/oss/loki/
[grafana]: https://grafana.com/
[prometheus]: https://prometheus.io/