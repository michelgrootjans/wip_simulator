# wip_simulator
Simple project simulator.

To get this simulator to run do the following:
- generate some data: ``docker-compose run generation``
- run the simulation based on the generated files: ``docker-compose run simulation``

The output will be something like this:
```
...
*** end of day 43 ****
backlog: 52
development: 3
ready_for_qa: 26
qa: 1
done: 18
*** end of day 44 ****
backlog: 52
development: 1
ready_for_qa: 28
qa: 0
done: 19
*** end of day 45 ****
...
```

This is how you read this data:

At the end of day 43, 52 stories are in the backlog, 3 stories are in development, 26 stories are ready for QA, 1 story is in QA, 18 stories are done


TODO
----
Measure some performance metrics like throughput and lead time.

I'm planning to add some basic project strategies. Some of the idea's I'm working on are:
- limit the work in progress over some set of columns
- limit the work in progress for the whole project
- team members can learn a new skill at a certain rate (e.g. a developer starts out by not being able to do QA, but after a while, they get proficient at it)
