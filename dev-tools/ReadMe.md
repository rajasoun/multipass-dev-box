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

### Getting Started 

In Terminal 

To bring up the sandbox

```SHELL
$ dev-tools/sandbox.bash up
```

To destroy the sandbox

```SHELL
$ dev-tools/sandbox.bash down
```

For Help

```SHELL
$ dev-tools/sandbox.bash 
```

[rsyslog]: http://manpages.ubuntu.com/manpages/bionic/man8/rsyslogd.8.html
[portainer]: https://portainer.readthedocs.io/en/stable/deployment.html
[loki]: https://grafana.com/oss/loki/
[grafana]: https://grafana.com/
[prometheus]: https://prometheus.io/