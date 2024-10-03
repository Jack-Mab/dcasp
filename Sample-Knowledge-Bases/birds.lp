% ----------------------------
% BaseRank:
% ----------------------------
% ∞ :	{ (sparrow=>bird)}
% 2 :	{ (superPenguin=>penguin), (superPenguin=>fly) }
% 1 :	{ (penguin=>bird), (penguin=>!fly) }
% 0 :	{ (bird=>fly) }
% ----------------------------

#const n=5. % Number of defeasible statements
defeasible(bird,fly; penguin,bird; penguin,-fly; superPenguin,penguin; superPenguin,fly).
classical(sparrow, bird).