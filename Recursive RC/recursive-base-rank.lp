% Rank classical statements in rank infinity
rank(classical(X, Y), #inf) :- classical(X, Y).

% ----------------------------------------------------------------------------------------
% Base Case (All In rank 0)
% Build the trees by starting with the roots
root(X) :- defeasible(X, _).

% Count the number of antecedents
total_antecedents(N) :- N = #count { X : root(X) }.

% For each tree, build edges directly connected to the roots.
edge(X, X, Y) :- root(X), defeasible(X, Y).

% For each tree, build the rest of the edges
edge(X, Y, Z) :- edge(X, _, Y), defeasible(Y, Z).

% An antecedent is exceptional, if its tree has two contradictory atoms (i.e. a clash)
exceptional(X) :- edge(X, _, Y), edge(X, _, -Y).
exceptional(X) :- edge(X, _, -X).

% A statement is ranked in rank 0, if its antecedent is not exceptional in rank 0.
rank(defeasible(X, Y), 0) :- defeasible(X, Y), not exceptional(X).

% If an antecedent is exceptional in rank 0, it gets pushed to rank 1
root(1, X) :- exceptional(X).

% End of Base Case
% ----------------------------------------------------------------------------------------


% ----------------------------------------------------------------------------------------
% Recursive Case

% For each tree, build edges directly connected to the roots.
edge(R, X, X, Y) :- root(R, X), defeasible(X, Y), total_antecedents(N), R < N.

% For each tree, build the rest of the edges
edge(R, X, Y, Z) :- defeasible(Y, Z),
    edge(R, X, _, Y),
    root(R, Y),
    total_antecedents(N),
    R < N.

% An antecedent is exceptional, if its tree has two contradictory atoms (i.e. a clash)
exceptional(R, X) :- edge(R, X, _, Y), edge(R, X, _, -Y), total_antecedents(N), R < N.
exceptional(R, X) :- edge(R, X, _, -X), total_antecedents(N), R < N.


% A statement is ranked in rank R, if its antecedent is not exceptional in rank R, and it hasn't been ranked yet.
rank(defeasible(X, Y), R) :-
    defeasible(X, Y),
    root(R, X),
    total_antecedents(N),   % Ground N before using it in conditions
    R < N,                  % Ensure R is less than N
    K = 0..R,
    not rank(defeasible(X, Y), K),
    not exceptional(R, X).

% If an antecedent is exceptional in rank R, it gets pushed to rank R+1
root(R+1, X) :- exceptional(R, X), total_antecedents(N), R < N.

#show rank/2.
