% Generation: generate the search space
rank(0..n).
{rank(defeasible(X, Y), 0..n)} = 1 :- defeasible(X, Y).

% Add all the classical statements to the infinite rank
rank(classical(X, Y), #inf) :- classical(X, Y).

% Two defeasible statements with the same antecedent can't be in two different ranks
N1 == N2 :- rank(defeasible(X, Y), N1), rank(defeasible(X, Z), N2).

% There are no gaps between ranks
% Mark all used ranks
used(N) :- rank(defeasible(X, Y), N).

% Ensure that if a rank N is used, then all ranks from 0 to N are also used
:- rank(M), not used(M), used(N), M < N.


% Mark each antecedent with its rank - I'll use "antecedent"
antecedent(X, N) :- rank(defeasible(X, Y), N).

% Create a "downwards" union of ranks for each antecedent and mark it with that antecedent and its rank.
% The union of rank 0 to rank n, where n is the rank of the antecedent (which can't be 0).
union(defeasible(A, B), X, N, down) :- antecedent(X, N), rank(defeasible(A, B), K), K = 0..N, N != 0.

% Add the antecedent to its union
union(part(X), X, N, down) :- union(defeasible(A, B), X, N, down).

% Add the classical implications to the union
union(defeasible(A, B), X, N, down) :- antecedent(X, N), classical(A, B).

% Derive all possible statements in each union
union(part(B), X, N, down) :- union(defeasible(A, B), X, N, down), union(part(A), X, N, down).
union(part(B), X, N, down) :- union(defeasible(A, B), X, N, down), A = top. % A is always true

% For each antecedent, check that it's exceptional in its union
exceptional(antecedent(X, N), union, down):- union(part(A), X, N, down), union(part(-A), X, N, down).

% Every antecedent must be exceptional in its "downwards" union
:- not exceptional(antecedent(X, N), union, down), antecedent(X, N), N != 0.

% Create an "upwards" union of ranks for each antecedent and mark it with that antecedent and its rank.
% The union of rank N to rank n, where N is the rank of the antecedent (which can't be N) and n is the last rank.
union(defeasible(A, B), X, N, up) :- antecedent(X, N), rank(defeasible(A, B), K), K = N..n, N != n.

% Add the antecedent to its union
union(part(X), X, N, up) :- union(defeasible(A, B), X, N, up).

% Add the classical implications to the union
union(defeasible(A, B), X, N, up) :- antecedent(X, N), classical(A, B).

% Derive all possible statements in each union
union(part(B), X, N, up) :- union(defeasible(A, B), X, N, up), union(part(A), X, N, up).
union(part(B), X, N, up) :- union(defeasible(A, B), X, N, up), A = top. % A is always true

% For each antecedent, check that it's exceptional in its upwards union
exceptional(antecedent(X, N), union, up):- union(part(A), X, N, up), union(part(-A), X, N, up).

% Every antecedent in an "upwards" rank must NOT be exceptional in its union
:- exceptional(antecedent(X, N), union, up), antecedent(X, N).

% Every antecedent must not be exceptional in its rank
% Rank/3 is used to check if the above condition is met
rank(defeasible(A, B), X, N) :- antecedent(X, N), rank(defeasible(A, B), N). %, K = 0..N, N != 0.

% Add the antecedent to its rank
rank(part(X), X, N) :- rank(defeasible(A, B), X, N).

% Derive all possible statements in each rank copy for each antecedent
rank(part(B), X, N) :- rank(defeasible(A, B), X, N), rank(part(A), X, N).
rank(part(B), X, N) :- rank(defeasible(A, B), X, N), A = top. % A is always true

% For each antecedent, check that it's exceptional in its rank copy
exceptional(antecedent(X, N), rank):- rank(part(A), X, N), rank(part(-A), X, N).

% Every antecedent (that is not in last rank) must NOT be exceptional in its rank
:- exceptional(antecedent(X, N), rank), antecedent(X, N), N != n.

% Every statement is assigned the lowest rank possible
#minimize{N, X, Y : rank(defeasible(X,Y), N)}.

% Get the number of the last rank
% Define a rule to find the highest rank
highest(N) :- rank(defeasible(A, B), N), not less_than(N).

% A rank N is not the highest if there is another value greater than N
less_than(N) :- rank(defeasible(A, B), N), rank(defeasible(C, D), M), M > N.

% Ensure there is exactly one highest rank
:- highest(N1), highest(N2), N1 != N2.

% If there's exceptional statements in the last rank, mark it infinite
rank(N, #inf) :- exceptional(antecedent(X, N), rank), antecedent(X, N), highest(N).

% If the last rank is marked infinite, add all the statements into the infinite rank
rank(classical(A, B), #inf) :- rank(N, #inf), rank(defeasible(A, B), X, N).

#show rank/2.
#show highest/1.