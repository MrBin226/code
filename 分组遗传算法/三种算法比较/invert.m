function chromosome=invert(chromosome,chromindex,BinNo)

one=randi(BinNo);
two=randi(BinNo);
while(one==two)
    two=randi(BinNo);
end

temp=chromosome{chromindex,one};
chromosome{chromindex,one}=chromosome{chromindex,two};
chromosome{chromindex,two}=temp;

end