% Simplify the statements
rank(statement(X, Y), N) :- rank(defeasible(X, Y), N).
rank(statement(X, Y), #inf) :- rank(classical(X, Y), #inf).

% Find the maximum defeasible rank
max_rank(M) :- 
    M = #max { R : rank(defeasible(_, _), R), R != #inf }.

% ==================================================== RECURSIVE CASE ====================================================================
% 1. Build the tree using the query's antecedent
root(X, 0) :- query(X, _).

% For each tree, build edges directly connected to the roots. [For each recursive step]
edge(X, Y, N) :- root(X, N), rank(statement(X, Y), R), N <= R.

% For each tree, build the rest of the edges
edge(Y, Z, N) :- edge(_, Y, N), rank(statement(Y, Z), R), N <= R.

% 2. Check for clashes in the tree
% The antecedent is exceptional in a rank, if its tree has two contradictory atoms in that rank
exceptional(R) :- edge(_, Y, R), edge(_, -Y, R), max_rank(N), R <= N.
exceptional(R) :- root(X, R), edge(_, -X, R), max_rank(N), R <= N.

% 3. "Eliminate" the lowest rank if the antecedent is exceptional in the ranked knowledge base
root(X, R+1) :- root(X, R), exceptional(R), max_rank(N), R <= N.


% ==================================================== BASE CASE ====================================================================
% Get the lowest rank that hasn't been removed
start(M) :- 
    M = #max { R : root(_, R)}.

% Create a union of the remaining ranks
union(statement(A, B)) :- rank(statement(A, B), R), start(M), M <= R.
union(statement(A, B)) :- rank(statement(A, B), #inf).

% Add the negation of the query to the union for entailment check
union(atom(X)) :- query(X, Y).
union(atom(-Y)) :- query(X, Y).

% Derive all possible statements in the union
union(atom(B)) :- union(statement(A, B)), union(atom(A)).
union(atom(B)) :- union(statement(A, B)), A = top. % A is always true

% Check for a clash (i.e. Satisfiability)
result(true) :- union(atom(A)), union(atom(-A)). % The query is entailed
result(false) :- not result(true). 

#show result/1.