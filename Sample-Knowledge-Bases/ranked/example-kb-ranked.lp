% Answer: False

query(p, w).  % Example query for Rational Closure

rank(defeasible(f,a),0).
rank(defeasible(b,w),0).
rank(defeasible(p,b),1).
rank(defeasible(p,-f),1).
rank(defeasible(b,f),0).
highest(1).