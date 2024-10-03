% Answer: False

query(a11, a1). % Example query for Rational Closure

rank(classical(a3,a2),#inf).
rank(classical(a1,a0),#inf).
rank(classical(a4,a3),#inf).
rank(classical(a2,a1),#inf).
rank(defeasible(a4,-a5),4).
rank(defeasible(a2,-a5),2).
rank(defeasible(a0,-a5),0).
rank(defeasible(a1,a5),1).
rank(defeasible(a3,a5),3).
rank(defeasible(a31,a3),3).
rank(defeasible(a01,a0),0).
rank(defeasible(a21,a2),2).
rank(defeasible(a41,a4),4).
highest(4).