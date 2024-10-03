% Answer: True

query(flyingDutchman, -floats). % Example query for Rational Closure

rank(defeasible(flyingDutchman,leaky),1).
rank(defeasible(flyingDutchman,boat),1).
rank(defeasible(leaky,-floats),1).
rank(defeasible(leaky,boat),1).
rank(defeasible(boat,floats),0).
highest(1).