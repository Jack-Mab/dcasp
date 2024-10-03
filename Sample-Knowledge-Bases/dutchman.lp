% ----------------------------
% BaseRank:
% ----------------------------
% ∞ :	{  }
% 1 :	{ (flyingDutchman=>boat), (flyingDutchman=>leaky), (leaky=>boat), (leaky=>!floats) }
% 0 :	{ (boat=>floats) }
% ----------------------------

#const n=5.

defeasible(boat,floats;leaky,boat;leaky,-floats;flyingDutchman,boat;flyingDutchman,leaky).