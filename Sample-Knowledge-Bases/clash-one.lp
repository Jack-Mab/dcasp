% ----------------------------
% BaseRank:
% ----------------------------
% ∞ :	{  }
% 0 :	{ (a1=>y0), (a0=>!y0) }
% ----------------------------
% Number of defeasible statements
#const n=2. 
defeasible(a0,y).
defeasible(a1,-y).