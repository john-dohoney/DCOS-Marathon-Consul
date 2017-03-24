## Marathon Installation

These files can be deployed via the DCOS CLI or the DCOS UI.

NO changes will need to be made to the GliderLabs Registrator Side car.  However, this is deployed last after the public agents and private agents are deployed

## Public Agents

Modify server-bootstrap.json, and add the private network IP address of your public agent(s)

The following line is modified in the "args" attribubte of the Marathon config file

 "args": ["server", "10.0.6.29", "10.0.4.175"],

Be sure to adjust the number of "instances" to the number of public agents in your cluster.

## Private Agents

In deployment of the Private agents, there is a small trick to getting this correct.  On the "args" attribute in the Private Agents deployment file -- agents.json.  The Public Agents are listed first and NOT counted in the number of instances.  You instance count IS ONLY THE NUMBER of private agents to run.  So, in my example cluster, I am running 2 public agents and 2 private agents.  You will see from above, those PUBLIC agents are listed first, then the 2 private agents.

"args": ["agent","10.0.6.29", "10.0.4.175", "10.0.1.1", "10.0.3.73"],

Note: As of this writing, due to my NAT configuration, I was getting a lot of flapping, so I omitted the Health Check.

## Registrator

Deploy this file as is

## Order of deployment
1. server-bootstrap.json
2. agents.json
3. registrator.json

