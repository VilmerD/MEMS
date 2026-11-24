function loss = ZNCC(F, G)
F = F - mean(F, "all");
G = G - mean(G, "all");
num = tensorprod(F, G, 'all');
den = norm(F, 'fro') * norm(G, 'fro');
loss = num / (den + 1e-16);
end