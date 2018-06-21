to_download=(pop1.csv ex1.csv);

for i in ${to_download[*]};
do
    if [ ! -f $i ];
        then wget http://pluto.huji.ac.il/~msby/StatThink/Datasets/$i;
    fi;
done;