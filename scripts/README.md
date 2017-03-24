## Set Up Consul

The big idea.  Treat this Docker image as if you are running consul from a command line.  The idea is to take the environment variables and create a consul config file.

## Customizations

You more than likely will need to make changes to this baseline version.  HashiCorp has many configuration values for Consul that can be added to the configuration file.  So, the change to add a new configuration value is simple:

1. Add the Env Variable to your consul file.  ONE WARNING, as of version 1.8.8/1.9rc1 of DCOS, the Marathon JSON parser WILL NOT Parse arrays as environment values (or I would have made JOIN_ADDR and env variable).  So, just single strings/number/booleans -- unless you write some logic in this file.
2. Read in the ENV varible in the BASH startup script
3. Add it to the respective server or agent config file
4. TEST TEST TEST
