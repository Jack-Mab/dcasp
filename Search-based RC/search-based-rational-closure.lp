% --------------------------------------------------------------------------------------------
% Find the right subset of the ranked knowledge base

% Get the highest non-infinite rank
last(N-1) :- rank(N, #inf).
last(N) :- highest(N), not rank(N, #inf).

% Generate possible subsets of ranks
{start(0..N+1)} = 1 :- last(N).

% Start with the lowest rank possible
#minimize{N : start(N)}.

% Condition for only_infinite [The situation where we only use the infinite rank]
only_infinite :- start(N), last(M), N > M.

% Add the defeasible statements to the union
union(statement(A, B), sub) :- start(N), rank(defeasible(A, B), K), K >= N, not only_infinite.

% Add the classical statements to the union
union(statement(A, B), sub) :- rank(classical(A, B), #inf).

% Add the antecedent of the query to the union
union(atom(X), sub) :- query(X, Y).

% Derive all possible statements in the union
union(atom(B), Part) :- union(statement(A, B), Part), union(atom(A), Part).
union(atom(B), Part) :- union(statement(A, B), Part), A = top. % A is always true

% Check if the antecedent of the query is exceptional in the union
exceptional :- union(atom(A), sub), union(atom(-A), sub).

% The antecedent of the query must not be exceptional in the union
:- exceptional.

% ----------------------------------------------------------------------------------------
% Check if the subset entails the query

% Add all statements to new union for entailment check
union(statement(A, B), entailment) :- union(statement(A, B), sub).

% Add negation of query to the union for entailment check
union(atom(X), entailment) :- query(X, Y).
union(atom(-Y), entailment) :- query(X, Y).

result(true) :- union(atom(A), entailment), union(atom(-A), entailment).
result(false) :- not result(true).

#show result/1.