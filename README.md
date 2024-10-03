# ASP implemention of Rational Closure for defeasible entailment

## Table of contents
* [Project Background](#background)
* [Run](#run)

## Background
This code is part of a project whose main aim was to implement Rational Closure (RC) as defined in the KLM-Framework using Answer Set Programming (ASP). Two approaches were used to implement RC in ASP; a search-based approach and a recursive approach. The project also includes sample knowledge bases. A few of these have already been ranked. Some knowledge bases include a description of the expected BaseRank or Rational Closure result.

### Knowledge Base Format:
* Defeasible Statement: defeasible(a, b) = a ~> b
* Classical Statement: classical(a, b) = a => b
* Query Statement: query(a, b) = a ~> b

### Note:
* Non-ranked knowledge bases need to have a record of the count of defeasible statements in the knowledge base (i.e. #const=n for n defeasible statements).
* Ranked knowledge bases need record of the highest knowledge base rank if used with search-based RC.
* This project was created using Clingo version 4.5.4 (https://potassco.org/clingo/)
	
## Run
To run any one of the programs, run your clingo installation with an input knowledge base.

e.g. 
When using Base Rank:
```
$ clingo <base-rank-path> <unranked-knowledge-base-path> 0 [--quiet=1]
```

When using Rational Closure:
```
$ clingo <rational-closure-path> <ranked-knowledge-base-path> 0 [--quiet=1]
```

The [--quiet=1] should only be used with the search-based implementations to only display the most optimal (and therefore right) solution. Remove the square brackets.