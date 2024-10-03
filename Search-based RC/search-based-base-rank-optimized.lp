% Generation: generate all the possible ranks

rank(0..n).
{rank(defeasible(X, Y), 0..n)} = 1 :- defeasible(X, Y).

% Add all the classical statements to the infinite rank
rank(classical(X, Y), #inf) :- classical(X, Y).

% Two statements with the same antecedent can't be in two different ranks
N1 == N2 :- rank(defeasible(X, Y), N1), rank(defeasible(X, Z), N2).

% There are no gaps between ranks
% Mark all used ranks
used(N) :- rank(defeasible(X, Y), N).

% Ensure that if a rank N is used, then all ranks from 0 to N are also used
:- rank(M), not used(M), used(N), M < N.

% Mark each antecedent with its rank
antecedent(X, N) :- rank(defeasible(X, _), N).

% Create unions for downwards and upwards ranks for each antecedent
union(defeasible(A, B), X, N, down) :- antecedent(X, N), rank(defeasible(A, B), K), K = 0..N, N > 0.
union(defeasible(A, B), X, N, up) :- antecedent(X, N), rank(defeasible(A, B), K), K = N..n, N < n.

% Add the antecedent to its union
union(part(X), X, N, Type) :- union(defeasible(_, _), X, N, Type).

% Add the classical implications to the union
union(defeasible(A, B), X, N, down) :- antecedent(X, N), classical(A, B).
union(defeasible(A, B), X, N, up) :- antecedent(X, N), classical(A, B).

% Derive all possible statements in each union
union(part(B), X, N, down) :- union(defeasible(A, B), X, N, down), union(part(A), X, N, down).
union(part(B), X, N, down) :- union(defeasible(A, B), X, N, down), A = top. % A is always true
union(part(B), X, N, up) :- union(defeasible(A, B), X, N, up), union(part(A), X, N, up).
union(part(B), X, N, up) :- union(defeasible(A, B), X, N, up), A = top. % A is always true

% For each antecedent, check if it's exceptional in its union
exceptional(antecedent(X, N), union, down):- union(part(A), X, N, down), union(part(-A), X, N, down).
exceptional(antecedent(X, N), union, up):- union(part(A), X, N, up), union(part(-A), X, N, up).

% Every antecedent must be exceptional in its downwards union
:- not exceptional(antecedent(X, N), union, down), antecedent(X, N), N > 0.

% Every antecedent in an upwards rank must NOT be exceptional in its union
:- exceptional(antecedent(X, N), union, up), antecedent(X, N).

% Rank predicates for the antecedents
rank(defeasible(A, B), X, N) :- antecedent(X, N), rank(defeasible(A, B), N).

% Add the antecedent to its rank
rank(part(X), X, N) :- rank(defeasible(_, _), X, N).

% Derive all possible statements in each rank copy for each antecedent
rank(part(B), X, N) :- rank(defeasible(A, B), X, N), rank(part(A), X, N).
rank(part(B), X, N) :- rank(defeasible(A, B), X, N), A = top. % A is always true

% For each antecedent, check if it's exceptional in its rank copy
exceptional(antecedent(X, N), rank):- rank(part(A), X, N), rank(part(-A), X, N).

% Every antecedent (that is not in the last rank) must NOT be exceptional in its rank
:- exceptional(antecedent(X, N), rank), antecedent(X, N), N != n.

% Minimize the ranks assigned to statements
#minimize{N, X, Y : rank(defeasible(X, Y), N)}.

% Determine the highest rank
highest(N) :- rank(defeasible(_, _), N), not less_than(N).

% A rank N is not the highest if there is a higher rank M
less_than(N) :- rank(defeasible(_, _), N), rank(defeasible(_, _), M), M > N.

% Ensure there is exactly one highest rank
:- highest(N1), highest(N2), N1 != N2.

% Mark the highest rank as infinite if it contains exceptional statements
rank(N, #inf) :- exceptional(_, rank), highest(N).

% Assign classical implications to the infinite rank if the highest rank is infinite
rank(classical(A, B), #inf) :- rank(N, #inf), rank(defeasible(A, B), _, N).

#show rank/2.
#show highest/1.