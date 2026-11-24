function loss = NCC(F, G)
num = sum(F.*G, 'all');
den = sqrt(sum(F.*F, 'all')*sum(G.*G, 'all'));
loss = num / (den + 1e-16);
end