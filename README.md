# DCOS-Marathon-Consul
Marathon Friendly Version of Consul

## Get Started FAST -- Docker Hub approach
Pull the docker image from Docker hub as:
```
$ docker pull johndohoney/consul:7.4
```
By default, this will pull the latest image.

The `Consul` configuration files are generated on the fly as the container runs.
For a complete documentation on `Consul` configuration parameters, check
[Consul Agent](https://www.consul.io/docs/agent/options.html).

The image supports the following environment variables:
* `DATACENTER`: name of the consul datacenter (default: `consul-dc`) (equivalent of `-dc` CLI flag)
* `LOG_LEVEL`: level of log verbosity (default: `INFO`) (equivalent of `-log-level` CLI flag)
* `NETWORK_INTERFACE`: network interface to bind to (default: `eth0`) (this is used by `BIND_ADDR`)
* `BIND_ADDR`: network interface to bind to (default: `0.0.0.0`) (equivalent of `-bind` CLI flag) (this overrides `NETWORK_INTERFACE`)
* `BOOTSTRAP_EXPECT`: number of nodes to declare healthy quorum (default: `1`) (equivalent of `-bootstrap-expect` CLI flag)

The run command looks like:
```
$ docker run -d -P johndohoney/consul:7.4 MODE JOIN_ADDR
```

The two positional arguments are:
* `MODE`: mode of the `Consul` node, can take values `server` or `agent`
* `JOIN_ADDR`: a valid FQDN or IP address of a peer node whose cluster to join,
when starting the first node, this argument can be skipped.

## Roll Your own Approach

Git clone this repo to your laptop or server

A Makefile is included to build the Docker image.  Feel free to use your own or project specific tag

To build the latest image from source, run
```
$ make image
$ make run``
